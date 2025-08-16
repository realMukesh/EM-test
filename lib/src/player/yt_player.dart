/*
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';
import '../main.dart'; // your app-level routeObserver

class YTScreen extends StatefulWidget {
  final String url;

  const YTScreen({super.key, required this.url});

  @override
  State<YTScreen> createState() => _YTScreenState();
}

class _YTScreenState extends State<YTScreen>
    with WidgetsBindingObserver, RouteAware {
  late YoutubePlayerController _controller;
  DateTime? _playStartTime;
  Duration _totalWatchTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final videoId = YoutubePlayerController.convertUrlToId(widget.url);

    //  final videoId = YoutubePlayerController.convertUrlToId("https://www.youtube.com/embed/R5adGc_VvkA");

    if (videoId == null || videoId.isEmpty)
      throw Exception("Invalid YouTube URL");

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        mute: false,
        loop: false,
        playsInline: true,
        showControls: true,
        showFullscreenButton: true,
        showVideoAnnotations: false,
        enableCaption: false,
        strictRelatedVideos: true,
      ),
    );

    _controller.listen((event) {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _accumulateWatchTime() {
    return;
    if (_playStartTime != null) {
      final session = DateTime.now().difference(_playStartTime!);
      _totalWatchTime += session;
      print(
          "📴 Session: ${session.inSeconds}s, Total: ${_totalWatchTime.inSeconds}s");
      _playStartTime = null;
    }
  }

  @override
  void dispose() {
    print("🧹 Disposing...");
    _accumulateWatchTime();
    _controller.close();
    //routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    _controller.pauseVideo();
    _accumulateWatchTime();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller.pauseVideo();
      _accumulateWatchTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: player,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
*/
