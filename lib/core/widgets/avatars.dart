import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_typography.dart';

/// Circle with the user's initials.
class InitialAvatar extends StatelessWidget {
  const InitialAvatar({super.key, required this.name, this.size = 40, this.onTap});

  final String name;
  final double size;
  final VoidCallback? onTap;

  static String initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final avatar = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: p.primaryContainer, shape: BoxShape.circle),
      child: Text(
        initialsOf(name),
        style: AppTypography.label.copyWith(color: p.primary, fontSize: size * 0.36),
      ),
    );
    if (onTap == null) return avatar;
    return Semantics(
      button: true,
      label: 'Buka profil',
      child: InkResponse(onTap: onTap, radius: size, child: avatar),
    );
  }
}

/// Solid blue profile button used in the top bar of the design.
class ProfileActionButton extends StatelessWidget {
  const ProfileActionButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Semantics(
        button: true,
        label: 'Buka profil',
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
            child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
