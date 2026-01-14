import '../../domain/entities/media_item.dart';
import '../../domain/entities/media_kind.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/camera_datasource.dart';
import '../datasources/ffmpeg_datasource.dart';
import '../datasources/gallery_datasource.dart';
import '../datasources/media_local_datasource.dart';

class MediaRepositoryImpl implements MediaRepository {
  final CameraDataSource cameraDataSource;
  final FfmpegDataSource ffmpegDataSource;
  final GalleryDataSource galleryDataSource;
  final MediaLocalDataSource mediaLocalDataSource;

  MediaRepositoryImpl({
    required this.cameraDataSource,
    required this.ffmpegDataSource,
    required this.galleryDataSource,
    required this.mediaLocalDataSource,
  });

  // ======================
  // CAPTURE
  // ======================
  @override
  Future<MediaItem?> capture(MediaKind kind) async {
    final String? path;

    if (kind == MediaKind.photo) {
      path = await cameraDataSource.takePhoto();
    } else {
      path = await cameraDataSource.recordVideo(
        maxDuration: const Duration(seconds: 30),
      );
    }

    if (path == null) return null;

    return MediaItem(
      kind: kind,
      originalPath: path,
      processedPath: path,
      createdAt: DateTime.now(),
    );
  }

  // ======================
  // PROCESS (compress + watermark)
  // ======================
  @override
  Future<MediaItem> process(MediaItem media) async {
    String processedPath;

    if (media.kind == MediaKind.video) {
      // 1. compressão
      final compressed =
          await ffmpegDataSource.compressVideo(media.originalPath);

      // 2. watermark
      processedPath =
          await ffmpegDataSource.applyWatermarkToVideo(compressed);
    } else {
      // foto: apenas watermark
      processedPath =
          await ffmpegDataSource.applyWatermarkToImage(media.originalPath);
    }

    return media.copyWith(processedPath: processedPath);
  }

  // ======================
  // SAVE (opcional – bucket)
  // ======================
  @override
  Future<MediaItem> save(MediaItem media) async {
    // salva na galeria (bucket)
    if (media.kind == MediaKind.photo) {
      await galleryDataSource.saveImage(media.processedPath);
    } else {
      await galleryDataSource.saveVideo(media.processedPath);
    }

    // salva no SQLite
    final saved = await mediaLocalDataSource.insert(media);
    return saved;
  }

  // ======================
  // LIST (biblioteca interna)
  // ======================
  @override
  Future<List<MediaItem>> list() {
    return mediaLocalDataSource.getAll();
  }

  // ======================
  // DELETE (somente SQLite por enquanto)
  // ======================
  @override
  Future<void> delete(int id) {
    return mediaLocalDataSource.delete(id);
  }
  
  // ======================
  // SAVE LOCAL (SQLite) - bucket
  // ======================
  @override
  Future<MediaItem> saveLocal(MediaItem media) async {
    return await mediaLocalDataSource.insert(media);
  }
  
  // ======================
  // SAVE GALLERY (album Bagaer) - bucket
  // ======================
  @override
  Future<void> saveToGallery(MediaItem media) async {
    if (media.kind == MediaKind.photo) {
      await galleryDataSource.saveImage(media.processedPath);
    } else {
      await galleryDataSource.saveVideo(media.processedPath);
    }
  }
}