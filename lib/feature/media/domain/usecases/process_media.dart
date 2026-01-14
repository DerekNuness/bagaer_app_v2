import '../entities/media_item.dart';
import '../repositories/media_repository.dart';

class ProcessMedia {
  final MediaRepository repository;

  ProcessMedia(this.repository);

  Future<MediaItem> call(MediaItem media) {
    return repository.process(media);
  }
}