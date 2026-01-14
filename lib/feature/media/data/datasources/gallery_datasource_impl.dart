import 'package:bagaer/core/constants/media_constants.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'gallery_datasource.dart';

class GalleryDataSourceImpl implements GalleryDataSource {
  @override
  Future<void> saveImage(String path) async {
    final success = await GallerySaver.saveImage(
      path,
      albumName: MediaConstants.galleryAlbum,
    );

    if (success != true) {
      throw Exception('Failed to save image to gallery');
    }
  }

  @override
  Future<void> saveVideo(String path) async {
    final success = await GallerySaver.saveVideo(
      path,
      albumName: MediaConstants.galleryAlbum,
    );

    if (success != true) {
      throw Exception('Failed to save video to gallery');
    }
  }
}