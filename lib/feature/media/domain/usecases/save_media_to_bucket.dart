import '../entities/media_item.dart';
import '../repositories/media_repository.dart';

class SaveMediaToBucket {
  final MediaRepository repository;

  SaveMediaToBucket(this.repository);

  Future<MediaItem> call(MediaItem media) async {
    await repository.saveToGallery(media);
    return repository.saveLocal(media);
  }
}