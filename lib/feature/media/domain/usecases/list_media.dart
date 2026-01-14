import '../entities/media_item.dart';
import '../repositories/media_repository.dart';

class ListMedia {
  final MediaRepository repository;

  ListMedia(this.repository);

  Future<List<MediaItem>> call() {
    return repository.list();
  }
}