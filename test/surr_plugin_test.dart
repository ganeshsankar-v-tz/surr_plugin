import 'package:flutter_test/flutter_test.dart';
import 'package:surr_plugin/surr_plugin.dart';
import 'package:surr_plugin/surr_plugin_platform_interface.dart';
import 'package:surr_plugin/surr_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSurrPluginPlatform
    with MockPlatformInterfaceMixin
    implements SurrPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SurrPluginPlatform initialPlatform = SurrPluginPlatform.instance;

  test('$MethodChannelSurrPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSurrPlugin>());
  });

  test('getPlatformVersion', () async {
    SurrPlugin surrPlugin = SurrPlugin();
    MockSurrPluginPlatform fakePlatform = MockSurrPluginPlatform();
    SurrPluginPlatform.instance = fakePlatform;

    expect(await surrPlugin.getPlatformVersion(), '42');
  });
}
