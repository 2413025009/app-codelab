// FILE: test/notification_settings_modal_test.dart
//
// TUGAS: memastikan pengaturan notifikasi tampil sebagai MODAL (Minggu 13
// lanjutan) dan tombol uji coba HANYA muncul untuk pengajar.
//
// MENGAPA DIUJI: kalau tombol uji muncul di akun siswa, itu mengganggu —
// siswa tidak perlu mengurus pengujian teknis notifikasi. Test ini menjaga
// batas itu agar tidak kembali tanpa sengaja.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/core/theme/app_theme.dart';
import 'package:mobile_codelab_ai/core/widgets/notification_settings_section.dart';
import 'package:mobile_codelab_ai/l10n/app_localizations.dart';

Future<void> pumpTile(
  WidgetTester tester, {
  required bool showTestButton,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('id'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Column(
          children: [
            NotificationSettingsTile(showTestButton: showTestButton),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('baris notifikasi tampil ringkas (bukan tujuh saklar)', (
    tester,
  ) async {
    await pumpTile(tester, showTestButton: false);

    // Hanya satu baris di halaman Pengaturan.
    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNothing);

    // Saklar per jenis belum tampil sebelum modal dibuka.
    expect(find.text('Sertifikat Terbit'), findsNothing);
    expect(find.text('Pengingat Belajar'), findsNothing);
  });

  testWidgets('modal berisi semua jenis notifikasi untuk siswa', (
    tester,
  ) async {
    await pumpTile(tester, showTestButton: false);
    await tester.tap(find.text('Notifikasi'));
    await tester.pumpAndSettle();

    // Lima jenis + saklar induk = 6 saklar.
    expect(find.text('Aktifkan Notifikasi'), findsOneWidget);
    expect(find.text('Sertifikat Terbit'), findsOneWidget);
    expect(find.text('Unduhan Sertifikat'), findsOneWidget);
    expect(find.text('Pengingat Belajar'), findsOneWidget);
    expect(find.text('Modul Baru'), findsOneWidget);
    expect(find.text('Keamanan Sesi'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNWidgets(6));
  });

  testWidgets('siswa TIDAK melihat tombol Kirim Notifikasi Uji Coba', (
    tester,
  ) async {
    await pumpTile(tester, showTestButton: false);
    await tester.tap(find.text('Notifikasi'));
    await tester.pumpAndSettle();

    expect(find.text('Kirim Notifikasi Uji Coba'), findsNothing);
    expect(find.textContaining('Uji Coba'), findsNothing);
  });

  testWidgets('pengajar melihat tombol Kirim Notifikasi Uji Coba', (
    tester,
  ) async {
    await pumpTile(tester, showTestButton: true);
    await tester.tap(find.text('Notifikasi'));
    await tester.pumpAndSettle();

    expect(find.text('Kirim Notifikasi Uji Coba'), findsOneWidget);
    expect(find.text('Sertifikat Terbit'), findsOneWidget);
  });
}
