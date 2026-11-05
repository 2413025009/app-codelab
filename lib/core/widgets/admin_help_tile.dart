// FILE: lib/core/widgets/admin_help_tile.dart
//
// TUGAS: baris bantuan yang membuka WhatsApp admin di luar aplikasi.
// Dipakai halaman pengaturan siswa maupun pengajar agar aksi dan teksnya
// konsisten di kedua peran.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_palette.dart';
import '../theme/app_typography.dart';
import 'app_snack.dart';

/// Nomor admin dalam format internasional tanpa tanda baca (wa.me).
const _adminWhatsAppUrl = 'https://wa.me/6283125005309';

/// Buka WhatsApp admin di aplikasi/tab eksternal (di luar aplikasi).
Future<void> openAdminWhatsApp(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  try {
    final opened = await launchUrl(
      Uri.parse(_adminWhatsAppUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      showAppSnack(context, l10n.settingsHelpLaunchFailed);
    }
  } catch (_) {
    if (context.mounted) {
      showAppSnack(context, l10n.settingsHelpLaunchFailed);
    }
  }
}

/// Baris "Bantuan Admin" menuju WhatsApp admin.
class AdminHelpTile extends StatelessWidget {
  const AdminHelpTile({super.key, this.contentPadding});

  /// Padding isi baris — `zero` dipakai di dalam kartu yang sudah ber-padding.
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return ListTile(
      contentPadding: contentPadding,
      leading: Icon(Icons.support_agent_outlined, color: p.primary),
      title: Text(l10n.settingsHelpCenter),
      subtitle: Text(
        l10n.settingsHelpCenterSubtitle,
        style: AppTypography.caption.copyWith(color: p.textMuted),
      ),
      trailing: const Icon(Icons.open_in_new_rounded),
      onTap: () => openAdminWhatsApp(context),
    );
  }
}
