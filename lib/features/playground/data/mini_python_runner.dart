// FILE: lib/features/playground/data/mini_python_runner.dart
//
// TUGAS: mesin Python mini yang BERJALAN LANGSUNG DI PERANGKAT siswa
// (commit #4 — bukan Docker, bukan server). Playground memakai ini agar
// tetap hidup & cepat lokal, selaras dengan cara penilaian di backend
// (internal/usecase/evaluator.go).
//
// SUBSET PYTHON YANG DIDUKUNG (WAJIB DIUBAH BILA menambah fitur):
// (1) Data: int, float, str (escape \n \t \\ \' \"), bool, None,
//     list literal [1, 2, 3] + indeks (termasuk indeks negatif).
// (2) Aritmetika: + - * / // % ** dengan urutan pengerjaan asli &
//     kurung. Perbandingan: == != > < >= <= dan logika and / or / not.
// (3) Percabangan if / elif / else; perulangan for ... in range/list/
//     string & while, plus break / continue / pass.
// (4) Fungsi def nama(arg): ... return ... (rekursi dibatasi 200 kedalaman).
// (5) Bawaan: print, input (lewat dialog onInput), len, str, int, float,
//     abs, min, max, round, sum, range, dan list.append.
// (6) f-string {expr} + format .Nf (contoh {rerata:.2f}).
// (7) Perlindungan: 100.000 langkah & 5 detik → RuntimeError (bukan hang),
//     kedalaman rekursi berlebih → RecursionError.
//
// BATAS SENGAJA (jangan dijanjikan ke siswa dulu): tidak ada dict,
// tidak ada class, tidak ada import modul.
import 'dart:async';
import 'dart:math' as math;

typedef InputPrompter = Future<String?> Function(String prompt);

class MiniPythonResult {
  const MiniPythonResult({required this.lines, required this.exitCode});

  final List<String> lines;
  final int exitCode;

  bool get ok => exitCode == 0;
}

class _PyError implements Exception {
  const _PyError(this.message);
  final String message;
}

class _BreakSignal implements Exception {
  const _BreakSignal();
}

class _ContinueSignal implements Exception {
  const _ContinueSignal();
}

class _ReturnSignal implements Exception {
  const _ReturnSignal(this.value);
  final Object? value;
}

class _PyFunction {
  const _PyFunction(this.name, this.params, this.body);
  final String name;
  final List<String> params;
  final List<String> body;
}

class _Range {
  const _Range(this.start, this.stop, this.step);
  final int start;
  final int stop;
  final int step;

  int get length {
    if (step == 0) return 0;
    final n = ((stop - start) / step).ceilToDouble();
    return n <= 0 ? 0 : n.toInt();
  }
}

// ---------------------------------------------------------------------------
// AST ringan ekspresi.
// ---------------------------------------------------------------------------
sealed class _Node {
  const _Node();
}

class _NumNode extends _Node {
  _NumNode(this.value);
  final num value;
}

class _StrNode extends _Node {
  _StrNode(this.value);
  final String value;
}

class _BoolNode extends _Node {
  _BoolNode(this.value);
  final bool value;
}

class _NoneNode extends _Node {
  const _NoneNode();
}

class _NameNode extends _Node {
  _NameNode(this.name);
  final String name;
}

class _ListNode extends _Node {
  _ListNode(this.items);
  final List<_Node> items;
}

class _FPart {
  _FPart(this.lit, this.expr, this.spec);
  final String lit; // teks literal sebelum bagian ini ('' bila di awal).
  final String? expr; // kode dalam {..} (null bila tak ada).
  final String? spec; // format .Nf (null bila tak ada).
}

class _FStrNode extends _Node {
  _FStrNode(this.parts);
  final List<_FPart> parts;
}

class _UnaryNode extends _Node {
  _UnaryNode(this.op, this.operand);
  final String op; // '-' atau 'not'
  final _Node operand;
}

class _BinaryNode extends _Node {
  _BinaryNode(this.op, this.left, this.right);
  final String op; // + - * / // % ** and or
  final _Node left;
  final _Node right;
}

class _CompareNode extends _Node {
  _CompareNode(this.op, this.left, this.right);
  final String op; // == != > < >= <=
  final _Node left;
  final _Node right;
}

class _CallNode extends _Node {
  _CallNode(this.name, this.args);
  final String name;
  final List<_Node> args;
}

class _IndexNode extends _Node {
  _IndexNode(this.base, this.index);
  final _Node base;
  final _Node index;
}

class _MethodNode extends _Node {
  _MethodNode(this.base, this.name, this.args);
  final _Node base;
  final String name;
  final List<_Node> args;
}

// ---------------------------------------------------------------------------
// Parser ekspresi (sinkron). Lexer mengembalikan daftar token.
// ---------------------------------------------------------------------------
class _Tok {
  const _Tok(this.k, this.v);
  final String k; // num | name | str | fstr | op
  final Object v;
}

class _Parser {
  _Parser(this.tokens);
  final List<_Tok> tokens;
  int _p = 0;

  bool get _eof => _p >= tokens.length;

  _Tok? _peek() => _eof ? null : tokens[_p];

  bool _matchOp(String v) {
    final t = _peek();
    if (t != null && t.k == 'op' && t.v == v) {
      _p++;
      return true;
    }
    return false;
  }

  String _expectOp(String v) {
    if (!_matchOp(v)) {
      throw _PyError("SyntaxError: expected '$v'");
    }
    return v;
  }

  String _name() {
    final t = _peek();
    if (t == null || t.k != 'name') {
      throw const _PyError('SyntaxError: invalid syntax');
    }
    _p++;
    return t.v as String;
  }

  List<_Node> _exprList() {
    final list = <_Node>[];
    final first = _peek();
    final opensArg = first != null && !(first.k == 'op' && first.v == ')');
    if (opensArg) {
      list.add(_or());
    }
    while (_matchOp(',')) {
      final next = _peek();
      if (next != null && next.k == 'op' && next.v == ')') {
        break; // koma di akhir argumen diperbolehkan (pythonic).
      }
      list.add(_or());
    }
    return list;
  }

  _Node _or() {
    var left = _and();
    while (_matchOp('or')) {
      left = _BinaryNode('or', left, _and());
    }
    return left;
  }

  _Node _and() {
    var left = _not();
    while (_matchOp('and')) {
      left = _BinaryNode('and', left, _not());
    }
    return left;
  }

  _Node _not() {
    if (_matchOp('not')) {
      return _UnaryNode('not', _not());
    }
    return _comparison();
  }

  _Node _comparison() {
    final left = _additive();
    for (final op in const ['==', '!=', '>=', '<=', '>', '<']) {
      if (_matchOp(op)) {
        return _CompareNode(op, left, _additive());
      }
    }
    return left;
  }

  _Node _additive() {
    var left = _multiplicative();
    for (;;) {
      if (_matchOp('+')) {
        left = _BinaryNode('+', left, _multiplicative());
      } else if (_matchOp('-')) {
        left = _BinaryNode('-', left, _multiplicative());
      } else {
        return left;
      }
    }
  }

  _Node _multiplicative() {
    var left = _unary();
    for (;;) {
      if (_matchOp('*')) {
        left = _BinaryNode('*', left, _unary());
      } else if (_matchOp('/')) {
        left = _BinaryNode('/', left, _unary());
      } else if (_matchOp('//')) {
        left = _BinaryNode('//', left, _unary());
      } else if (_matchOp('%')) {
        left = _BinaryNode('%', left, _unary());
      } else {
        return left;
      }
    }
  }

  _Node _unary() {
    if (_matchOp('-')) {
      return _UnaryNode('-', _unary());
    }
    return _power();
  }

  _Node _power() {
    final base = _postfix();
    if (_matchOp('**')) {
      return _BinaryNode('**', base, _unary()); // asosiasi kanan.
    }
    return base;
  }

  _Node _postfix() {
    var node = _primary();
    for (;;) {
      if (_matchOp('.')) {
        final name = _name();
        _expectOp('(');
        final args = _exprList();
        _expectOp(')');
        node = _MethodNode(node, name, args);
      } else if (_matchOp('[')) {
        final idx = _or();
        _expectOp(']');
        node = _IndexNode(node, idx);
      } else {
        return node;
      }
    }
  }

  _Node _primary() {
    final t = _peek();
    if (t == null) throw const _PyError('SyntaxError: invalid syntax');
    switch (t.k) {
      case 'num':
        _p++;
        return _NumNode(t.v as num);
      case 'str':
        _p++;
        return _StrNode(t.v as String);
      case 'fstr':
        _p++;
        return _FStrNode(t.v as List<_FPart>);
      case 'name':
        _p++;
        final name = t.v as String;
        if (name == 'True') return _BoolNode(true);
        if (name == 'False') return _BoolNode(false);
        if (name == 'None') return const _NoneNode();
        if (_matchOp('(')) {
          final args = _exprList();
          _expectOp(')');
          return _CallNode(name, args);
        }
        return _NameNode(name);
      default:
        if (t.v == '(') {
          _p++;
          final e = _or();
          _expectOp(')');
          return e;
        }
        if (t.v == '[') {
          _p++;
          final items = <_Node>[];
          final nxt = _peek();
          final closed = nxt != null && nxt.k == 'op' && nxt.v == ']';
          if (!closed) {
            items.addAll(_exprList());
          }
          _expectOp(']');
          return _ListNode(items);
        }
        throw const _PyError('SyntaxError: invalid syntax');
    }
  }
}

List<_Tok> _tokenize(String src) {
  final out = <_Tok>[];
  var i = 0;
  while (i < src.length) {
    final c = src[i];
    if (c == ' ' || c == '\t') {
      i++;
      continue;
    }
    if (c == '#') break;

    if (_isDigit(c) || (c == '.' && i + 1 < src.length && _isDigit(src[i + 1]))) {
      var j = i;
      var sawDot = false;
      var sawExp = false;
      while (j < src.length) {
        final d = src[j];
        if (_isDigit(d) || d == '_') {
          j++;
          continue;
        }
        if (d == '.' && !sawDot && !sawExp) {
          sawDot = true;
          j++;
          continue;
        }
        if ((d == 'e' || d == 'E') && !sawExp && j > i) {
          final nx = j + 1 < src.length ? src[j + 1] : ' ';
          if (_isDigit(nx) ||
              ((nx == '+' || nx == '-') && j + 2 < src.length && _isDigit(src[j + 2]))) {
            sawExp = true;
            j += (nx == '+' || nx == '-') ? 2 : 1;
            continue;
          }
          break;
        }
        break;
      }
      final text = src.substring(i, j).replaceAll('_', '');
      final value = text.contains('.') || text.toLowerCase().contains('e')
          ? double.tryParse(text)
          : int.tryParse(text);
      if (value == null) {
        throw _PyError("SyntaxError: invalid decimal literal '$text'");
      }
      out.add(_Tok('num', value));
      i = j;
      continue;
    }

    if (_isNameStart(c)) {
      var j = i;
      while (j < src.length && (_isNameStart(src[j]) || _isDigit(src[j]))) {
        j++;
      }
      final name = src.substring(i, j);
      if (name == 'f' && j < src.length && (src[j] == '"' || src[j] == "'")) {
        final result = _readFString(src, j, src[j]);
        out.add(_Tok('fstr', result.$1));
        i = result.$2;
        continue;
      }
      out.add(_Tok('name', name));
      i = j;
      continue;
    }

    if (c == '"' || c == "'") {
      final result = _readStringLiteral(src, i, c);
      out.add(_Tok('str', result.$1));
      i = result.$2;
      continue;
    }

    final two = i + 1 < src.length ? src.substring(i, i + 2) : '';
    if (two == '**' ||
        two == '//' ||
        two == '!=' ||
        two == '>=' ||
        two == '<=' ||
        two == '==') {
      out.add(_Tok('op', two));
      i += 2;
      continue;
    }
    if ('+-*/%()[],.<>'.contains(c)) {
      out.add(_Tok('op', c));
      i++;
      continue;
    }
    throw _PyError("SyntaxError: invalid character '$c'");
  }
  return out;
}

bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
bool _isNameStart(String c) =>
    c == '_' ||
    (c.codeUnitAt(0) >= 97 && c.codeUnitAt(0) <= 122) ||
    (c.codeUnitAt(0) >= 65 && c.codeUnitAt(0) <= 90);

(String, int) _readStringLiteral(String src, int start, String quote) {
  final buf = StringBuffer();
  var i = start + 1;
  while (i < src.length) {
    final c = src[i];
    if (c == '\\') {
      if (i + 1 >= src.length) {
        throw const _PyError('SyntaxError: trailing backslash');
      }
      final n = src[i + 1];
      buf.write(switch (n) {
        'n' => '\n',
        't' => '\t',
        'r' => '\r',
        '\\' => '\\',
        "'" => "'",
        '"' => '"',
        _ => n, // escape tak dikenal diberlakukan longgar.
      });
      i += 2;
      continue;
    }
    if (c == quote) {
      return (buf.toString(), i + 1);
    }
    buf.write(c);
    i++;
  }
  throw const _PyError('SyntaxError: string tidak ditutup');
}

(List<_FPart>, int) _readFString(String src, int quotePos, String quote) {
  final parts = <_FPart>[];
  final litBuf = StringBuffer();
  var i = quotePos + 1;
  while (i < src.length) {
    final c = src[i];
    if (c == '\\') {
      if (i + 1 >= src.length) {
        throw const _PyError('SyntaxError: trailing backslash');
      }
      final n = src[i + 1];
      litBuf.write(switch (n) {
        'n' => '\n',
        't' => '\t',
        'r' => '\r',
        '\\' => '\\',
        "'" => "'",
        '"' => '"',
        _ => n,
      });
      i += 2;
      continue;
    }
    if (c == quote) {
      parts.add(_FPart(litBuf.toString(), null, null));
      return (parts, i + 1);
    }
    if (c == '{') {
      if (i + 1 < src.length && src[i + 1] == '{') {
        litBuf.write('{');
        i += 2;
        continue;
      }
      parts.add(_FPart(litBuf.toString(), null, null));
      litBuf.clear();
      var depth = 1;
      final exprBuf = StringBuffer();
      i++;
      while (i < src.length && depth > 0) {
        final e = src[i];
        if (e == '{') {
          depth++;
        } else if (e == '}') {
          depth--;
          if (depth == 0) break;
        }
        if (depth > 0) {
          exprBuf.write(e);
        }
        i++;
      }
      if (depth != 0) {
        throw const _PyError("SyntaxError: f-string: tanda '}' tidak ditemukan");
      }
      i++; // lewati } penutup.
      var expr = exprBuf.toString().trim();
      String? spec;
      final colon = _topColonIndex(expr);
      if (colon >= 0) {
        spec = expr.substring(colon + 1).trim();
        expr = expr.substring(0, colon).trim();
      }
      if (expr.isEmpty) {
        throw const _PyError('SyntaxError: f-string: ekspresi kosong');
      }
      parts.add(_FPart('', expr, spec));
      continue;
    }
    if (c == '}') {
      if (i + 1 < src.length && src[i + 1] == '}') {
        litBuf.write('}');
        i += 2;
        continue;
      }
      throw const _PyError("SyntaxError: f-string: tanda '}' di luar {..}");
    }
    litBuf.write(c);
    i++;
  }
  throw const _PyError('SyntaxError: f-string tidak ditutup');
}

int _topColonIndex(String expr) {
  var q = '';
  for (var i = 0; i < expr.length; i++) {
    final c = expr[i];
    if (q.isNotEmpty) {
      if (c == q) q = '';
      continue;
    }
    if (c == '"' || c == "'") {
      q = c;
      continue;
    }
    if (c == ':') return i;
  }
  return -1;
}

// ---------------------------------------------------------------------------
// Interpreter.
// ---------------------------------------------------------------------------
class _State {
  _State(this.globals, this.out, this.onInput);
  final Map<String, Object?> globals;
  final List<String> out;
  final InputPrompter? onInput;
  int steps = 0;
  int depth = 0;
  final Stopwatch clock = Stopwatch()..start();

  void tick() {
    steps++;
    if (steps % 4096 == 0 && clock.elapsedMilliseconds >= 5000) {
      throw const _PyError('RuntimeError: program dihentikan (melewati batas 5 detik)');
    }
    if (steps >= 100000) {
      throw const _PyError(
          'RuntimeError: program dihentikan — melewati 100.000 langkah '
          '(periksa perulangan tanpa ujung)');
    }
  }
}

class _Frame {
  const _Frame(this.globals, this.locals);
  final Map<String, Object?> globals;
  final Map<String, Object?> locals; // frame atas = alias globals (same objek).
}

class MiniPythonRunner {
  // 60 kedalaman cukup untuk pelajaran (faktorial, titik dasar) sambil
  // aman dari stack esekusi dart yang dalam (tiap panggilan python
  // menumpuk beberapa frame async).
  static const int maxDepth = 60;

  Future<MiniPythonResult> run(
    String code, {
    InputPrompter? onInput,
  }) async {
    final out = <String>[];
    final globals = <String, Object?>{};
    final state = _State(globals, out, onInput);
    final lines = _prepLines(code);
    try {
      await _runBody(lines, _Frame(globals, globals), state);
      return MiniPythonResult(lines: out, exitCode: 0);
    } on _PyError catch (e) {
      return MiniPythonResult(lines: [...out, e.message], exitCode: 1);
    } on _BreakSignal {
      return MiniPythonResult(
        lines: [...out, 'SyntaxError: "break" di luar perulangan'],
        exitCode: 1,
      );
    } on _ContinueSignal {
      return MiniPythonResult(
        lines: [...out, 'SyntaxError: "continue" di luar perulangan'],
        exitCode: 1,
      );
    } on _ReturnSignal {
      return MiniPythonResult(
        lines: [...out, "SyntaxError: 'return' di luar fungsi"],
        exitCode: 1,
      );
    }
  }

  static List<String> _prepLines(String code) =>
      code.split('\n').map(_stripComment).toList();

  static String _stripComment(String raw) {
    final buf = StringBuffer();
    var q = '';
    for (var i = 0; i < raw.length; i++) {
      final c = raw[i];
      if (q.isNotEmpty) {
        if (c == '\\' && i + 1 < raw.length) {
          buf.write(raw[i]);
          buf.write(raw[i + 1]);
          i++;
          continue;
        }
        if (c == q) q = '';
        buf.write(c);
        continue;
      }
      if (c == '"' || c == "'") {
        q = c;
        buf.write(c);
        continue;
      }
      if (c == '#') break;
      if (c == '\t') {
        buf.write('    '); // tab di luar string diperlakukan sebagai indent.
        continue;
      }
      buf.write(c);
    }
    return buf.toString();
  }

  static int _indentOf(String line) => line.length - line.trimLeft().length;

  /// Menjalankan sekumpulan baris yang masih ber-indent mentah (kumpulan
  /// garis tubuh). Indentasi dasar dihapus supaya garis bekerja dari kolom 0.
  Future<void> _runBody(
    List<String> bodyLines,
    _Frame frame,
    _State state,
  ) async {
    var base = -1;
    for (final line in bodyLines) {
      if (line.trim().isNotEmpty) {
        base = _indentOf(line);
        break;
      }
    }
    if (base == -1) return;
    final rel = <String>[];
    for (final line in bodyLines) {
      if (line.trim().isEmpty) {
        rel.add('');
        continue;
      }
      final d = _indentOf(line);
      if (d < base) {
        throw const _PyError(
            'IndentationError: unindent does not match any outer indentation level');
      }
      rel.add(line.substring(base));
    }
    await _execOutline(rel, frame, state);
  }

  /// Menjalankan daftar baris yang indentasinya sudah normalisasi (mulai kitu 0).
  Future<void> _execOutline(
    List<String> lines,
    _Frame frame,
    _State state,
  ) async {
    var i = 0;
    while (i < lines.length) {
      final raw = lines[i];
      final text = raw.trim();
      if (text.isEmpty) {
        i++;
        continue;
      }
      final indent = _indentOf(raw);
      if (indent > 0) {
        throw const _PyError('IndentationError: unexpected indent');
      }
      state.tick();
      i = await _dispatch(lines, i, text, frame, state);
    }
  }

  /// Mengumpulkan tubuh blok (garis ber-indent lebih dalam dari induk).
  static (List<String>, int) _gatherChild(
    List<String> lines,
    int start,
    int parentIndent,
  ) {
    final body = <String>[];
    var j = start;
    var base = -1;
    while (j < lines.length) {
      final bt = lines[j].trim();
      if (bt.isEmpty) {
        j++;
        continue;
      }
      final bd = _indentOf(lines[j]);
      if (bd <= parentIndent) break;
      if (base == -1) base = bd;
      body.add(lines[j]);
      j++;
    }
    return (body, j);
  }

  /// Pusat dispatch satu pernyataan; mengembalikan indeks berikutnya.
  Future<int> _dispatch(
    List<String> lines,
    int i,
    String text,
    _Frame frame,
    _State state,
  ) async {
    final indent = _indentOf(lines[i]);

    // --- Percabangan if / elif / else --------------------------------
    if (text.startsWith('if ') || text.startsWith('elif ')) {
      if (!text.endsWith(':')) {
        throw const _PyError("SyntaxError: expected ':'");
      }
      final branches = <(String, List<String>)>[]; // (kondisi, tubuh)
      final elseFlags = <bool>[];
      var j = i;
      while (j < lines.length) {
        final t = lines[j].trim();
        if (t.isEmpty) {
          j++;
          continue;
        }
        final jd = _indentOf(lines[j]);
        if (jd < indent) break;
        if (jd > indent) break;
        final first = branches.isEmpty;
        if (first && t.startsWith('if ')) {
          branches.add((t.substring(3, t.length - 1).trim(), <String>[]));
          elseFlags.add(false);
        } else if (!first && t.startsWith('elif ') && t.endsWith(':')) {
          branches.add((t.substring(5, t.length - 1).trim(), <String>[]));
          elseFlags.add(false);
        } else if (!first && t == 'else:') {
          branches.add(('True', <String>[]));
          elseFlags.add(true);
        } else {
          break;
        }
        final headIndent = jd;
        j++;
        final gathered = _gatherChild(lines, j, headIndent);
        branches.last.$2.addAll(gathered.$1);
        j = gathered.$2;
        if (elseFlags.last) break;
      }
      for (var k = 0; k < branches.length; k++) {
        state.tick();
        final cond = branches[k].$1;
        if (elseFlags[k] ||
            _truthy(await _eval(_parseExpr(cond), frame, state))) {
          await _runBody(branches[k].$2, frame, state);
          break;
        }
      }
      return j;
    }

    if (text == 'else:' || text.startsWith('elif ')) {
      throw const _PyError('SyntaxError: invalid syntax (elif/else tanpa if)');
    }

    // --- Perulangan for -----------------------------------------------
    final forM = RegExp(r'^for\s+([A-Za-z_]\w*)\s+in\s+(.+):$').firstMatch(text);
    if (forM != null) {
      final varName = forM.group(1)!;
      final gathered = _gatherChild(lines, i + 1, indent);
      final body = gathered.$1;
      if (body.isEmpty) {
        throw const _PyError('IndentationError: expected an indented block');
      }
      final iterable = await _evalIterable(_parseExpr(forM.group(2)!.trim()), frame, state);
      for (final value in iterable) {
        state.tick();
        frame.locals[varName] = value;
        try {
          await _runBody(body, frame, state);
        } on _BreakSignal {
          break;
        } on _ContinueSignal {
          continue;
        }
      }
      return gathered.$2;
    }

    // --- Perulangan while ---------------------------------------------
    final whileM = RegExp(r'^while\s+(.+):$').firstMatch(text);
    if (whileM != null) {
      final gathered = _gatherChild(lines, i + 1, indent);
      final body = gathered.$1;
      if (body.isEmpty) {
        throw const _PyError('IndentationError: expected an indented block');
      }
      final condSrc = whileM.group(1)!.trim();
      while (_truthy(await _eval(_parseExpr(condSrc), frame, state))) {
        state.tick();
        try {
          await _runBody(body, frame, state);
        } on _BreakSignal {
          break;
        } on _ContinueSignal {
          continue;
        }
      }
      return gathered.$2;
    }

    // --- Definisi fungsi -----------------------------------------------
    final defM = RegExp(r'^def\s+([A-Za-z_]\w*)\s*\((.*)\):$').firstMatch(text);
    if (defM != null) {
      final gathered = _gatherChild(lines, i + 1, indent);
      final body = gathered.$1;
      if (body.isEmpty) {
        throw const _PyError('IndentationError: expected an indented block');
      }
      final paramsRaw = defM.group(2)!.trim();
      final params = paramsRaw.isEmpty
          ? <String>[]
          : paramsRaw.split(',').map((e) => e.trim()).toList();
      for (final p in params) {
        if (!RegExp(r'^[A-Za-z_]\w*$').hasMatch(p)) {
          throw _PyError('SyntaxError: paramater tidak valid -> $p');
        }
      }
      state.globals[defM.group(1)!] = _PyFunction(defM.group(1)!, params, body);
      return gathered.$2;
    }

    // --- return / break / continue / pass --------------------------------
    if (text == 'pass') return i + 1;
    if (text == 'break') throw const _BreakSignal();
    if (text == 'continue') throw const _ContinueSignal();
    final returnM = RegExp(r'^return(?:\s+(.+))?$').firstMatch(text);
    if (returnM != null) {
      final exprSrc = returnM.group(1)?.trim();
      final value = (exprSrc == null || exprSrc.isEmpty)
          ? null
          : await _eval(_parseExpr(exprSrc), frame, state);
      throw _ReturnSignal(value);
    }

    // --- Penugasan ---------------------------------------------------------
    final assignM = RegExp(
      r'^([A-Za-z_]\w*)(\[([^\]]+)\])?\s*(\+=|-=|\*=|/=|//=|%=|\*\*=|=(?!=))\s*(.+)$',
    ).firstMatch(text);
    if (assignM != null) {
      final name = assignM.group(1)!;
      final idxSrc = assignM.group(3);
      final op = assignM.group(4)!;
      final rhsSrc = assignM.group(5)!;

      if (op == '=') {
        final value = await _eval(_parseExpr(rhsSrc), frame, state);
        if (idxSrc == null) {
          frame.locals[name] = value;
        } else {
          final container = _lookup(name, frame, state);
          final idx = await _eval(_parseExpr(idxSrc.trim()), frame, state);
          _storeIndex(container, idx, value);
        }
        return i + 1;
      }
      final binOp = switch (op) {
        '+=' => '+',
        '-=' => '-',
        '*=' => '*',
        '/=' => '/',
        '//=' => '//',
        '%=' => '%',
        _ => '**',
      };
      final rhs = await _eval(_parseExpr(rhsSrc), frame, state);
      if (idxSrc == null) {
        final cur = _lookup(name, frame, state);
        frame.locals[name] = _arith(binOp, cur, rhs);
      } else {
        final container = _lookup(name, frame, state);
        final idx = await _eval(_parseExpr(idxSrc.trim()), frame, state);
        final cur = _readIndex(container, idx);
        _storeIndex(container, idx, _arith(binOp, cur, rhs));
      }
      return i + 1;
    }

    // --- Pernyataan ekspresi (print / panggilan fungsi) ---------------------
    await _eval(_parseExpr(text), frame, state);
    return i + 1;
  }

  _Node _parseExpr(String src) {
    final parser = _Parser(_tokenize(src));
    final node = parser._or();
    if (!parser._eof) {
      throw const _PyError('SyntaxError: invalid syntax');
    }
    return node;
  }

  Future<List<Object?>> _evalIterable(
    _Node node,
    _Frame frame,
    _State state,
  ) async {
    final v = await _eval(node, frame, state);
    if (v is _Range) {
      return <Object?>[for (var k = 0; k < v.length; k++) v.start + k * v.step];
    }
    if (v is List) return v.cast<Object?>();
    if (v is String) {
      return <Object?>[for (final r in v.runes) String.fromCharCode(r)];
    }
    throw _PyError("TypeError: '${_typeName(v)}' object is not iterable");
  }

  // --- Evaluasi ekspresi ----------------------------------------------------
  Future<Object?> _eval(_Node node, _Frame frame, _State state) async {
    switch (node) {
      case final _NumNode n:
        return n.value;
      case final _StrNode s:
        return s.value;
      case final _BoolNode b:
        return b.value;
      case final _NoneNode _:
        return null;
      case final _FStrNode f:
        final buf = StringBuffer();
        for (final part in f.parts) {
          buf.write(part.lit);
          final exprSrc = part.expr;
          if (exprSrc != null) {
            final v = await _eval(_parseExpr(exprSrc), frame, state);
            final spec = part.spec;
            if (spec != null && spec.startsWith('.') && spec.endsWith('f')) {
              final digits =
                  int.tryParse(spec.substring(1, spec.length - 1)) ?? 2;
              buf.write(v is num ? v.toDouble().toStringAsFixed(digits) : _str(v));
            } else {
              buf.write(_str(v));
            }
          }
        }
        return buf.toString();
      case final _NameNode n:
        return _lookup(n.name, frame, state);
      case final _ListNode l:
        final out = <Object?>[];
        for (final item in l.items) {
          out.add(await _eval(item, frame, state));
        }
        return out;
      case final _UnaryNode u:
        final v = await _eval(u.operand, frame, state);
        if (u.op == '-') {
          if (v is num) return -v;
          throw _PyError(
              "TypeError: bad operand type for unary -: '${_typeName(v)}'");
        }
        return !_truthy(v);
      case final _BinaryNode b:
        if (b.op == 'or') {
          final l = await _eval(b.left, frame, state);
          return _truthy(l) ? l : await _eval(b.right, frame, state);
        }
        if (b.op == 'and') {
          final l = await _eval(b.left, frame, state);
          return !_truthy(l) ? l : await _eval(b.right, frame, state);
        }
        final l = await _eval(b.left, frame, state);
        final r = await _eval(b.right, frame, state);
        return _arith(b.op, l, r);
      case final _CompareNode c:
        final l = await _eval(c.left, frame, state);
        final r = await _eval(c.right, frame, state);
        return switch (c.op) {
          '==' => _pyEq(l, r),
          '!=' => !_pyEq(l, r),
          _ => _orderCompare(c.op, l, r),
        };
      case final _IndexNode ix:
        final base = await _eval(ix.base, frame, state);
        final key = await _eval(ix.index, frame, state);
        return _readIndex(base, key);
      case final _MethodNode m:
        final base = await _eval(m.base, frame, state);
        final args = <Object?>[];
        for (final a in m.args) {
          args.add(await _eval(a, frame, state));
        }
        if (base is List && m.name == 'append' && args.length == 1) {
          base.add(args.first);
          return null;
        }
        throw _PyError(
            "AttributeError: '${_typeName(base)}' object has no attribute '${m.name}'");
      case final _CallNode call:
        final args = <Object?>[];
        for (final a in call.args) {
          args.add(await _eval(a, frame, state));
        }
        return _call(call.name, args, frame, state);
    }
  }

  Object? _lookup(String name, _Frame frame, _State state) {
    final locals = frame.locals;
    if (locals.containsKey(name)) return locals[name];
    if (state.globals.containsKey(name)) return state.globals[name];
    throw _PyError("NameError: name '$name' is not defined");
  }

  Future<Object?> _call(
    String name,
    List<Object?> args,
    _Frame frame,
    _State state,
  ) async {
    final fnRaw = frame.locals.containsKey(name)
        ? frame.locals[name]
        : state.globals[name];
    if (fnRaw is _PyFunction) {
      if (args.length != fnRaw.params.length) {
        throw _PyError(
            'TypeError: ${fnRaw.name}() takes ${fnRaw.params.length} positional argument${fnRaw.params.length == 1 ? '' : 's'} but ${args.length} ${args.length == 1 ? 'was' : 'were'} given');
      }
      if (state.depth >= maxDepth) {
        throw const _PyError('RecursionError: maximum recursion depth exceeded');
      }
      state.depth++;
      try {
        final locals = <String, Object?>{};
        for (var k = 0; k < fnRaw.params.length; k++) {
          locals[fnRaw.params[k]] = args[k];
        }
        final sub = _Frame(state.globals, locals);
        try {
          await _runBody(fnRaw.body, sub, state);
        } on _ReturnSignal catch (sig) {
          return sig.value;
        }
        return null;
      } finally {
        state.depth--;
      }
    }

    switch (name) {
      case 'print':
        state.out.add(args.map(_str).join(' '));
        return null;
      case 'input':
        final prompter = state.onInput;
        if (prompter == null) {
          throw const _PyError(
              'RuntimeError: input() butuh dialog — jalankan dari halaman Playground');
        }
        final prompt = args.isEmpty ? '' : _str(args.first);
        final raw = await prompter(prompt);
        return raw ?? '';
      case 'len':
        if (args.length != 1) {
          throw const _PyError('TypeError: len() takes exactly one argument');
        }
        final v = args.first;
        if (v is String) return v.runes.length;
        if (v is List) return v.length;
        if (v is _Range) return v.length;
        throw _PyError("TypeError: object of type '${_typeName(v)}' has no len()");
      case 'str':
        if (args.length != 1) {
          throw const _PyError('TypeError: str() takes exactly one argument');
        }
        return _str(args.first);
      case 'int':
        if (args.isEmpty) return 0;
        final v = args.first;
        if (v is bool) return v ? 1 : 0;
        if (v is int) return v;
        if (v is double) return v.truncate();
        if (v is String) {
          final parsed = int.tryParse(v.trim());
          if (parsed != null) return parsed;
          throw _PyError(
              "ValueError: invalid literal for int() with base 10: '${_repr(v)}'");
        }
        throw _PyError(
            "TypeError: int() argument must be a string or a number, not '${_typeName(v)}'");
      case 'float':
        if (args.isEmpty) return 0.0;
        final v = args.first;
        if (v is bool) return (v ? 1 : 0).toDouble();
        if (v is num) return v.toDouble();
        if (v is String) {
          final parsed = double.tryParse(v.trim());
          if (parsed != null) return parsed;
          throw _PyError(
              "ValueError: could not convert string to float: '${_repr(v)}'");
        }
        throw _PyError(
            "TypeError: float() argument must be a string or a number, not '${_typeName(v)}'");
      case 'abs':
        if (args.length != 1) {
          throw const _PyError('TypeError: abs() takes exactly one argument');
        }
        final v = args.first;
        if (v is num) return v.abs();
        throw _PyError("TypeError: bad operand type for abs(): '${_typeName(v)}'");
      case 'min':
      case 'max':
        if (args.isEmpty) {
          throw _PyError('TypeError: $name() expected at least 1 argument, got 0');
        }
        final pool = args.length == 1 && args.first is List
            ? (args.first as List).cast<Object?>()
            : args;
        if (pool.isEmpty) {
          throw _PyError('ValueError: $name() arg is an empty sequence');
        }
        Object? best = pool.first;
        final preferred = name == 'min' ? '<' : '>';
        for (final v in pool.skip(1)) {
          if (_orderCompare(preferred, v, best)) best = v;
        }
        return best;
      case 'round':
        if (args.isEmpty) {
          throw const _PyError('TypeError: round() missing required argument');
        }
        final v = args.first;
        if (v is! num) {
          throw _PyError(
              "TypeError: type ${_typeName(v)} doesn't define __round__ method");
        }
        if (args.length >= 2 && args[1] != null) {
          final nd = _asInt(args[1]);
          final scale = math.pow(10.0, nd).toDouble();
          return _roundEven(v * scale) / scale;
        }
        return _roundEven(v);
      case 'sum':
        if (args.isEmpty || args.first is! List) {
          throw const _PyError('TypeError: sum() membutuhkan list sebagai argumen pertama');
        }
        num acc = 0;
        for (final item in (args.first as List).cast<Object?>()) {
          if (item is! num) {
            throw _PyError(
                "TypeError: unsupported operand type(s) for +: 'int' and '${_typeName(item)}'");
          }
          acc += item;
        }
        return acc;
      case 'range':
        if (args.isEmpty || args.length > 3) {
          throw _PyError(
              'TypeError: range() expected at most 3 arguments, got ${args.length}');
        }
        final list = args.map(_asInt).toList();
        final int a;
        final int b;
        final int c;
        if (list.length == 1) {
          a = 0;
          b = list[0];
          c = 1;
        } else {
          a = list[0];
          b = list[1];
          c = list.length == 3 ? list[2] : 1;
        }
        if (c == 0) {
          throw const _PyError('ValueError: range() arg 3 must not be zero');
        }
        return _Range(a, b, c);
    }
    if (fnRaw == null) {
      throw _PyError("NameError: name '$name' is not defined");
    }
    throw _PyError(
        "TypeError: '${_typeName(fnRaw)}' object is not callable");
  }

  void _storeIndex(Object? container, Object? key, Object? value) {
    if (container is List) {
      final i = _asInt(key);
      final n = i < 0 ? i + container.length : i;
      if (n < 0 || n >= container.length) {
        throw const _PyError('IndexError: list assignment index out of range');
      }
      container[n] = value;
      return;
    }
    throw _PyError(
        "TypeError: '${_typeName(container)}' object does not support item assignment");
  }

  Object? _readIndex(Object? container, Object? key) {
    if (container is List) {
      final i = _asInt(key);
      final n = i < 0 ? i + container.length : i;
      if (n < 0 || n >= container.length) {
        throw const _PyError('IndexError: list index out of range');
      }
      return container[n];
    }
    if (container is String) {
      final runes = container.runes.toList();
      final i = _asInt(key);
      final n = i < 0 ? i + runes.length : i;
      if (n < 0 || n >= runes.length) {
        throw const _PyError('IndexError: string index out of range');
      }
      return String.fromCharCode(runes[n]);
    }
    throw _PyError(
        "TypeError: '${_typeName(container)}' object is not subscriptable");
  }

  Object? _arith(String op, Object? l, Object? r) {
    switch (op) {
      case '+':
        if (l is num && r is num) return l + r;
        if (l is String && r is String) return l + r;
        if (l is List && r is List) return [...l, ...r];
        throw _PyError(
            "TypeError: unsupported operand type(s) for +: '${_typeName(l)}' and '${_typeName(r)}'");
      case '-':
        if (l is num && r is num) return l - r;
        throw _PyError(
            "TypeError: unsupported operand type(s) for -: '${_typeName(l)}' and '${_typeName(r)}'");
      case '*':
        if (l is num && r is num) return l * r;
        if (l is String && r is int) return _repeatStr(l, r);
        if (l is String && r is double) {
          throw const _PyError(
              "TypeError: can't multiply sequence by non-int of type 'float'");
        }
        if (l is int && r is String) return _repeatStr(r, l);
        if (l is double && r is String) {
          throw const _PyError(
              "TypeError: can't multiply sequence by non-int of type 'float'");
        }
        if (l is List && r is int) {
          final out = <Object?>[];
          for (var k = 0; k < (r > 0 ? r : 0); k++) {
            out.addAll(l);
          }
          return out;
        }
        if (l is List && r is double) {
          throw const _PyError(
              "TypeError: can't multiply sequence by non-int of type 'float'");
        }
        if (l is int && r is List) {
          final out = <Object?>[];
          for (var k = 0; k < (l > 0 ? l : 0); k++) {
            out.addAll(r);
          }
          return out;
        }
        throw _PyError(
            "TypeError: can't multiply sequence by non-int of type '${_typeName(r)}'");
      case '/':
        if (l is num && r is num) {
          if (r == 0) throw const _PyError('ZeroDivisionError: division by zero');
          return l / r;
        }
        throw _PyError(
            "TypeError: unsupported operand type(s) for /: '${_typeName(l)}' and '${_typeName(r)}'");
      case '//':
        if (l is num && r is num) {
          if (r == 0) {
            throw const _PyError('ZeroDivisionError: integer division or modulo by zero');
          }
          if (l is int && r is int) {
            var q = l ~/ r;
            if (l % r != 0 && (l < 0) != (r < 0)) q--;
            return q;
          }
          return (l / r).floorToDouble();
        }
        throw _PyError(
            "TypeError: unsupported operand type(s) for //: '${_typeName(l)}' and '${_typeName(r)}'");
      case '%':
        if (l is num && r is num) {
          if (r == 0) {
            throw const _PyError('ZeroDivisionError: integer division or modulo by zero');
          }
          if (l is int && r is int) {
            var rem = l.remainder(r);
            if (rem != 0 && rem.sign != r.sign) rem = rem + r;
            return rem;
          }
          var rem = l.remainder(r);
          if (rem != 0 && rem.sign != r.sign) rem = rem + r;
          return rem;
        }
        throw _PyError(
            "TypeError: unsupported operand type(s) for %: '${_typeName(l)}' and '${_typeName(r)}'");
      case '**':
        if (l is num && r is num) {
          if (l is int && r is int && r >= 0) {
            num acc = 1;
            for (var k = 0; k < r; k++) {
              acc *= l;
            }
            return acc;
          }
          return math.pow(l.toDouble(), r.toDouble()).toDouble();
        }
        throw _PyError(
            "TypeError: unsupported operand type(s) for **: '${_typeName(l)}' and '${_typeName(r)}'");
    }
    throw _PyError("TypeError: operator '$op' tidak dikenal");
  }

  String _repeatStr(String s, int n) {
    final k = n > 0 ? n : 0;
    final buf = StringBuffer();
    for (var i = 0; i < k; i++) {
      buf.write(s);
    }
    return buf.toString();
  }

  bool _orderCompare(String op, Object? a, Object? b) {
    if (a is num && b is num) {
      return switch (op) {
        '>' => a > b,
        '<' => a < b,
        '>=' => a >= b,
        _ => a <= b,
      };
    }
    if (a is String && b is String) {
      final c = a.compareTo(b);
      return switch (op) {
        '>' => c > 0,
        '<' => c < 0,
        '>=' => c >= 0,
        _ => c <= 0,
      };
    }
    throw _PyError(
        "TypeError: '$op' not supported between instances of '${_typeName(a)}' and '${_typeName(b)}'");
  }

  bool _pyEq(Object? a, Object? b) {
    if (a is num && b is num) return a == b;
    if (a is String && b is String) return a == b;
    if (a is bool && b is bool) return a == b;
    if (a == null || b == null) return (a == null) == (b == null);
    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (var i = 0; i < a.length; i++) {
        if (!_pyEq(a[i], b[i])) return false;
      }
      return true;
    }
    return false;
  }

  bool _truthy(Object? v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v.isNotEmpty;
    if (v is List) return v.isNotEmpty;
    if (v == null) return false;
    return true;
  }

  int _asInt(Object? v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final parsed = int.tryParse(v.trim());
      if (parsed != null) return parsed;
    }
    throw _PyError(
        "TypeError: '${_typeName(v)}' object cannot be interpreted as an integer");
  }

  num _roundEven(num v) {
    final f = v.floor();
    final diff = v - f;
    if (diff.abs() < 0.5) return f;
    if (diff.abs() > 0.5) return f + (diff > 0 ? 1 : 0);
    return f.isEven ? f : f + (diff > 0 ? 1 : -1);
  }

  String _typeName(Object? v) {
    if (v == null) return 'NoneType';
    if (v is bool) return 'bool';
    if (v is int) return 'int';
    if (v is num) return 'float';
    if (v is String) return 'str';
    if (v is List) return 'list';
    if (v is _Range) return 'range';
    if (v is _PyFunction) return 'function';
    return 'object';
  }

  String _repr(Object? v) {
    if (v is String) {
      final esc = v
          .replaceAll('\\', r'\\')
          .replaceAll("'", r"\'")
          .replaceAll('\n', r'\n')
          .replaceAll('\t', r'\t');
      return "'$esc'";
    }
    if (v is List) {
      return '[${v.map(_repr).join(', ')}]';
    }
    return _str(v);
  }

  String _str(Object? v) {
    if (v is bool) return v ? 'True' : 'False';
    if (v == null) return 'None';
    if (v is List) return _repr(v);
    if (v is _PyFunction) return '<function ${v.name}>';
    if (v is _Range) {
      return 'range(${v.start}, ${v.stop}${v.step == 1 ? '' : ', ${v.step}'})';
    }
    if (v is double && v.isFinite && v == v.truncateToDouble()) {
      final raw = v.toString();
      if (!raw.contains('e') && !raw.contains('E')) {
        return '${v.truncateToDouble().toInt()}.0';
      }
    }
    return '$v';
  }
}
