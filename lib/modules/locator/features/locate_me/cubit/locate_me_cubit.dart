// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:app_core/app_core.dart';
import 'package:bloc/bloc.dart';
import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/locator/features/locate_me/cubit/locate_me_states.dart';
import 'package:oneshout/modules/shout/shout.dart';

class LocateMeCubit extends Cubit<LocateMeState> with NetworkLogger {
  LocateMeCubit({
    required ShoutRepository shoutRepository,
  })  : _shoutRepository = shoutRepository,
        super(const LocateMeState());

  final ShoutRepository _shoutRepository;
  late Shout shout;

  Future<void> init() async {
    logger.d('Initializing LocateMeCubit');
    emit(state.copyWith(status: LocateMeStatus.loading));

    final data = await _shoutRepository.fetchShouts();

    data.fold((l) {
      emit(
        state.copyWith(
          status: LocateMeStatus.failed,
        ),
      );
    }, (r) {
      emit(
        state.copyWith(
          status: LocateMeStatus.loaded,
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
