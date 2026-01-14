import 'package:image_cropper/image_cropper.dart';

Future<String?> cropSquare(String filePath) async {
  final cropped = await ImageCropper().cropImage(
    sourcePath: filePath,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    maxWidth: 400,
    maxHeight: 400,
    compressQuality: 92,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Ajustar foto',
        lockAspectRatio: true,
        hideBottomControls: false,
        cropStyle: CropStyle.circle
      ),
      IOSUiSettings(
        title: 'Ajustar foto',
        aspectRatioLockEnabled: true,
        cropStyle: CropStyle.circle
      ),
    ],
  );

  return cropped?.path;
}