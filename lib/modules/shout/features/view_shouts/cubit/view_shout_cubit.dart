// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';
import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/shout/features/view_shouts/cubit/view_shout_states.dart';
import 'package:oneshout/modules/shout/shout.dart';

class ViewShoutCubit extends Cubit<ViewShoutState> with NetworkLogger {
  ViewShoutCubit({
    required ShoutRepository shoutRepository,
  })  : _shoutRepository = shoutRepository,
        super(const ViewShoutState()) {}

  final ShoutRepository _shoutRepository;
  late Shout shout;

  Future<void> init() async {
    logger.d('Initializing ViewShoutCubit');
    emit(state.copyWith(status: ViewShoutStatus.loading));

    final data = await _shoutRepository.fetchShouts();

    data.fold((l) {
      if (l is NetworkFailure) {
        emit(
          state.copyWith(
            status: ViewShoutStatus.network,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          status: ViewShoutStatus.failed,
        ),
      );
    }, (r) {
      emit(
        state.copyWith(
          status: ViewShoutStatus.loaded,
          pagination: r.pagination,
          shouts: r.data,
        ),
      );
    });
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
