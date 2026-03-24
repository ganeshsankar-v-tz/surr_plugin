import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'surr_plugin_platform_interface.dart';

/// An implementation of [SurrPluginPlatform] that uses method channels.
class MethodChannelSurrPlugin extends SurrPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('surr_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<void> startRecorder({
    required String rawPath,
    required String filteredPath,
    bool playback = true,
    int recordingTime = 30,
    int preAmplification = 5,
    PreFilter filter = PreFilter.heart,
  }) async {
    try {
      await methodChannel.invokeMethod('startRecorder', {
        'rawAudioFilePath': rawPath,
        'preFilterAudioFilePath': filteredPath,
        'playback': playback,
        'recordingTime': recordingTime,
        'preAmplification': preAmplification,
        'preFilter': filter.index,
      });
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        throw PermissionException(
          e.message ?? "Permission Denied",
          e.details?.toString() ?? "",
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> startPlayer({required String path}) async {
    await methodChannel.invokeMethod('startPlayer', {'filePath': path});
  }

  @override
  Future<TaalConnectionStatus> isTaalDeviceConnected() async {
    final int status =
        await methodChannel.invokeMethod<int>('isTaalDeviceConnected') ?? 1;
    return TaalConnectionStatus.values[status];
  }

  @override
  Future<int?> readSampleRate(String path) async {
    return await methodChannel.invokeMethod<int>('readSampleRate', {
      'path': path,
    });
  }

  @override
  Future<List<double>?> getFloatBuffer(String path) async {
    final List<dynamic>? buffer = await methodChannel.invokeMethod<List>(
      'getFloatBuffer',
      {'path': path},
    );
    return buffer?.cast<double>();
  }
}
