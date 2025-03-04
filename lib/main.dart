import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final player = AudioPlayer();
  final TextEditingController _urlController = TextEditingController();
  bool wasPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    player.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (player.playing) {
        wasPlaying = true;
        player.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (wasPlaying) {
        player.play();
        wasPlaying = false;
      }
    }
  }

  void handlePlayPause() async {
    if (_urlController.text.isEmpty) return;

    if (player.playing) {
      await player.pause();
    } else {
      await player.setUrl(_urlController.text);
      await player.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Music Player'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: "Enter Your Music URL Here",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              IconButton(
                icon: Icon(player.playing ? Icons.pause : Icons.play_arrow),
                onPressed: handlePlayPause,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
