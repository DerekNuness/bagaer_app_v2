import 'package:sqflite/sqflite.dart';

import '../../domain/entities/media_item.dart';
import '../datasources/media_local_datasource.dart';
import '../models/media_item_model.dart';
import '../local/media_db.dart';

class MediaLocalDataSourceImpl implements MediaLocalDataSource {
  @override
  Future<MediaItem> insert(MediaItem media) async {
    final Database db = await MediaDb.instance;

    final model = MediaItemModel(
      kind: media.kind,
      originalPath: media.originalPath,
      processedPath: media.processedPath,
      createdAt: media.createdAt,
    );

    final int id = await db.insert(
      'media',
      model.toMap(),
    );

    return MediaItemModel(
      id: id,
      kind: model.kind,
      originalPath: model.originalPath,
      processedPath: model.processedPath,
      createdAt: model.createdAt,
    );
  }

  @override
  Future<List<MediaItem>> getAll() async {
    final Database db = await MediaDb.instance;

    final List<Map<String, dynamic>> result = await db.query(
      'media',
      orderBy: 'created_at DESC',
    );

    return result
        .map((map) => MediaItemModel.fromMap(map))
        .toList();
  }

  @override
  Future<void> delete(int id) async {
    final Database db = await MediaDb.instance;

    await db.delete(
      'media',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}