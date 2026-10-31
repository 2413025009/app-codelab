// FILE: lib/features/teacher/presentation/pages/teacher_profile_page.dart
//
// TUGAS: Halaman Profil Pengajar (/profile-pengajar).
// Menampilkan identitas pengajar, statistik pengajaran, kartu Kelas yang Diajar
// (bergaya konsisten dengan card Sertifikat siswa), kartu Materi Ajar,
// dan tautan langsung ke /pengaturan-pengajar untuk mengedit profil.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh.dart';
import '../../../../core/widgets/avatars.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/teacher_cubit.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({super.key});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TeacherCubit>().loadDashboard();
        context.read<TeacherCubit>().loadMaterials();
      }
    });
  }

  Future<void> _refresh() async {
    await context.read<AuthCubit>().restoreSession();
    if (!mounted) return;
    await Future.wait([
      context.read<TeacherCubit>().loadDashboard(),
      context.read<TeacherCubit>().loadMaterials(),
    ]);
  }

  Future<void> _confirmLogout() async {
    final p = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surface,
        title: Text(
          'Keluar dari Akun Pengajar?',
          style: AppTypography.titleM.copyWith(color: p.text),
        ),
        content: Text(
          'Kamu perlu memasukkan email dan kata sandi kembali untuk masuk ke akun pengajar ini.',
          style: AppTypography.bodyM.copyWith(color: p.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Batal', style: TextStyle(color: p.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: p.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthCubit>().logout();
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  IconData _resolveIcon(String code) {
    switch (code.trim().toLowerCase()) {
      case 'code':
        return Icons.code_rounded;
      case 'html':
        return Icons.html_rounded;
      case 'css':
        return Icons.css_rounded;
      case 'javascript':
      case 'js':
        return Icons.javascript_rounded;
      case 'database':
      case 'db':
        return Icons.storage_rounded;
      case 'psychology':
      case 'ai':
        return Icons.psychology_rounded;
      case 'phone_android':
      case 'mobile':
        return Icons.phone_android_rounded;
      case 'shield':
      case 'security':
        return Icons.shield_rounded;
      case 'data_object':
        return Icons.data_object_rounded;
      case 'terminal':
      default:
        return Icons.terminal_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final user = context.watch<AuthCubit>().state.user;
    final teacherState = context.watch<TeacherCubit>().state;

    final userName = user?.name.isNotEmpty == true
        ? user!.name
        : 'Pengajar RPL';
    final email = user?.email ?? '';
    final bio = user?.bio?.trim() ?? '';

    final classes = teacherState.classes;
    final materials = teacherState.materials;
    final totalStudents = teacherState.totalStudentCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengajar'),
        actions: [
          IconButton(
            tooltip: 'Pengaturan Profil',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.teacherSettings),
          ),
        ],
      ),
      body: SafeArea(
        child: AppRefresh(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.md,
              AppSpacing.screen,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Teacher Profile Hero Card
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          UserAvatar(
                            name: userName,
                            avatarUrl: user?.avatarUrl,
                            size: 68,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: p.success,
                                shape: BoxShape.circle,
                                border: Border.all(color: p.surface, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        userName,
                        textAlign: TextAlign.center,
                        style: AppTypography.titleM.copyWith(
                          color: p.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (email.isNotEmpty)
                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: AppTypography.caption.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      // Chips: Role + School + NIP
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: p.primaryContainer.withAlpha(50),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_user_rounded,
                                  size: 14,
                                  color: p.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Instruktur RPL',
                                  style: AppTypography.caption.copyWith(
                                    color: p.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: p.surfaceAlt,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.school_rounded,
                                  size: 14,
                                  color: p.textMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  user?.schoolName ?? 'SMK Swadhipa 2 Natar',
                                  style: AppTypography.caption.copyWith(
                                    color: p.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (user?.staffCode?.isNotEmpty == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: p.surfaceAlt,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.badge_rounded,
                                    size: 14,
                                    color: p.textMuted,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'NIP: ${user!.staffCode}',
                                    style: AppTypography.caption.copyWith(
                                      color: p.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (bio.isNotEmpty)
                        Text(
                          bio,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyM.copyWith(
                            color: p.textMuted,
                          ),
                        )
                      else
                        TextButton.icon(
                          onPressed: () =>
                              context.push(AppRoutes.teacherSettings),
                          icon: const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 18,
                          ),
                          label: const Text('Tambah Bio'),
                          style: TextButton.styleFrom(
                            foregroundColor: p.primary,
                            textStyle: AppTypography.label.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.lg),

                      // Quick Metrics Row (3 cards)
                      Row(
                        children: [
                          Expanded(
                            child: _TeacherStatCard(
                              icon: Icons.school_rounded,
                              value: '${classes.length}',
                              label: 'Kelas Diajar',
                              iconColor: p.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: _TeacherStatCard(
                              icon: Icons.people_alt_rounded,
                              value: '$totalStudents',
                              label: 'Siswa Dibimbing',
                              iconColor: p.accent,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: _TeacherStatCard(
                              icon: Icons.auto_stories_rounded,
                              value: '${materials.length}',
                              label: 'Materi Ajar',
                              iconColor: p.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 2. Section: Kelas yang Diajar (gaya konsisten dengan card Sertifikat)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kelas yang Diajar',
                      style: AppTypography.titleM.copyWith(color: p.text),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: p.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${classes.length} Kelas',
                        style: AppTypography.caption.copyWith(
                          color: p.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: classes.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.meeting_room_outlined,
                                  size: 36,
                                  color: p.textMuted,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Belum ada kelas yang dibuat.',
                                  style: AppTypography.bodyM.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            for (var i = 0; i < classes.length; i++) ...[
                              if (i > 0)
                                Divider(
                                  height: 1,
                                  color: p.outline.withAlpha(80),
                                ),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: 4,
                                ),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: p.primaryContainer.withAlpha(40),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.meeting_room_rounded,
                                    color: p.primary,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  classes[i].name,
                                  style: AppTypography.labelL.copyWith(
                                    color: p.text,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'Tahun ${classes[i].academicYear} • ${classes[i].memberCount} Siswa',
                                  style: AppTypography.caption.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: p.surfaceAlt,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        classes[i].classCode,
                                        style: AppTypography.codeSm.copyWith(
                                          color: p.text,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: p.textMuted,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                onTap: () => context.go(
                                  AppRoutes.teacherAnalyticsRoute(
                                    classes[i].id,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 3. Section: Materi Ajar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Materi Ajar',
                      style: AppTypography.titleM.copyWith(color: p.text),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: p.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${materials.length} Materi',
                        style: AppTypography.caption.copyWith(
                          color: p.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: materials.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.auto_stories_outlined,
                                  size: 36,
                                  color: p.textMuted,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Belum ada materi yang dibuat.',
                                  style: AppTypography.bodyM.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            for (var i = 0; i < materials.length; i++) ...[
                              if (i > 0)
                                Divider(
                                  height: 1,
                                  color: p.outline.withAlpha(80),
                                ),
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: 4,
                                ),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: p.surfaceAlt,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _resolveIcon(materials[i].iconCode),
                                    color: p.primary,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  materials[i].title,
                                  style: AppTypography.labelL.copyWith(
                                    color: p.text,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  '${materials[i].topic} • ${materials[i].babCount} Bab • ${materials[i].totalXp} XP',
                                  style: AppTypography.caption.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: materials[i].isPublished
                                            ? p.success.withAlpha(30)
                                            : p.surfaceAlt,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        materials[i].isPublished
                                            ? 'Terbit'
                                            : 'Draft',
                                        style: AppTypography.caption.copyWith(
                                          color: materials[i].isPublished
                                              ? p.success
                                              : p.textMuted,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: p.textMuted,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                onTap: () => context.push(
                                  AppRoutes.teacherBabList(materials[i].id),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 4. Tombol Akses Pengaturan
                AppButton(
                  label: 'Buka Pengaturan Akun',
                  leadingIcon: Icons.settings_rounded,
                  kind: AppButtonKind.secondary,
                  onPressed: () => context.push(AppRoutes.teacherSettings),
                ),
                const SizedBox(height: AppSpacing.sm),

                // 5. Keluar akun — sengaja hanya ada di halaman profil.
                OutlinedButton.icon(
                  onPressed: _confirmLogout,
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Keluar dari Akun'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: p.error,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: p.error.withAlpha(90)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: AppTypography.labelL.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeacherStatCard extends StatelessWidget {
  const _TeacherStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final IconColorStyle iconColor;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            textAlign: TextAlign.center,
            style: AppTypography.titleM.copyWith(
              color: p.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: p.textMuted),
          ),
        ],
      ),
    );
  }
}

typedef IconColorStyle = Color;
