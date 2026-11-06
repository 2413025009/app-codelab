// FILE: lib/core/widgets/notification_settings_section.dart
//
// TUGAS: isi pengaturan notifikasi HP (Minggu 13 — Notifikasi 5).
//
// ISI:
//   * Saklar induk (matikan semua) — mempertahankan pilihan per jenis.
//   * Saklar per jenis: sertifikat, unduhan, pengingat, modul baru, sesi.
//   * Tombol "Kirim Notifikasi Uji Coba" — HANYA untuk pengajar
//     (`showTestButton: true`). Di akun siswa tombol ini sengaja tidak ada:
//     siswa tidak perlu mengurus pengujian teknis notifikasi.
//
// DIPAKAI DI DALAM MODAL: `NotificationSettingsTile` (di bawah) membuka isi ini
// sebagai bottom sheet, sehingga halaman Pengaturan tidak menumpuk tujuh baris
// saklar di antara preferensi lain.
//
// WAJIB DIUBAH BILA: menambah jenis notifikasi → tambahkan barisnya di sini +
// key L10n di tiga bahasa.
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../services/notification_preferences.dart';
import '../services/notification_service.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';
import 'app_sheet.dart';

class NotificationSettingsSection extends StatefulWidget {
  const NotificationSettingsSection({
    super.key,
    this.showDivider = false,
    this.showTestButton = false,
  });

  /// Garis pemisah di bawah bagian; dipakai bila ada baris lain setelahnya.
  final bool showDivider;

  /// Menampilkan tombol "Kirim Notifikasi Uji Coba".
  /// Hanya untuk pengajar — siswa tidak perlu menguji notifikasi secara manual.
  final bool showTestButton;

  @override
  State<NotificationSettingsSection> createState() =>
      _NotificationSettingsSectionState();
}

class _NotificationSettingsSectionState
    extends State<NotificationSettingsSection> {
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    NotificationPreferences.instance.addListener(_onPrefsChanged);
  }

  @override
  void dispose() {
    NotificationPreferences.instance.removeListener(_onPrefsChanged);
    super.dispose();
  }

  void _onPrefsChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _sendTest() async {
    if (_sending) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _sending = true);
    try {
      // Izin diminta saat pengguna menekan tombol ini — bukan diam-diam saat
      // aplikasi dibuka — sehingga pengguna tahu untuk apa izin tersebut.
      final granted = await NotificationService.instance.requestPermission();
      if (!granted) {
        if (mounted) {
          _snack(l10n.settingsNotifyPermissionDenied);
        }
        return;
      }
      final ok = await NotificationService.instance.showTestNotification(
        title: l10n.notifTestTitle,
        body: l10n.notifTestBody,
      );
      if (!mounted) return;
      _snack(ok ? l10n.settingsNotifyTestSent : l10n.settingsNotifyTestFailed);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _snack(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final prefs = NotificationPreferences.instance;
    final masterOn = prefs.enabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          secondary: Icon(Icons.notifications_active_outlined, color: p.primary),
          title: Text(l10n.settingsNotificationsMaster),
          subtitle: Text(
            l10n.settingsNotificationsMasterSubtitle,
            style: AppTypography.caption.copyWith(color: p.textMuted),
          ),
          value: masterOn,
          activeTrackColor: p.primary,
          onChanged: (value) async {
            await prefs.setEnabled(value);
            if (value) {
              await NotificationService.instance.requestPermission();
            } else {
              // Matikan semua: pengingat harian ikut dibatalkan.
              await NotificationService.instance.cancelDailyReminder();
            }
          },
        ),
        _divider(p),
        _switchRow(
          context: context,
          icon: Icons.workspace_premium_outlined,
          title: l10n.settingsNotifyCertificate,
          subtitle: l10n.settingsNotifyCertificateSubtitle,
          value: prefs.certificateRaw,
          enabled: masterOn,
          onChanged: prefs.setCertificate,
        ),
        _divider(p),
        _switchRow(
          context: context,
          icon: Icons.download_outlined,
          title: l10n.settingsNotifyDownload,
          subtitle: l10n.settingsNotifyDownloadSubtitle,
          value: prefs.downloadRaw,
          enabled: masterOn,
          onChanged: prefs.setDownload,
        ),
        _divider(p),
        _switchRow(
          context: context,
          icon: Icons.schedule_outlined,
          title: l10n.settingsNotifyReminder,
          subtitle: l10n.settingsNotifyReminderSubtitle,
          value: prefs.reminderRaw,
          enabled: masterOn,
          onChanged: (value) async {
            await prefs.setReminder(value);
            // Jadwal harian dipasang/dibatalkan saat itu juga agar pilihan
            // pengguna benar-benar berlaku, bukan hanya tersimpan.
            if (value && masterOn) {
              final granted =
                  await NotificationService.instance.requestPermission();
              if (!granted) return;
              await NotificationService.instance.scheduleDailyReminder(
                title: l10n.notifReminderTitle,
                body: l10n.notifReminderBody,
              );
            } else {
              await NotificationService.instance.cancelDailyReminder();
            }
          },
        ),
        _divider(p),
        _switchRow(
          context: context,
          icon: Icons.menu_book_outlined,
          title: l10n.settingsNotifyMaterial,
          subtitle: l10n.settingsNotifyMaterialSubtitle,
          value: prefs.materialRaw,
          enabled: masterOn,
          onChanged: prefs.setMaterial,
        ),
        _divider(p),
        _switchRow(
          context: context,
          icon: Icons.shield_outlined,
          title: l10n.settingsNotifySession,
          subtitle: l10n.settingsNotifySessionSubtitle,
          value: prefs.sessionRaw,
          enabled: masterOn,
          onChanged: prefs.setSession,
        ),
        // Tombol uji coba HANYA untuk pengajar: siswa tidak perlu mengurus
        // pengujian teknis notifikasi.
        if (widget.showTestButton) ...[
          _divider(p),
          ListTile(
            leading: Icon(Icons.send_outlined, color: p.primary),
            title: Text(l10n.settingsNotifyTest),
            subtitle: Text(
              l10n.settingsNotifyTestSubtitle,
              style: AppTypography.caption.copyWith(color: p.textMuted),
            ),
            trailing: _sending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.chevron_right, color: p.textMuted),
            enabled: !_sending,
            onTap: _sending ? null : _sendTest,
          ),
        ],
        if (widget.showDivider)
          Divider(height: 1, color: p.outline.withValues(alpha: 0.5)),
      ],
    );
  }

  Widget _divider(AppPalette p) =>
      Divider(height: 1, color: p.outline.withValues(alpha: 0.5));

  Widget _switchRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool enabled,
    required Future<void> Function(bool) onChanged,
  }) {
    final p = context.palette;
    return SwitchListTile(
      secondary: Icon(icon, color: enabled ? p.primary : p.textMuted),
      title: Text(title, style: enabled ? null : TextStyle(color: p.textMuted)),
      subtitle: Text(
        subtitle,
        style: AppTypography.caption.copyWith(color: p.textMuted),
      ),
      value: enabled && value,
      activeTrackColor: p.primary,
      // Saat saklar induk mati, baris ini tampak nonaktif: pilihan pengguna
      // tetap tersimpan tetapi tidak berbunyi sampai induk dinyalakan.
      onChanged: enabled ? (v) => onChanged(v) : null,
    );
  }
}

/// Baris ringkas di halaman Pengaturan yang MEMBUKA pengaturan notifikasi
/// sebagai modal. Dipakai agar tujuh saklar notifikasi tidak menumpuk di
/// halaman Pengaturan.
///
/// Ringkasan status (mis. "5 dari 5 aktif" / "Nonaktif") dihitung dari
/// [NotificationPreferences] supaya siswa tahu keadaannya tanpa membuka modal.
class NotificationSettingsTile extends StatefulWidget {
  const NotificationSettingsTile({super.key, this.showTestButton = false});

  /// Tombol "Kirim Notifikasi Uji Coba" di dalam modal — hanya untuk pengajar.
  final bool showTestButton;

  @override
  State<NotificationSettingsTile> createState() =>
      _NotificationSettingsTileState();
}

class _NotificationSettingsTileState extends State<NotificationSettingsTile> {
  @override
  void initState() {
    super.initState();
    NotificationPreferences.instance.addListener(_onPrefsChanged);
  }

  @override
  void dispose() {
    NotificationPreferences.instance.removeListener(_onPrefsChanged);
    super.dispose();
  }

  void _onPrefsChanged() {
    if (mounted) setState(() {});
  }

  /// Ringkasan keadaan untuk baris: induk mati → "Nonaktif"; selain itu
  /// "x dari 5 aktif" agar siswa tahu ada jenis yang dimatikan.
  String _summary(AppLocalizations l10n) {
    final prefs = NotificationPreferences.instance;
    if (!prefs.enabled) return l10n.settingsNotifySummaryOff;
    final active = [
      prefs.certificateEnabled,
      prefs.downloadEnabled,
      prefs.reminderEnabled,
      prefs.materialEnabled,
      prefs.sessionEnabled,
    ].where((v) => v).length;
    if (active == 5) return l10n.settingsNotifySummaryAllOn;
    return l10n.settingsNotifySummaryPartial(active);
  }

  Future<void> _open() {
    final l10n = AppLocalizations.of(context);
    return showAppSheet<void>(
      context,
      title: l10n.settingsNotifications,
      subtitle: l10n.settingsNotificationsSubtitle,
      leadingIcon: Icons.notifications_active_outlined,
      // Tinggi penuh: lima saklar + tombol uji (pengajar) butuh ruang.
      fullHeight: true,
      builder: (_) => NotificationSettingsSection(
        showTestButton: widget.showTestButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: Icon(Icons.notifications_none_rounded, color: p.primary),
      title: Text(l10n.settingsNotifications),
      subtitle: Text(
        _summary(l10n),
        style: AppTypography.caption.copyWith(color: p.textMuted),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: _open,
    );
  }
}
