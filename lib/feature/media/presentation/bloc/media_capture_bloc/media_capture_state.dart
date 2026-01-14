part of 'media_capture_bloc.dart';

sealed class MediaCaptureState extends Equatable {
  const MediaCaptureState();
  
  @override
  List<Object> get props => [];
}

/// Estado inicial
class MediaCaptureInitial extends MediaCaptureState {
  const MediaCaptureInitial();
}

/// Abrindo câmera
class MediaCaptureInProgress extends MediaCaptureState {
  const MediaCaptureInProgress();
}

/// Processando (compressão + watermark)
class MediaProcessing extends MediaCaptureState {
  const MediaProcessing();
}

/// Pronto para uso (preview inline ou página dedicada)
class MediaReady extends MediaCaptureState {
  final MediaItem media;

  const MediaReady(this.media);

  @override
  List<Object> get props => [media];
}

/// Salvando (bucket)
class MediaSaving extends MediaCaptureState {
  const MediaSaving();
}

/// Salvo com sucesso (bucket)
class MediaSaved extends MediaCaptureState {
  final MediaItem media;

  const MediaSaved(this.media);

  @override
  List<Object> get props => [media];
}

/// Permissões negada
class NoCameraPermission extends MediaCaptureState {}

class NoMicrophonePermission extends MediaCaptureState {}

/// Erro genérico
class MediaCaptureError extends MediaCaptureState {
  final String message;

  const MediaCaptureError(this.message);

  @override
  List<Object> get props => [message];
}