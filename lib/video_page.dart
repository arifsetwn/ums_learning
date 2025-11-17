import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    const videoId = 'nv-DpVGTxdg'; // ID video dari YouTube
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(title: const Text("Video Pembelajaran")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                player, // player ditaruh di UI
              ],
            ),
          ),
        );
      },
    );
  }
}
