import '../../domain/entities/media_item.dart';
import '../../domain/entities/media_kind.dart';

class MediaItemModel extends MediaItem {
  MediaItemModel({
    int? id,
    required MediaKind kind,
    required String originalPath,
    required String processedPath,
    required DateTime createdAt,
  }) : super(
    id: id,
    kind: kind,
    originalPath: originalPath,
    processedPath: processedPath,
    createdAt: createdAt,
  );

  factory MediaItemModel.fromMap(Map<String, dynamic> map) {
    return MediaItemModel(
      id: map['id'] as int?,
      kind: MediaKind.values.firstWhere(
        (e) => e.name == map['kind'],
      ),
      originalPath: map['original_path'] as String,
      processedPath: map['processed_path'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] as int,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kind': kind.name,
      'original_path': originalPath,
      'processed_path': processedPath,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}