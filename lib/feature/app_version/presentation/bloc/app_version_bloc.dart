import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pub_semver/pub_semver.dart';

import '../../domain/entities/app_version_info.dart';
import '../../domain/usecases/get_app_version_info.dart';

part 'app_version_event.dart';
part 'app_version_state.dart';

class AppVersionBloc extends Bloc<AppVersionEvent, AppVersionState> {
  final GetAppVersionInfo getAppVersionInfo;

  AppVersionBloc({
    required this.getAppVersionInfo,
  }) : super(AppVersionInitial()) {
    on<CheckAppVersionEvent>(_onCheckAppVersion);
  }

  Future<void> _onCheckAppVersion(CheckAppVersionEvent event, Emitter<AppVersionState> emit) async {
    emit(AppVersionLoading());
    print("ENTROU NO BLOC");
    try {
      final info = await getAppVersionInfo();
      print(info);
      final isOutdated = Version.parse(event.currentVersion) < Version.parse(info.version);

      // if (isOutdated && info.mandatoryUpdate) {
      if (isOutdated) {
        emit(AppVersionBlocked(info));
      } else {
        emit(AppVersionAllowed());
      }
    } catch (e) {
      print(e);
      emit(const AppVersionError('Erro ao verificar versão do app'));
    }
  }
}