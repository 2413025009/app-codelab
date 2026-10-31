// FILE: lib/features/class/presentation/widgets/join_class_sheet.dart
//
// TUGAS: modal "Gabung ke Kelas Gurumu" (PROMPT.md Bagian 1 + Stitch v3
// modal_gabung_kelas_guru_siswa). Alur: siswa mengetik kode rombel 6
// karakter → otomatis kapital + tanda lipat ("RPL-8K2") + haptic tiap
// karakter → kartu pratinjau kelas (GET /classes/preview) → gabung
// (POST /classes/join). Berhasil: lencana russ (playBadgeUnlocked)
// lalu sheet menutup mengirim nama kelas ke pemanggil (snackbar di pemanggil).
//
// WAJIB DIUBAH BILA: kebutuhan scan QR kelas atau validasi kode baru.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/sound_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../domain/class_exceptions.dart';
import '../../domain/class_repository.dart';
import 'class_sheet_shell.dart';

/// Hasil = nama kelas tempat siswa berhasil gabung; null bila batal/gagal.
Future<String?> showJoinClassSheet(BuildContext context) =>
    showClassSheet<String>(context, builder: (_) => const _JoinClassSheet());

/// Fase kartu pratinjau setelah kode tampak lengkap (3 tanda + 3 akhir).
enum _PreviewPhase { idle, checking, notFound, found }

class _JoinClassSheet extends StatefulWidget {
  const _JoinClassSheet();

  @override
  State<_JoinClassSheet> createState() => _JoinClassSheetState();
}

class _JoinClassSheetState extends State<_JoinClassSheet> {
  late final ClassRepository _repo = context.read<ClassRepository>();
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();

  /// Sempitkan: tombol pembersih muncul tepat kodenya tidak kosong lagi.
  bool _codeEmpty = true;

  Timer? _previewDebounce;
  _PreviewPhase _phase = _PreviewPhase.idle;
  String? _previewMessage;
  ClassInfo? _found;
  bool _joining = false;

  /// true setelah gabung sukses — tombol berganti kartu kemenangan sejenak.
  bool _joined = false;
  String _joinedName = '';

  @override
  void initState() {
    super.initState();
    // Tombol hapus tampil-hilang mengikuti isi kotak kode.
    _codeController.addListener(() {
      final empty = _codeController.text.isEmpty;
      if (empty != _codeEmpty && mounted) {
        setState(() => _codeEmpty = empty);
      }
    });
    // Tanpa keyboard memenuhi layar: langsung fokus mengetik kode.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _previewDebounce?.cancel();
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Format ala script Stitch: ada huruf/angka ditadikan, kapital, tanda
  /// lipat otomatis setelah 3 karakter, maksimal 6 karakter inti.
  String _formatCode(String raw) {
    var alnum = raw.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
    if (alnum.length > 6) alnum = alnum.substring(0, 6);
    if (alnum.length > 3) {
      return '${alnum.substring(0, 3)}-${alnum.substring(3)}';
    }
    return alnum;
  }

  void _onCodeChanged(String raw) {
    final formatted = _formatCode(raw);
    if (formatted != raw) {
      _codeController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    // Satu getar lembut per ketikan karakter (PROMPT.md interaksi W10).
    HapticFeedback.selectionClick();

    _previewDebounce?.cancel();
    final inti = formatted.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (inti.length < 6) {
      setState(() {
        _phase = _PreviewPhase.idle;
        _found = null;
        _previewMessage = null;
      });
      return;
    }
    // Kode serasa lengkap: jangan beri putus di tiap huruf — jeda 350 ms.
    _previewDebounce = Timer(const Duration(milliseconds: 350), _loadPreview);
  }

  Future<void> _loadPreview() async {
    if (!mounted) return;
    setState(() {
      _phase = _PreviewPhase.checking;
      _previewMessage = null;
    });
    try {
      final info = await _repo.previewClass(_codeController.text);
      if (!mounted) return;
      setState(() {
        _found = info;
        _phase = _PreviewPhase.found;
      });
    } on ApiClassException catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _PreviewPhase.notFound;
        _previewMessage = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _phase = _PreviewPhase.notFound;
        _previewMessage =
            'Server belum terjangkau. Periksa koneksi lab, lalu coba lagi.';
      });
    }
  }

  Future<void> _join() async {
    if (_joining || _joined || _found == null) return;
    setState(() => _joining = true);
    try {
      final info = await _repo.joinClass(_codeController.text);
      if (!mounted) return;
      // Lencana russ: momen sukses pemakaian pertama fitur kelas (TODO W10).
      SoundService.playBadgeUnlocked();
      setState(() {
        _joined = true;
        _joining = false;
        _joinedName = info.name;
      });
      await Future<void>.delayed(const Duration(milliseconds: 950));
      if (mounted) Navigator.of(context).pop(info.name);
    } on ApiClassException catch (e) {
      if (!mounted) return;
      setState(() {
        _joining = false;
        _phase = _PreviewPhase.notFound;
        _found = e.isAlreadyInAClass ? null : _found;
        _previewMessage = e.message;
      });
      if (!e.isAlreadyInAClass) showAppSnack(context, e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _joining = false;
        _previewMessage =
            'Server belum terjangkau. Periksa koneksi lab, lalu coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final name = _joinedName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        // Header khas Stitch v3: lambang kelas dalam lingkaran lembut +
        // judul & subjudul rata tengah.
        Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: p.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.meeting_room_rounded, color: p.primary, size: 28),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Gabung ke Kelas Gurumu',
          textAlign: TextAlign.center,
          style: AppTypography.titleM.copyWith(
            color: p.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Masukkan 6 karakter kode kelas yang dibagikan gurumu.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyM.copyWith(color: p.textMuted),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Kotak kode besar: monospace, rata tengah, spasi huruf lebar.
        TextFormField(
          controller: _codeController,
          focusNode: _focusNode,
          maxLength: 7,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          enabled: !_joining && !_joined,
          onChanged: _onCodeChanged,
          onFieldSubmitted: (_) => _join(),
          style: AppTypography.code.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 6,
            color: p.text,
            fontFamily: 'JetBrainsMono',
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            counterText: '',
            hintText: 'RPL-…',
            filled: true,
            fillColor: p.surfaceAlt,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide.none,
            ),
            suffixIcon: !_codeEmpty
                ? IconButton(
                    tooltip: 'Hapus kode',
                    onPressed: _joining || _joined
                        ? null
                        : () {
                            setState(() {
                              _codeController.clear();
                              _phase = _PreviewPhase.idle;
                              _found = null;
                              _previewMessage = null;
                            });
                            _focusNode.requestFocus();
                          },
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: p.textMuted,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Contoh: RPL-94X atau KOD-7B1',
            style: AppTypography.caption.copyWith(color: p.textMuted),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Zona pratinjau: kosong / memeriksa / gagal menemukan / kartu kelas.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: switch (_phase) {
            _PreviewPhase.idle => const SizedBox.shrink(key: ValueKey('idle')),
            _PreviewPhase.checking => Padding(
              key: const ValueKey('checking'),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
            _PreviewPhase.notFound => Container(
              key: const ValueKey('notfound'),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: p.errorContainer,
                borderRadius: BorderRadius.circular(AppRadius.input),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_off_rounded, color: p.error, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _previewMessage ?? 'Kode kelas tidak ditemukan.',
                      style: AppTypography.bodyM.copyWith(color: p.error),
                    ),
                  ),
                ],
              ),
            ),
            _PreviewPhase.found => _PreviewCard(
              key: const ValueKey('found'),
              info: _found!,
            ),
          },
        ),
        const SizedBox(height: AppSpacing.xl),

        // Aksi utama: aktif hanya bila kartu kelas benar-benar ditemukan.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _joined
              ? Container(
                  key: const ValueKey('success'),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: p.successContainer,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: p.success,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          'Berhasil bergabung ke $name!',
                          style: AppTypography.label.copyWith(color: p.success),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              : AppButton(
                  key: const ValueKey('joinBtn'),
                  label: 'Gabung Kelas Sekarang',
                  leadingIcon: Icons.login_rounded,
                  loading: _joining,
                  onPressed: _phase == _PreviewPhase.found ? _join : null,
                ),
        ),
        TextButton(
          onPressed: _joining ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Batalkan',
            style: AppTypography.label.copyWith(
              color: p.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Kartu kelas ditemukan: status pill, nama rombel, guru, sekolah, jumlah
/// teman sekelas saat ini — semuanya data nyata dari GET /classes/preview.
class _PreviewCard extends StatelessWidget {
  const _PreviewCard({super.key, required this.info});

  final ClassInfo info;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: AppRadius.pillBorder,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: p.success,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Kelas Ditemukan',
                      style: AppTypography.caption.copyWith(
                        color: p.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: p.surface.withValues(alpha: 0.6),
                  borderRadius: AppRadius.pillBorder,
                ),
                child: Text(
                  info.academicYear,
                  style: AppTypography.caption.copyWith(
                    color: p.textMuted,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            info.name,
            style: AppTypography.label.copyWith(color: p.text, fontSize: 17),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (info.teacherName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(Icons.person_rounded, size: 16, color: p.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      info.teacherName,
                      style: AppTypography.bodyM.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (info.schoolName.isNotEmpty)
            Row(
              children: [
                Icon(Icons.domain_rounded, size: 16, color: p.textMuted),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    info.schoolName,
                    style: AppTypography.bodyM.copyWith(color: p.textMuted),
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: p.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.group_rounded, size: 18, color: p.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${info.memberCount} Teman Sekelas',
                  style: AppTypography.label.copyWith(
                    color: p.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
