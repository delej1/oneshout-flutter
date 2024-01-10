import 'package:equatable/equatable.dart';
import 'package:oneshout/common/common.dart';
import 'package:oneshout/modules/shout/shout.dart';

enum LocateMeStatus { initial, loading, loaded, failed, network }

class LocateMeState extends Equatable {
  const LocateMeState({
    this.status = LocateMeStatus.initial,
    this.shout = Shout.empty,
    this.error = '',
    this.watchers = '0',
    this.shouts = const <Shout>[],
    this.pagination = const Pagination(),
  });

  final LocateMeStatus status;
  final Shout shout;
  final String error;
  final String watchers;
  final List<Shout> shouts;
  final Pagination pagination;

  @override
  List<Object?> get props => [
        shout,
        status,
        error,
        watchers,
        shouts,
        pagination,
      ];

  LocateMeState copyWith({
    LocateMeStatus? status,
    Shout? shout,
    String? error,
    String? watchers,
    List<Shout>? shouts,
    Pagination? pagination,
  }) {
    return LocateMeState(
      status: status ?? this.status,
      shout: shout ?? this.shout,
      error: error ?? this.error,
      watchers: watchers ?? this.watchers,
      shouts: shouts ?? this.shouts,
      pagination: pagination ?? this.pagination,
    );
  }
}
