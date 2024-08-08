import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'workout.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Workout workout;

  VideoPlayerScreen({required this.workout});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _checkIfVideoDownloaded();
  }

  Future<void> _checkIfVideoDownloaded() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.workout.title}.mp4';
    final file = File(filePath);
    if (file.existsSync()) {
      setState(() {
        _isDownloaded = true;
        _controller = VideoPlayerController.file(file)..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
      });
    } else {
      _downloadVideo();
    }
  }

  Future<void> _downloadVideo() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.workout.title}.mp4';
    final dio = Dio();

    await dio.download(widget.workout.videoUrl, filePath).then((_) {
      setState(() {
        _isDownloaded = true;
        _controller = VideoPlayerController.file(File(filePath))..initialize().then((_) {
          setState(() {});
          _controller.play();
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.title),
      ),
      body: Center(
        child: _isDownloaded
            ? _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator()
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
