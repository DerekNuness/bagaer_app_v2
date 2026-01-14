
import 'package:bagaer/feature/media/domain/entities/media_item.dart';
import 'package:bagaer/feature/media/domain/repositories/media_repository.dart';

class SaveMediaToGallery {
  final MediaRepository repository;

  SaveMediaToGallery(this.repository);

  Future<void> call(MediaItem media) {
    return repository.saveToGallery(media);
  }
}