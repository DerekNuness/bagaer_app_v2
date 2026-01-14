import '../entities/media_item.dart';
import '../entities/media_kind.dart';

abstract class MediaRepository {
  /// Câmera
  Future<MediaItem?> capture(MediaKind kind);

  /// Compressão + watermark
  Future<MediaItem> process(MediaItem media);

  /// Salva APENAS no banco local (SQLite)
  Future<MediaItem> saveLocal(MediaItem media);

  /// Salva opcionalmente na galeria
  Future<void> saveToGallery(MediaItem media);

  /// Biblioteca interna
  Future<List<MediaItem>> list();

  /// Remove do banco
  Future<void> delete(int id);
}