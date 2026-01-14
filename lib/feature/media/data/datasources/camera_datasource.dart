abstract class CameraDataSource {
  /// Abre a câmera para tirar foto
  /// Retorna o path do arquivo temporário ou null se cancelar
  Future<String?> takePhoto();

  /// Abre a câmera para gravar vídeo
  /// [maxDuration] controla o tempo máximo (ex: 30s)
  /// Retorna o path do arquivo temporário ou null se cancelar
  Future<String?> recordVideo({required Duration maxDuration});
}