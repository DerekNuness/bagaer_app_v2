class MediaConstants {
  // Galeria
  static const String galleryAlbum = 'Bagaer';

  // Video capture
  static const Duration maxVideoDuration = Duration(seconds: 30);

  // Paths internos (armazenamento do app)
  static const String internalRootDir = 'bagaer_media';
  static const String internalProcessedDir = 'processed';

  // Watermark
  static const String watermarkAssetPath = 'assets/images/watermark_logo.jpg';

  // Watermark layout
  // static const int watermarkMarginPx = 24; // margem do canto
  // static const double watermarkScale = 0.18; // % da largura do vídeo/foto (aprox.)

  static const int watermarkMargin = 10;

  static const int watermarkVideoWidth = 100;
}