import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/dashboard_repository.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends DashboardState {
  const DashboardLoading({
    this.done = 0,
    this.total = 5,
    this.stage = 'Menyambung ke server…',
  });

  /// Progres nyata: jumlah permintaan jaringan yang sudah pulang
  /// (diisi repositori lewat onProgress). Bukan animasi tetap.
  final int done;
  final int total;
  final String stage;

  @override
  List<Object?> get props => [done, total, stage];
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.data);
  final DashboardData data;
  @override
  List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  const DashboardError();
}

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository, this._email) : super(const DashboardLoading()) {
    load();
  }

  final DashboardRepository _repository;
  final String _email;

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const DashboardLoading());
    try {
      emit(
        DashboardLoaded(
          await _repository.load(
            studentEmail: _email,
            onProgress: (done, total, stage) {
              if (!silent && !isClosed) {
                emit(DashboardLoading(done: done, total: total, stage: stage));
              }
            },
          ),
        ),
      );
    } catch (_) {
      emit(const DashboardError());
    }
  }
}
