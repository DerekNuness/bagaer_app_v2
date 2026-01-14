import '../entities/media_item.dart';
import '../repositories/media_repository.dart';

class SaveMedia {
  final MediaRepository repository;

  SaveMedia(this.repository);

  Future<MediaItem> call(MediaItem media) {
    return repository.saveLocal(media);
  }
}