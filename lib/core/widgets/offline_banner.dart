// FILE: lib/core/widgets/offline_banner.dart
//
// TUGAS: pita tipis "Kamu sedang luring" di bagian atas layar (Minggu 13).
//
// MENGAPA: bukan mengganti pesan galat, melainkan MENJELASKAN penyebabnya.
// Tanpa ini, siswa di lab tanpa jaringan hanya melihat "server bermasalah" dan
// mengira aplikasinya rusak.
//
// WAJIB DIUBAH BILA: nanti ada cache materi luring → pita ini bisa menyebut
// konten mana yang masih bisa dibaca.
import 'package:flutter/material.dart';

import '../services/connectivity_service.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../../l10n/app_localizations.dart';

/// Pita luring yang hanya muncul saat perangkat benar-benar kehilangan jaringan.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: ConnectivityService.instance,
      builder: (context, _) {
        if (!ConnectivityService.instance.isOffline) {
          return const SizedBox.shrink();
        }
        return Material(
          color: p.warningContainer,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 16,
                    color: p.warningText,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.offlineBannerTitle,
                      style: AppTypography.caption.copyWith(
                        color: p.warningText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
