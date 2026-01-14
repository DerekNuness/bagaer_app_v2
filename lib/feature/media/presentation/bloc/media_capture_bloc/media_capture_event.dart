part of 'media_capture_bloc.dart';

sealed class MediaCaptureEvent extends Equatable {
  const MediaCaptureEvent();

  @override
  List<Object> get props => [];
}

/// Inicia captura (foto ou vídeo)
class CaptureMediaRequested extends MediaCaptureEvent {
  final MediaKind kind;
  final bool haveToProccess;

  const CaptureMediaRequested(this.kind, this.haveToProccess);

  @override
  List<Object> get props => [kind, haveToProccess];
}

/// Salvar mídia (APENAS bucket)
class SaveMediaRequested extends MediaCaptureEvent {
  final MediaItem media;

  const SaveMediaRequested(this.media);

  @override
  List<Object> get props => [media];
}

/// Resetar estado (ex: usuário cancelou)
class ResetMediaCapture extends MediaCaptureEvent {
  const ResetMediaCapture();
}