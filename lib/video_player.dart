import 'package:anime_app/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayMyVideo extends StatelessWidget {
  String videoUrl;
  PlayMyVideo({required this.videoUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ChewieListItem(
              videoPlayerController: VideoPlayerController.network(
        videoUrl,
      ))),
    );
  }
}
