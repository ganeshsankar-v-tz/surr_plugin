import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:surr_plugin/surr_plugin.dart';
import 'package:surr_plugin/surr_plugin_method_channel.dart';
import 'package:surr_plugin/surr_plugin_platform_interface.dart';

class MockSurrPluginPlatform
    with MockPlatformInterfaceMixin
    implements SurrPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> startRecorder({
    required String rawPath,
    required String filteredPath,
    bool playback = true,
    int recordingTime = 30,
    int preAmplification = 5,
    PreFilter filter = PreFilter.heart,
  }) => Future.value();

  @override
  Future<void> startPlayer({required String path}) => Future.value();

  @override
  Future<TaalConnectionStatus> isTaalDeviceConnected() =>
      Future.value(TaalConnectionStatus.connected);

  @override
  Future<int?> readSampleRate(String path) => Future.value(44100);

  @override
  Future<List<double>?> getFloatBuffer(String path) =>
      Future.value([0.0, 0.5, 1.0]);
}

void main() {
  final SurrPluginPlatform initialPlatform = SurrPluginPlatform.instance;

  test('$MethodChannelSurrPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSurrPlugin>());
  });

  group('SurrPlugin', () {
    late SurrPlugin surrPlugin;
    late MockSurrPluginPlatform fakePlatform;

    setUp(() {
      surrPlugin = SurrPlugin();
      fakePlatform = MockSurrPluginPlatform();
      SurrPluginPlatform.instance = fakePlatform;
    });

    test('getPlatformVersion', () async {
      expect(await surrPlugin.getPlatformVersion(), '42');
    });

    test('isTaalDeviceConnected', () async {
      expect(
        await surrPlugin.isTaalDeviceConnected(),
        TaalConnectionStatus.connected,
      );
    });

    test('startRecorder', () async {
      await surrPlugin.startRecorder(
        rawPath: 'raw.wav',
        filteredPath: 'filtered.wav',
      );
      // If no exception, test passes as startRecorder returns void
    });

    test('startPlayer', () async {
      await surrPlugin.startPlayer(path: 'test.wav');
      // If no exception, test passes
    });

    test('readSampleRate', () async {
      expect(await surrPlugin.readSampleRate('test.wav'), 44100);
    });

    test('getFloatBuffer', () async {
      expect(await surrPlugin.getFloatBuffer('test.wav'), [0.0, 0.5, 1.0]);
    });
  });
}
