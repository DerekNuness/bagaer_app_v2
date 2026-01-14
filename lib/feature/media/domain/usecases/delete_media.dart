import '../repositories/media_repository.dart';

class DeleteMedia {
  final MediaRepository repository;

  DeleteMedia(this.repository);

  Future<void> call(int mediaId) {
    return repository.delete(mediaId);
  }
}