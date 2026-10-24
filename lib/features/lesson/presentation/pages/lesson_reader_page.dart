import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/services/sound_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../ai_tutor/presentation/ai_tutor_sheet.dart';
import '../../domain/lesson_repository.dart';
import '../../domain/slide_models.dart';
import '../widgets/slides/bug_hunter_slide_widget.dart';
import '../widgets/slides/output_predict_slide_widget.dart';
import '../widgets/slides/outro_slide_widget.dart';
import '../widgets/slides/quiz_slide_widget.dart';
import '../widgets/slides/slide_feedback_sheet.dart';
import '../widgets/slides/tap_to_fill_slide_widget.dart';
import '../widgets/slides/theory_slide_widget.dart';
import '../widgets/slides/type_code_slide_widget.dart';

class LessonReaderPage extends StatefulWidget {
  const LessonReaderPage({
    super.key,
    required this.lessonId,
  });

  final String lessonId;

  @override
  State<LessonReaderPage> createState() => _LessonReaderPageState();
}

class _LessonReaderPageState extends State<LessonReaderPage> {
  late Future<LessonDetailData> _future;
  final PageController _pageController = PageController();

  int _currentIndex = 0;
  bool _canCheckAnswer = false;

  // GlobalKeys to access slide state for validation
  final GlobalKey<TapToFillSlideWidgetState> _tapToFillKey = GlobalKey();
  final GlobalKey<TypeCodeSlideWidgetState> _typeCodeKey = GlobalKey();
  final GlobalKey<OutputPredictSlideWidgetState> _outputPredictKey = GlobalKey();
  final GlobalKey<BugHunterSlideWidgetState> _bugHunterKey = GlobalKey();
  final GlobalKey<QuizSlideWidgetState> _quizKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  void _loadLesson() {
    final repo = context.read<LessonRepository>();
    _future = repo.getLessonDetail(widget.lessonId).then((data) {
      if (data.currentSlideIndex > 1 && data.currentSlideIndex <= data.slides.length) {
        final targetIndex = data.currentSlideIndex - 1;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(targetIndex);
            setState(() {
              _currentIndex = targetIndex;
            });
          }
        });
      }
      return data;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSlideAnswerChanged(bool hasAnswer) {
    setState(() {
      _canCheckAnswer = hasAnswer;
    });
  }

  void _checkCurrentAnswer(LessonDetailData data) {
    final slide = data.slides[_currentIndex];
    var isCorrect = false;

    if (slide is TapToFillSlide) {
      isCorrect = _tapToFillKey.currentState?.checkAnswer() ?? false;
      _showFeedback(
        isCorrect: isCorrect,
        title: isCorrect ? slide.successTitle : slide.errorTitle,
        message: isCorrect ? slide.successMsg : slide.errorMsg,
        data: data,
        onRetry: () => _tapToFillKey.currentState?.resetAnswer(),
      );
    } else if (slide is TypeCodeSlide) {
      isCorrect = _typeCodeKey.currentState?.checkAnswer() ?? false;
      _showFeedback(
        isCorrect: isCorrect,
        title: isCorrect ? slide.successTitle : slide.errorTitle,
        message: isCorrect ? slide.successMsg : slide.errorMsg,
        data: data,
        onRetry: () => _typeCodeKey.currentState?.resetAnswer(),
      );
    } else if (slide is OutputPredictSlide) {
      isCorrect = _outputPredictKey.currentState?.checkAnswer() ?? false;
      _showFeedback(
        isCorrect: isCorrect,
        title: isCorrect ? slide.successTitle : slide.errorTitle,
        message: isCorrect ? slide.successMsg : slide.errorMsg,
        data: data,
        onRetry: () => _outputPredictKey.currentState?.resetAnswer(),
      );
    } else if (slide is BugHunterSlide) {
      isCorrect = _bugHunterKey.currentState?.checkAnswer() ?? false;
      _showFeedback(
        isCorrect: isCorrect,
        title: isCorrect ? slide.successTitle : slide.errorTitle,
        message: isCorrect ? slide.successMsg : slide.errorMsg,
        data: data,
        onRetry: () => _bugHunterKey.currentState?.resetAnswer(),
      );
    } else if (slide is QuizSlide) {
      isCorrect = _quizKey.currentState?.checkAnswer() ?? false;
      _showFeedback(
        isCorrect: isCorrect,
        title: isCorrect ? slide.successTitle : slide.errorTitle,
        message: isCorrect ? slide.successMsg : slide.errorMsg,
        data: data,
        onRetry: () => _quizKey.currentState?.resetAnswer(),
      );
    }
  }

  void _showFeedback({
    required bool isCorrect,
    required String title,
    required String message,
    required LessonDetailData data,
    VoidCallback? onRetry,
  }) {
    if (isCorrect) {
      SoundService.playQuizCorrect();
    } else {
      SoundService.playQuizWrong();
    }
    SlideFeedbackSheet.show(
      context,
      isCorrect: isCorrect,
      title: title,
      message: message,
      onContinue: () => _nextSlide(data),
      onRetry: onRetry,
      onAskTutor: () => showAiTutorSheet(context),
    );
  }

  void _nextSlide(LessonDetailData data) {
    if (_currentIndex < data.slides.length - 1) {
      final nextIdx = _currentIndex + 1;
      _pageController.animateToPage(
        nextIdx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex = nextIdx;
        _canCheckAnswer = false;
      });

      // Save progress to backend
      final progressPercent = ((nextIdx + 1) / data.slides.length) * 100.0;
      context.read<LessonRepository>().saveProgress(
            id: data.id,
            currentSlideIndex: nextIdx + 1,
            progressPercent: progressPercent,
            completed: false,
          );
    }
  }

  void _prevSlide() {
    if (_currentIndex > 0) {
      final prevIdx = _currentIndex - 1;
      _pageController.animateToPage(
        prevIdx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentIndex = prevIdx;
        _canCheckAnswer = false;
      });
    }
  }

  Future<void> _finishLesson(LessonDetailData data) async {
    // Save completion
    await context.read<LessonRepository>().saveProgress(
          id: data.id,
          currentSlideIndex: data.slides.length,
          progressPercent: 100.0,
          completed: true,
        );

    if (mounted) {
      SoundService.playChapterClear();
      showAppSnack(context, 'Selamat! Kamu memperoleh +${data.xpReward} XP! 🎉');
      context.go(AppRoutes.dashboard);
    }
  }

  Future<bool> _confirmExit() async {
    SoundService.playAlertWarning();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Latihan?'),
        content: const Text('Progres slide terakhirmu akan tersimpan secara otomatis.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Lanjut Belajar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit && context.mounted) {
          context.go(AppRoutes.dashboard);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Tutup',
            icon: const Icon(Icons.close_rounded),
            onPressed: () async {
              final shouldExit = await _confirmExit();
              if (shouldExit && context.mounted) {
                context.go(AppRoutes.dashboard);
              }
            },
          ),
          title: FutureBuilder<LessonDetailData>(
            future: _future,
            builder: (context, snap) {
              final total = snap.data?.slides.length ?? 7;
              return _SegmentedProgressBar(
                totalSegments: total,
                currentSegment: _currentIndex + 1,
              );
            },
          ),
          actions: [
            FutureBuilder<LessonDetailData>(
              future: _future,
              builder: (context, snap) {
                final xp = snap.data?.xpReward ?? 50;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: p.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: p.accent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '+$xp XP',
                            style: AppTypography.label.copyWith(
                              color: p.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<LessonDetailData>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 12),
                    SizedBox(height: 24),
                    SkeletonBox(height: 40),
                    SizedBox(height: 24),
                    SkeletonBox(height: 320, radius: AppRadius.card),
                  ],
                ),
              );
            }

            if (snap.hasError || !snap.hasData) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Gagal memuat materi bab.', style: AppTypography.bodyM.copyWith(color: p.textMuted)),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Coba lagi',
                      expand: false,
                      onPressed: () => setState(_loadLesson),
                    ),
                  ],
                ),
              );
            }

            final data = snap.data!;
            final currentSlide = data.slides[_currentIndex];

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.slides.length,
                    itemBuilder: (context, idx) {
                      final s = data.slides[idx];
                      return switch (s.type) {
                        SlideType.theory => TheorySlideWidget(slide: s as TheorySlide),
                        SlideType.tapToFill => TapToFillSlideWidget(
                            key: _tapToFillKey,
                            slide: s as TapToFillSlide,
                            onAnswerChanged: _onSlideAnswerChanged,
                          ),
                        SlideType.typeCode => TypeCodeSlideWidget(
                            key: _typeCodeKey,
                            slide: s as TypeCodeSlide,
                            onAnswerChanged: _onSlideAnswerChanged,
                          ),
                        SlideType.outputPredict => OutputPredictSlideWidget(
                            key: _outputPredictKey,
                            slide: s as OutputPredictSlide,
                            onAnswerChanged: _onSlideAnswerChanged,
                          ),
                        SlideType.bugHunter => BugHunterSlideWidget(
                            key: _bugHunterKey,
                            slide: s as BugHunterSlide,
                            onAnswerChanged: _onSlideAnswerChanged,
                          ),
                        SlideType.quiz => QuizSlideWidget(
                            key: _quizKey,
                            slide: s as QuizSlide,
                            onAnswerChanged: _onSlideAnswerChanged,
                          ),
                        SlideType.outro => OutroSlideWidget(
                            slide: s as OutroSlide,
                            // Reward efektif DB (P2-15), fallback offline ke markdown.
                            effectiveXp: data.xpReward,
                          ),
                      };
                    },
                  ),
                ),
                // Bottom Action Bar
                Container(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.md,
                    AppSpacing.screen,
                    MediaQuery.paddingOf(context).bottom + AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: p.surface,
                    border: Border(top: BorderSide(color: p.outline)),
                  ),
                  child: Row(
                    children: [
                      if (_currentIndex > 0) ...[
                        OutlinedButton(
                          onPressed: _prevSlide,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: p.text,
                            side: BorderSide(color: p.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            minimumSize: const Size(48, 48),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, size: 20),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Expanded(
                        child: switch (currentSlide.type) {
                          SlideType.theory => AppButton(
                              label: 'Paham, Lanjutkan',
                              onPressed: () => _nextSlide(data),
                            ),
                          SlideType.outro => AppButton(
                              label: 'Selesai & Simpan Progres',
                              leadingIcon: Icons.check_circle_rounded,
                              onPressed: () => _finishLesson(data),
                            ),
                          _ => AppButton(
                              label: 'Periksa Jawaban',
                              onPressed: _canCheckAnswer ? () => _checkCurrentAnswer(data) : null,
                            ),
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  const _SegmentedProgressBar({
    required this.totalSegments,
    required this.currentSegment,
  });

  final int totalSegments;
  final int currentSegment;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final total = totalSegments < 1 ? 1 : totalSegments;

    return Row(
      children: List.generate(total, (i) {
        final isFilled = i < currentSegment;
        return Expanded(
          child: Container(
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isFilled ? p.primary : p.outline,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
