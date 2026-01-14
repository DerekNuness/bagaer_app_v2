import 'package:ffmpeg_kit_flutter_new_min_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min_gpl/return_code.dart';
import 'package:ffmpeg_kit_flutter_new_min_gpl/statistics.dart';

class FfmpegRunner {
  const FfmpegRunner();

  Future<void> run(String command) async {
    final session = await FFmpegKit.execute(command);

    final rc = await session.getReturnCode();
    if (rc == null || !ReturnCode.isSuccess(rc)) {
      final logs = await session.getAllLogsAsString();
      final failStack = await session.getFailStackTrace();

      throw Exception(
        'FFmpeg failed.\n'
        'Command: $command\n'
        'ReturnCode: ${rc?.getValue()}\n'
        'FailStackTrace: $failStack\n'
        'Logs:\n$logs',
      );
    }
  }
}
