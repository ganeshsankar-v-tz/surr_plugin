import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surr_plugin/surr_plugin_method_channel.dart';
import 'package:surr_plugin/surr_plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSurrPlugin platform = MethodChannelSurrPlugin();
  const MethodChannel channel = MethodChannel('surr_plugin');

  group('MethodChannelSurrPlugin', () {
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            log.add(methodCall);
            switch (methodCall.method) {
              case 'getPlatformVersion':
                return '42';
              case 'isTaalDeviceConnected':
                return 0; // TaalConnectionStatus.connected.index
              case 'readSampleRate':
                return 44100;
              case 'getFloatBuffer':
                return [0.0, 0.5, 1.0];
              default:
                return null;
            }
          });
    });

    tearDown(() {
      log.clear();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('getPlatformVersion', () async {
      expect(await platform.getPlatformVersion(), '42');
      expect(log, <Matcher>[
        isMethodCall('getPlatformVersion', arguments: null),
      ]);
    });

    test('isTaalDeviceConnected', () async {
      expect(
        await platform.isTaalDeviceConnected(),
        TaalConnectionStatus.connected,
      );
      expect(log, <Matcher>[
        isMethodCall('isTaalDeviceConnected', arguments: null),
      ]);
    });

    test('startRecorder', () async {
      await platform.startRecorder(
        rawPath: 'raw.wav',
        filteredPath: 'filtered.wav',
        preAmplification: 8,
        recordingTime: 60,
        playback: false,
        filter: PreFilter.lungs,
      );
      expect(log, <Matcher>[
        isMethodCall(
          'startRecorder',
          arguments: {
            'rawAudioFilePath': 'raw.wav',
            'preFilterAudioFilePath': 'filtered.wav',
            'playback': false,
            'recordingTime': 60,
            'preAmplification': 8,
            'preFilter': PreFilter.lungs.index,
          },
        ),
      ]);
    });

    test('startPlayer', () async {
      await platform.startPlayer(path: 'test.wav');
      expect(log, <Matcher>[
        isMethodCall('startPlayer', arguments: {'filePath': 'test.wav'}),
      ]);
    });

    test('readSampleRate', () async {
      expect(await platform.readSampleRate('test.wav'), 44100);
      expect(log, <Matcher>[
        isMethodCall('readSampleRate', arguments: {'path': 'test.wav'}),
      ]);
    });

    test('getFloatBuffer', () async {
      expect(await platform.getFloatBuffer('test.wav'), [0.0, 0.5, 1.0]);
      expect(log, <Matcher>[
        isMethodCall('getFloatBuffer', arguments: {'path': 'test.wav'}),
      ]);
    });
  });
}
