// Test biji untuk MiniPythonRunner (playground on-device).
// Tujuan: menahan regresi interpreter saat dikembangkan lebih lanjut.
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_codelab_ai/features/playground/data/mini_python_runner.dart';

Future<MiniPythonResult> run(
  String code, {
  InputPrompter? onInput,
}) =>
    MiniPythonRunner().run(code, onInput: onInput);

void main() {
  test('aritmetika, presedensi, pembagian', () async {
    final r = await run('''
a = 2 + 3 * 4
print(a)
print((2 + 3) * 4)
print(2 ** 3)
print(10 / 4)
print(7 // 2)
print(-7 // 2)
print(7 % 3)
print(-7 % 2)
''');
    expect(r.ok, true, reason: r.lines.join('\n'));
    expect(r.lines.join('\n'), '14\n20\n8\n2.5\n3\n-4\n1\n1');
  });

  test('string, escape, f-string, format .Nf', () async {
    final r = await run("""
nama = "Siswa"
print(f"Halo, {nama}!")
print(f"total {1 + 2}")
x = 0.5
print(f"{x:.2f}")
print("ab" * 3)
print('a\tb')
""");
    expect(r.ok, true, reason: r.lines.join('\n'));
    expect(r.lines.join('\n'), 'Halo, Siswa!\ntotal 3\n0.50\nababab\na\tb');
  });

  test('percabangan if / elif / else', () async {
    final r = await run('''
nilai = 78
if nilai >= 85:
    print("A")
elif nilai >= 70:
    print("B")
else:
    print("C")
''');
    expect(r.ok, true, reason: r.lines.join('\n'));
    expect(r.lines.join('\n'), 'B');
  });

  test('perulangan for / while / break / continue', () async {
    final r = await run('''
total = 0
for i in range(1, 4):
    total += i
print(total)
for i in range(4):
    if i == 1:
        continue
    if i == 3:
        break
    print(i)
n = 0
while True:
    n += 1
    if n == 4:
        break
print(n)
for c in "ab":
    print(c)
''');
    expect(r.ok, true, reason: r.lines.join('\n'));
    expect(r.lines.join('\n'), '6\n0\n2\n4\na\nb');
  });

  test('list, indeks, append, len', () async {
    final r = await run('''
lst = [1, 2]
lst.append(3)
print(lst)
print(len(lst))
print(lst[-1])
print(lst[0] + lst[1])
''');
    expect(r.ok, true, reason: r.lines.join('\n'));
    expect(r.lines.join('\n'), '[1, 2, 3]\n3\n3\n3');
  });

  test('fungsi def, return, rekursi', () async {
    final r = await run('''
def faktorial(n):
    if n <= 1:
        return 1
    return n * faktorial(n - 1)

def luas(a, b):
    return a * b

print(faktorial(6))
print(luas(2, 3))
''');
    expect(r.ok, true, reason: r.lines.join('\n'));
    expect(r.lines.join('\n'), '720\n6');
  });

  test('bawaan: input dialog, sum, min/max/round/abs', () async {
    final r = await run(
      '''
nama = input("Siapa? ")
print(f"Hai {nama}")
print(sum([1, 2, 3]))
print(min(3, 1, 2))
print(max([4, 9, 2]))
print(round(3.14159, 2))
print(round(2.5))
print(abs(-7))
''',
      onInput: (_) async => 'Budi',
    );
    expect(r.ok, true, reason: r.lines.join('\n'));
    expect(r.lines.join('\n'), 'Hai Budi\n6\n1\n9\n3.14\n2\n7');
  });

  test('error: NameError', () async {
    final nameErr = await run('print(nama_takada)');
    expect(nameErr.ok, false, reason: nameErr.lines.join('\n'));
    expect(nameErr.lines.last, contains('NameError'));
  });

  test('error: ZeroDivisionError', () async {
    final divErr = await run('print(1 / 0)');
    expect(divErr.ok, false, reason: divErr.lines.join('\n'));
    expect(divErr.lines.last, contains('ZeroDivisionError'));
  });

  test('error: RecursionError', () async {
    final recErr = await run('''
def f(n):
    return f(n)
print(f(1))
''');
    expect(recErr.ok, false, reason: recErr.lines.join('\n'));
    expect(recErr.lines.last, contains('RecursionError'));
  });

  test('error: loop tanpa ujung terhenti terkendali', () async {
    final hang = await run('''
while True:
    pass
''');
    expect(hang.ok, false, reason: hang.lines.join('\n'));
    expect(hang.lines.last, contains('RuntimeError'));
  });

  test('IndentationError tetap terdeteksi', () async {
    final r = await run('''
if True:
    print("ya")
  print("miring")
''');
    expect(r.ok, false);
    expect(r.lines.last, contains('IndentationError'));
  });
}
