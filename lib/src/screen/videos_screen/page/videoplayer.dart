import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../player/src/player/youtube_player.dart';
import '../../../player/src/utils/youtube_player_controller.dart';
import '../../../player/src/utils/youtube_player_flags.dart';
import '../../../player/src/widgets/progress_bar.dart';
import '../../../utils/colors/colors.dart';
import '../model/youtube_list.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int index;
  final YoutubeListModel video;
  VideoPlayerScreen({Key? key, required this.index, required this.video})
      : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool? isVideoPlaying;
  bool isSecondaryPlayer = false;
  YoutubePlayerController? _controller;

  @override
  void initState() {
    youtubePlayerIntialize();
    super.initState();
  }

  youtubePlayerIntialize() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.videos![widget.index].videoId.toString(),
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        enableCaption: true,
        captionLanguage: 'hi',
        controlsVisibleAtStart: true,
        hideControls: false,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (val) {
          if (_controller!.value.isFullScreen) {
            _controller?.toggleFullScreenMode();
          }
        },
        child: Scaffold(
          body: Center(
            child: YoutubePlayer(
              aspectRatio: 16 / 8,
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              progressColors: const ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
              topActions: [
                forwardSeek(),
                backwardSeek(),
              ],
              onReady: () {
                // _controller!.addListener(listener);
              },
              thumbnail: Container(
                color: purpleColor.withOpacity(0.1),
              ),
            ),
          ),
        ));
  }

  Widget forwardSeek() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.topRight,
      child: Container(
        color: Colors.black,
        child: IconButton(
          icon: const Icon(Icons.forward_10, color: Colors.white),
          onPressed: () {
            _controller!.seekTo(
                _controller!.value.position + const Duration(seconds: 10));
          },
        ),
      ),
    );
  }

  Widget backwardSeek() {
    return Container(
      color: Colors.black,
      child: IconButton(
        icon: const Icon(
          Icons.replay_10,
          color: Colors.white,
        ),
        onPressed: () {
          _controller!.seekTo(
              _controller!.value.position - const Duration(seconds: 10));
        },
      ),
    );
  }

  Widget _buildVideo({required String videoId}) {
    final embedUrl =
        "https://www.youtube.com/embed/$videoId?autoplay=1&mute=1&playsinline=1&rel=0&modestbranding=1&controls=1";
    return Container(
      height: 200,
      width: 200,
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(embedUrl)),
        onEnterFullscreen: (controller) async {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        },
        onExitFullscreen: (controller) async {
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitDown,
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        },
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(
            useHybridComposition: true, // safe option
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          ),
        ),
        androidOnPermissionRequest: (controller, origin, resources) async {
          await Permission.camera.request();
          await Permission.microphone.request();
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },
      ),
    );
  }
}
