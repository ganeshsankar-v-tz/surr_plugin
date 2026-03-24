import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'surr_plugin_method_channel.dart';

enum PreFilter { heart, lungs, bowel, pregnancy, fullBody }

enum TaalConnectionStatus {
  connected,
  notConnected,
  deviceDoesNotSupportOTG,
  invalidTaalConnected,
}

class PermissionException implements Exception {
  final String message;
  final String permission;
  PermissionException(this.message, this.permission);

  @override
  String toString() => 'PermissionException: $message ($permission)';
}

abstract class SurrPluginPlatform extends PlatformInterface {
  /// Constructs a SurrPluginPlatform.
  SurrPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static SurrPluginPlatform _instance = MethodChannelSurrPlugin();

  /// The default instance of [SurrPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelSurrPlugin].
  static SurrPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SurrPluginPlatform] when
  /// they register themselves.
  static set instance(SurrPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> startRecorder({
    required String rawPath,
    required String filteredPath,
    bool playback = true,
    int recordingTime = 30,
    int preAmplification = 5,
    PreFilter filter = PreFilter.heart,
  }) {
    throw UnimplementedError('startRecorder() has not been implemented.');
  }

  Future<void> startPlayer({required String path}) {
    throw UnimplementedError('startPlayer() has not been implemented.');
  }

  Future<TaalConnectionStatus> isTaalDeviceConnected() {
    throw UnimplementedError(
      'isTaalDeviceConnected() has not been implemented.',
    );
  }

  Future<int?> readSampleRate(String path) {
    throw UnimplementedError('readSampleRate() has not been implemented.');
  }

  Future<List<double>?> getFloatBuffer(String path) {
    throw UnimplementedError('getFloatBuffer() has not been implemented.');
  }
}
