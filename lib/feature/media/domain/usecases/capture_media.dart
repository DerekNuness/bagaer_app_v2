import '../entities/media_item.dart';
import '../entities/media_kind.dart';
import '../repositories/media_repository.dart';

class CaptureMedia {
  final MediaRepository repository;

  CaptureMedia(this.repository);

  Future<MediaItem?> call(MediaKind kind) {
    return repository.capture(kind);
  }
}