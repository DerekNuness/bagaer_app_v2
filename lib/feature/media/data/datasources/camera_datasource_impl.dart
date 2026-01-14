import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'camera_datasource.dart';

class CameraDataSourceImpl implements CameraDataSource {
  final ImagePicker _picker;

  CameraDataSourceImpl({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  @override
  Future<String?> takePhoto() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100, // não comprimir aqui
    );

    return file?.path;
  }

 @override
  Future<String?> recordVideo({required Duration maxDuration}) async {
    final XFile? file = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: maxDuration,
    );

    if (file == null) return null;

    return await _copyToSafeLocation(file.path);
  }

  Future<String> _copyToSafeLocation(String originalPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final targetDir = Directory('${dir.path}/bagaer_media/raw');

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final extension = originalPath.split('.').last;
    final newPath =
        '${targetDir.path}/RAW_${DateTime.now().millisecondsSinceEpoch}.$extension';

    final copiedFile = await File(originalPath).copy(newPath);

    // 🔒 GARANTIAS REAIS PARA O iOS
    if (!await copiedFile.exists()) {
      throw Exception('Video copy failed: file does not exist');
    }

    final length = await copiedFile.length();
    if (length == 0) {
      throw Exception('Video copy failed: empty file');
    }

    // 🧘‍♂️ Delay curto para o filesystem do iOS
    await Future.delayed(const Duration(milliseconds: 300));

    return copiedFile.path;
  }
}