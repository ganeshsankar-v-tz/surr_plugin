import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:surr_plugin/surr_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _surrPlugin = SurrPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _surrPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _startRecording() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) return;

    final rawPath = p.join(directory.path, 'raw_recording.wav');
    final filteredPath = p.join(directory.path, 'filtered_recording.wav');

    try {
      await _surrPlugin.startRecorder(
        rawPath: rawPath,
        filteredPath: filteredPath,
        filter: PreFilter.heart,
      );
    } on PermissionException catch (e) {
      debugPrint("Permission Error: ${e.message}");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${e.message} (${e.permission})")),
        );
      }
    } on PlatformException catch (e) {
      debugPrint("Error starting recorder: $e");
    }
  }

  Future<void> _startPlaying() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) return;
    final path = p.join(directory.path, 'filtered_recording.wav');
    if (!await File(path).exists()) {
      debugPrint("File not found: $path");
      return;
    }

    try {
      await _surrPlugin.startPlayer(path: path);
    } on PlatformException catch (e) {
      debugPrint("Error starting player: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Surr Plugin Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: _startRecording,
                child: const Text('Start Recorder'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _startPlaying,
                child: const Text('Start Player'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
