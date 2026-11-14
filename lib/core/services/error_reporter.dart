// FILE: lib/core/services/error_reporter.dart
//
// TUGAS: penangkap galat global ringan (Minggu 14 — P2 "ketiadaan laporan
// galat").
//
// MASALAH YANG DISELESAIKAN: sebelumnya galat tak tertangani hanya berhenti
// sebagai layar merah/galat senyap. Di tangan siswa, tidak ada jejak yang bisa
// ditindaklanjuti pengajar.
//
// PENDEKATAN (tanpa layanan pihak ketiga, tanpa mengirim data otomatis):
//   1. Seluruh galat framework & zona async dicatat ke buffer memori terbatas
//      (maks 20 kejadian terakhir).
//   2. Layar "Terjadi Kendala" menampilkan ringkasan dan menawarkan SALIN
//      laporan. Pengiriman tetap keputusan pengguna (tempel ke chat pengajar),
//      bukan unggahan diam-diam — tidak ada data siswa yang keluar tanpa izin.
//   3. Tidak ada isi kode siswa / kata sandi yang direkam: hanya pesan galat,
//      tipe, dan jejak singkat.
//
// WAJIB DIUBAH BILA: kelak ada layanan pelaporan terpusat (Sentry dsb.) →
// teruskan eventBuffer ke sana, jangan mengubah titik pemasangan di main.dart.
import 'package:flutter/foundation.dart';

/// Satu kejadian galat yang tercatat.
class ErrorRecord {
  ErrorRecord({
    required this.message,
    required this.at,
    this.type = 'Exception',
    this.stack,
  });

  final String message;
  final DateTime at;
  final String type;
  final String? stack;

  /// Baris ringkas untuk ditampilkan/disalin ke pengajar.
  String toReportLine() {
    final ts = at.toIso8601String();
    final head = '[$ts] $type: $message';
    final trace = stack == null
        ? ''
        : '\n  ${stack!.split('\n').take(3).join('\n  ')}';
    return '$head$trace';
  }
}

/// Penyimpan laporan galat in-memory (tidak ada I/O, tidak ada unggahan).
class ErrorReporter {
  ErrorReporter._();

  static final ErrorReporter instance = ErrorReporter._();

  static const int _maxRecords = 20;

  final List<ErrorRecord> _records = [];
  final ValueNotifier<int> revision = ValueNotifier<int>(0);

  /// Galat terakhir yang layak ditampilkan di layar "Terjadi Kendala".
  ErrorRecord? get last => _records.isEmpty ? null : _records.last;

  /// Seluruh catatan (terbaru terakhir).
  List<ErrorRecord> get records => List.unmodifiable(_records);

  /// Catat satu galat. Dipanggil dari FlutterError.onError dan
  /// PlatformDispatcher.onError.
  void record(Object error, StackTrace? stack, {String type = 'Exception'}) {
    final record = ErrorRecord(
      message: error.toString(),
      at: DateTime.now(),
      type: type,
      stack: stack?.toString(),
    );
    _records.add(record);
    if (_records.length > _maxRecords) {
      _records.removeAt(0);
    }
    revision.value++;

    // Di mode debug, tetap tampilkan di konsol agar pengembang melihatnya.
    if (kDebugMode) {
      debugPrint('[ErrorReporter] ${record.message}');
    }
  }

  /// Laporan teks siap salin: versi aplikasi + seluruh kejadian terakhir.
  String buildReport({String appVersion = 'CodeLab AI'}) {
    if (_records.isEmpty) {
      return 'CodeLab AI — tidak ada galat tercatat.';
    }
    final buffer = StringBuffer()
      ..writeln('Laporan Kendala $appVersion')
      ..writeln('Waktu: ${DateTime.now().toIso8601String()}')
      ..writeln('Jumlah galat: ${_records.length}')
      ..writeln('---');
    for (final r in _records) {
      buffer.writeln(r.toReportLine());
    }
    return buffer.toString();
  }

  @visibleForTesting
  void clear() {
    _records.clear();
    revision.value++;
  }
}
