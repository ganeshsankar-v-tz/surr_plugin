import 'surr_plugin_platform_interface.dart';

export 'surr_plugin_platform_interface.dart'
    show PreFilter, PermissionException, TaalConnectionStatus;

class SurrPlugin {
  Future<String?> getPlatformVersion() {
    return SurrPluginPlatform.instance.getPlatformVersion();
  }

  Future<void> startRecorder({
    required String rawPath,
    required String filteredPath,
    bool playback = true,
    int recordingTime = 30,
    int preAmplification = 5,
    PreFilter filter = PreFilter.heart,
  }) {
    return SurrPluginPlatform.instance.startRecorder(
      rawPath: rawPath,
      filteredPath: filteredPath,
      playback: playback,
      recordingTime: recordingTime,
      preAmplification: preAmplification,
      filter: filter,
    );
  }

  Future<void> startPlayer({required String path}) {
    return SurrPluginPlatform.instance.startPlayer(path: path);
  }

  Future<TaalConnectionStatus> isTaalDeviceConnected() {
    return SurrPluginPlatform.instance.isTaalDeviceConnected();
  }

  Future<int?> readSampleRate(String path) {
    return SurrPluginPlatform.instance.readSampleRate(path);
  }

  Future<List<double>?> getFloatBuffer(String path) {
    return SurrPluginPlatform.instance.getFloatBuffer(path);
  }
}
