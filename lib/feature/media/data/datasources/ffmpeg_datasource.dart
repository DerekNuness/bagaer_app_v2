abstract class FfmpegDataSource {
  Future<String> compressVideo(String inputPath);

  Future<String> applyWatermarkToImage(String inputPath);

  Future<String> applyWatermarkToVideo(String inputPath);
}