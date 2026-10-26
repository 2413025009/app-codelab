// FILE: lib/features/teacher/presentation/pages/teacher_home_page.dart
//
// TUGAS (Minggu 9): pintar area guru pasca-login "Ruang Kelas Saya".
// MINGGU 9 — PEMISAHAN SCREEN PER PERAN: seluruh halaman khusus pengajar
// berkumpul di folder features/teacher/ (bisa jadi tumpukan admin di
// features/admin/ pada minggunya). Router memaksa akun guru masuk ke sini,
// sehingga profil & data yang dikelola menampilkan berkas pengajar, bukan
// berkas siswa (NISN/kelas).
// Dashboard penuh guru (kartu rombel, kode kelas proyektor, daftar murid)
// dijadwalkan Minggu 11 (docs/TODO.md §5).
//
// WAJIB DIUBAH BILA: Minggu 11 — ganti isi halaman ini dengan
// TeacherDashboardPage sungguhan (Stitch v3 dashboard_guru_ruang_kelas).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final user = context.read<AuthCubit>().state.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruang Kelas Saya'),
        actions: [
          // Minggu 9: profil pengajar terpisah dari profil siswa.
          IconButton(
            tooltip: 'Profil Pengajar',
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => context.go(AppRoutes.teacherProfile),
          ),
          IconButton(
            tooltip: 'Pengaturan',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 96,
                    width: 96,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: p.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cast_for_education_rounded,
                      size: 44,
                      color: p.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Halo, ${user?.name ?? 'Guru'} 👋',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleL.copyWith(
                      color: p.text,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Akun pendidikmu aktif untuk ${user?.schoolName ?? 'sekolah terafiliasi'}.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyL.copyWith(color: p.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: p.surface,
                      borderRadius: AppRadius.cardBorder,
                      border: Border.all(color: p.outline),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Dalam Pengerjaan 🚧',
                          style: AppTypography.label.copyWith(
                            color: p.primary,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Dashboard guru akan tersedia pada pembaruan Minggu 11: membuat rombel kelas, menyalin kode kelas untuk proyektor lab, dan memantau progres serta XP siswa.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyM.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Minggu 9: profil pengajar menampilkan data yang guru kelola.
                  AppButton(
                    label: 'Profil Pengajar',
                    kind: AppButtonKind.secondary,
                    leadingIcon: Icons.person_outline_rounded,
                    onPressed: () => context.go(AppRoutes.teacherProfile),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Buka Pengaturan',
                    leadingIcon: Icons.settings_outlined,
                    // Minggu 9 (owner): push (bukan go) supaya pengaturan
                    // punya riwayat kembali ke dashboard pengajar.
                    onPressed: () => context.push(AppRoutes.settings),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Keluar Akun',
                    kind: AppButtonKind.text,
                    onPressed: () => context.read<AuthCubit>().logout(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
