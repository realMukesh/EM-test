import 'package:flutter/material.dart';

import '../src/player/src/player/youtube_player.dart';
import '../src/player/src/utils/youtube_player_controller.dart';
import '../src/player/src/utils/youtube_player_flags.dart';
import '../src/player/src/widgets/widgets.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubePlayerScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: false,
        hideControls: false,
        hideThumbnail: true,
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
        progressIndicatorColor: Colors.redAccent,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('YouTube Player'),
          ),
          body: Column(
            children: [
              player,
              const SizedBox(height: 20),
              const Text("Your other widgets go here..."),
            ],
          ),
        );
      },
    );
  }
}
