abstract class GalleryDataSource {
  /// Salva uma imagem na galeria (álbum Bagaer)
  Future<void> saveImage(String path);

  /// Salva um vídeo na galeria (álbum Bagaer)
  Future<void> saveVideo(String path);
}