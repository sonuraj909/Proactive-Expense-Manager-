import 'package:equatable/equatable.dart';

abstract class SyncState extends Equatable {
  const SyncState();
  @override
  List<Object?> get props => [];
}

class SyncInitial extends SyncState {
  const SyncInitial();
}

class SyncInProgress extends SyncState {
  final String message;
  const SyncInProgress(this.message);

  @override
  List<Object?> get props => [message];
}

class SyncCompleted extends SyncState {
  final int totalSynced;
  const SyncCompleted({this.totalSynced = 0});

  @override
  List<Object?> get props => [totalSynced];
}

class SyncFailed extends SyncState {
  final String message;
  const SyncFailed(this.message);

  @override
  List<Object?> get props => [message];
}
