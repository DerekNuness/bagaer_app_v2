import 'package:bagaer/feature/media/domain/entities/media_item.dart';
import 'package:bagaer/feature/media/domain/entities/media_kind.dart';
import 'package:bagaer/feature/media/domain/usecases/capture_media.dart';
import 'package:bagaer/feature/media/domain/usecases/process_media.dart';
import 'package:bagaer/feature/media/domain/usecases/save_media_to_bucket.dart';
import 'package:bagaer/feature/permissions/domain/entities/permission_status.dart';
import 'package:bagaer/feature/permissions/domain/usecases/ensure_camera_permission_usecase.dart';
import 'package:bagaer/feature/permissions/domain/usecases/ensure_microphone_permission_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'media_capture_event.dart';
part 'media_capture_state.dart';

class MediaCaptureBloc extends Bloc<MediaCaptureEvent, MediaCaptureState> {
  final EnsureCameraPermissionUseCase cameraPermission;
  final EnsureMicrophonePermissionUseCase microphonePermission;
  final CaptureMedia captureMedia;
  final ProcessMedia processMedia;
  final SaveMediaToBucket saveMediaToBucket;

  MediaCaptureBloc({
    required this.cameraPermission,
    required this.microphonePermission,
    required this.captureMedia,
    required this.processMedia,
    required this.saveMediaToBucket,
  }) : super(const MediaCaptureInitial()) {
    on<CaptureMediaRequested>(_onCaptureRequested);
    on<SaveMediaRequested>(_onSaveRequested);
    on<ResetMediaCapture>(_onReset);
  }

  Future<void> _onCaptureRequested(CaptureMediaRequested event, Emitter<MediaCaptureState> emit,) async {
    try {
      emit(MediaCaptureInitial());
      // 1) Permissões
      final cam = await cameraPermission();
      if (cam != PermissionStatus.granted) {
        emit(NoCameraPermission());
        return;
      }

      if (event.kind == MediaKind.video) {
        final mic = await microphonePermission();
        if (mic != PermissionStatus.granted) {
          emit(NoMicrophonePermission());
          return;
        }
      }

      // 2) Captura
      emit(const MediaCaptureInProgress());
      final MediaItem? captured = await captureMedia(event.kind);

      if (captured == null) {
        emit(const MediaCaptureInitial());
        return;
      }

      // 3) Processamento (se precisar)
      if (!event.haveToProccess) {
        emit(MediaReady(captured));
        return;
      }

      emit(const MediaProcessing());
      final MediaItem? processed = await processMedia(captured);

      if (processed == null) {
        emit(MediaCaptureError('Falha ao processar mídia'));
        return;
      }

      emit(MediaReady(processed));
    } catch (e) {
      emit(MediaCaptureError(e.toString()));
    }
  }

  Future<void> _onSaveRequested(SaveMediaRequested event, Emitter<MediaCaptureState> emit,) async {
    try {
      emit(const MediaSaving());

      final saved = await saveMediaToBucket(event.media);

      emit(MediaSaved(saved));
    } catch (e) {
      emit(MediaCaptureError(e.toString()));
    }
  }

  void _onReset(ResetMediaCapture event, Emitter<MediaCaptureState> emit,) {
    emit(const MediaCaptureInitial());
  }
}
