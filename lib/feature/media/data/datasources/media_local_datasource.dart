import '../../domain/entities/media_item.dart';

abstract class MediaLocalDataSource {
  /// Insere a mídia no banco local (SQLite)
  /// Retorna a mídia com ID preenchido
  Future<MediaItem> insert(MediaItem media);

  /// Retorna todas as mídias salvas (biblioteca interna)
  Future<List<MediaItem>> getAll();

  /// Remove uma mídia do banco local
  Future<void> delete(int id);
}