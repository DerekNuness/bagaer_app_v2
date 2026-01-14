import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/media_constants.dart';
import '../../../../core/ffmpeg/ffmpeg_runner.dart';
import 'ffmpeg_datasource.dart';

class FfmpegDataSourceImpl implements FfmpegDataSource {
  final FfmpegRunner runner;

  FfmpegDataSourceImpl({required this.runner});

  Future<Directory> _processedDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(
      p.join(
        base.path,
        MediaConstants.internalRootDir,
        MediaConstants.internalProcessedDir,
      ),
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _ts() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> _outPath(String ext) async {
    final dir = await _processedDir();
    return p.join(dir.path, 'BAGAER_${_ts()}.$ext');
  }

  @override
  Future<String> compressVideo(String inputPath) async {
    final out = await _outPath('mp4');

    final cmd = [
      '-y',
      '-hide_banner',
      '-loglevel error',
      '-i "$inputPath"',
      '-map 0:v:0',
      '-map 0:a?',
      '-c:v libx264',
      '-preset superfast',
      '-crf 23',
      '-pix_fmt yuv420p',
      '-c:a aac',
      '-b:a 128k',
      '-movflags +faststart',
      '"$out"',
    ].join(' ');

    await runner.run(cmd);
    return out;
  }

  @override
  Future<String> applyWatermarkToImage(String inputPath) async {
    final out = await _outPath('jpg');
    final logoFile = await _getWatermarkFile();

    if (!await logoFile.exists()) {
      throw Exception('Watermark file not found: ${logoFile.path}');
    }

    // final cmd = [
    //   '-y',
    //   '-i "$inputPath"',
    //   '-i "${logoFile.path}"',

    //   // Resize da imagem base + logo + overlay
    //   '-filter_complex',
    //   '"[0:v]scale=800:-1[base];'
    //   '[1:v]scale=180:-1[logo];'
    //   '[base][logo]overlay=main_w-overlay_w-30:main_h-overlay_h-30"',

    //   '-q:v 2', // qualidade alta
    //   '"$out"',
    // ].join(' ');
    final cmd = [
      '-y',
      '-i "$inputPath"',
      '-i "${logoFile.path}"',
      '-filter_complex',
      '"[1:v]colorkey=white:0.3:0.1,scale=180:-1[logo];'
      '[0:v]scale=800:-1[base];'
      '[base][logo]overlay=main_w-overlay_w-30:main_h-overlay_h-30"',
      '-q:v 2',
      '"$out"',
    ].join(' ');

    await runner.run(cmd);
    return out;
  }

  @override
  Future<String> applyWatermarkToVideo(String inputPath) async {
    final out = await _outPath('mp4');
    final logoFile = await _getWatermarkFile();

    // final cmd = [
    //   '-y',
    //   '-i "$inputPath"',
    //   '-i "${logoFile.path}"',
    //   '-filter_complex "[1:v]scale=100:-1[logo];[0:v][logo]overlay=main_w-overlay_w-10:main_h-overlay_h-10,format=yuv420p"',
    //   '-map 0:a?',
    //   '-c:v libx264',
    //   '-preset superfast',
    //   '-crf 23',
    //   '-c:a aac',
    //   '-b:a 128k',
    //   '-movflags +faststart',
    //   '"$out"',
    // ].join(' ');
    final cmd = [
      '-y',
      '-i "$inputPath"',              // vídeo já comprimido
      '-i "${logoFile.path}"',         // logo (JPG)

      '-filter_complex',
      '"[1:v]colorkey=white:0.3:0.1,scale=180:-1[logo];'
      '[0:v][logo]overlay=main_w-overlay_w-10:main_h-overlay_h-10,format=yuv420p"',

      '-map 0:a?',
      '-c:v libx264',
      '-preset superfast',
      '-crf 23',
      '-c:a aac',
      '-b:a 128k',
      '-movflags +faststart',

      '"$out"',
    ].join(' ');

    await runner.run(cmd);
    return out;
  }

  Future<File> _getWatermarkFile() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(
      p.join(base.path, MediaConstants.internalRootDir),
    );

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final file = File(p.join(dir.path, 'watermark.jpg'));

    if (!await file.exists()) {
      final data = await rootBundle.load(
        MediaConstants.watermarkAssetPath,
      );
      await file.writeAsBytes(
        data.buffer.asUint8List(),
        flush: true,
      );
    }

    return file;
  }
}