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
    bool liveAudio = true,
    int maxDuration = 30,
    int samplingRate = 44100,
    PreFilter filter = PreFilter.heart,
  }) async {
    try {
      await methodChannel.invokeMethod('startRecorder', {
        'rawPath': rawPath,
        'filteredPath': filteredPath,
        'liveAudio': liveAudio,
        'maxDuration': maxDuration,
        'samplingRate': samplingRate,
        'filter': filter.index,
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
    await methodChannel.invokeMethod('startPlayer', {'path': path});
  }
}
