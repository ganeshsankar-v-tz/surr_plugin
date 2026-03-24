import 'surr_plugin_platform_interface.dart';

export 'surr_plugin_platform_interface.dart'
    show PreFilter, PermissionException;

class SurrPlugin {
  Future<String?> getPlatformVersion() {
    return SurrPluginPlatform.instance.getPlatformVersion();
  }

  Future<void> startRecorder({
    required String rawPath,
    required String filteredPath,
    bool liveAudio = true,
    int maxDuration = 30,
    int samplingRate = 44100,
    PreFilter filter = PreFilter.heart,
  }) {
    return SurrPluginPlatform.instance.startRecorder(
      rawPath: rawPath,
      filteredPath: filteredPath,
      liveAudio: liveAudio,
      maxDuration: maxDuration,
      samplingRate: samplingRate,
      filter: filter,
    );
  }

  Future<void> startPlayer({required String path}) {
    return SurrPluginPlatform.instance.startPlayer(path: path);
  }
}
