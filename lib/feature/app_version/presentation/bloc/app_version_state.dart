part of 'app_version_bloc.dart';

sealed class AppVersionState extends Equatable {
  const AppVersionState();

  @override
  List<Object> get props => [];
}

class AppVersionInitial extends AppVersionState {}

class AppVersionLoading extends AppVersionState {}

class AppVersionAllowed extends AppVersionState {}

class AppVersionBlocked extends AppVersionState {
  final AppVersionInfo info;

  const AppVersionBlocked(this.info);

  @override
  List<Object> get props => [info];
}

class AppVersionError extends AppVersionState {
  final String message;

  const AppVersionError(this.message);

  @override
  List<Object> get props => [message];
}