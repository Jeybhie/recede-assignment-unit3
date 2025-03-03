import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppLifeCycleDisplay(),
    );
  }
}

class AppLifeCycleDisplay extends StatefulWidget {
  const AppLifeCycleDisplay({super.key});

  @override
  State<AppLifeCycleDisplay> createState() => _AppLifeCycleDisplayState();
}

class _AppLifeCycleDisplayState extends State<AppLifeCycleDisplay> {
  final String musicUrl =
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  late final AppLifecycleListener _listener;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late AppLifecycleState? _state;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onResume: _resumeMusic,
      onPause: _pauseMusic,
      onInactive: _pauseMusic,
      onHide: _pauseMusic,
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPauseMusic() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(musicUrl));
    }
  }

  void _pauseMusic() async {
    await _audioPlayer.pause();
  }

  void _resumeMusic() async {
    await _audioPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Music Player")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              ),
              iconSize: 64,
              onPressed: _playPauseMusic,
            ),
            const SizedBox(height: 20),
            Text(
              isPlaying ? "Playing..." : "Paused",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
