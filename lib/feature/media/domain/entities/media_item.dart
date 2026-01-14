import 'media_kind.dart';

class MediaItem {
  final int? id;
  final MediaKind kind;
  final String originalPath;
  final String processedPath;
  final DateTime createdAt;

  const MediaItem({
    this.id,
    required this.kind,
    required this.originalPath,
    required this.processedPath,
    required this.createdAt,
  });

  MediaItem copyWith({
    int? id,
    String? processedPath,
    Duration? duration,
  }) {
    return MediaItem(
      id: id ?? this.id,
      kind: kind,
      originalPath: originalPath,
      processedPath: processedPath ?? this.processedPath,
      createdAt: createdAt,
    );
  }
}