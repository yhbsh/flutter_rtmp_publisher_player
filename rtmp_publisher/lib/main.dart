// ignore_for_file: avoid_print

import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await [Permission.camera, Permission.microphone].request();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

enum _State { idle, loading, publish }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final String url = 'rtmp://localhost/live';
  late final String key = 'stream';
  late final ApiVideoLiveStreamController controller = ApiVideoLiveStreamController(
    initialAudioConfig: AudioConfig(),
    initialVideoConfig: VideoConfig(bitrate: 2000),
    initialCameraPosition: CameraPosition.front,
  )..initialize();

  _State state = _State.idle;

  Future<void> publish() async {
    setState(() => state = _State.loading);
    await controller.startStreaming(url: url, streamKey: key);
    setState(() => state = _State.publish);
  }

  Future<void> unpublish() async {
    setState(() => state = _State.loading);
    await controller.stopStreaming();
    setState(() => state = _State.idle);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onDoubleTap: () => controller.switchCamera(),
        child: ApiVideoCameraPreview(
          controller: controller,
          child: Align(
            alignment: const Alignment(0.9, 0.9),
            child: SizedBox.square(
              dimension: 60,
              child: IconButton.filledTonal(
                onPressed: switch (state) {
                  _State.idle => publish,
                  _State.publish => unpublish,
                  _State.loading => null,
                },
                icon: switch (state) {
                  _State.idle => const Icon(Icons.play_arrow),
                  _State.publish => const Icon(Icons.stop),
                  _State.loading => const CircularProgressIndicator(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
