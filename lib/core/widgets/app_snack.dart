import 'package:flutter/material.dart';

import '../services/sound_service.dart';

/// Shows a floating snackbar, replacing any visible one.
void showAppSnack(BuildContext context, String message) {
  SoundService.playToastBubble();
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 3)));
}
