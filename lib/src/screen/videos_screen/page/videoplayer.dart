import 'package:flutter/cupertino.dart';

import '../model/youtube_list.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
    // controller = PodPlayerController(
    //
    //
    //   playVideoFrom: PlayVideoFrom.youtube(widget.video.videos![widget.index].videoId.toString()),
    //   // playVideoFrom: PlayVideoFrom.youtube("A3ltMaM6noM",),
    //   // playVideoFrom: PlayVideoFrom.network("https://www.youtube.com/watch?v=8O2absyUlN8",),
    //   // playVideoFrom: PlayVideoFrom.networkQualityUrls(videoUrls: [VideoQalityUrls(quality: 360, url: "https://www.youtube.com/watch?v=8O2absyUlN8")]),
    //
    //
    //   // podPlayerConfig:const  PodPlayerConfig(
    //   //
    //   //   isLooping: false,
    //   //   autoPlay: false,
    //   //
    //   // ),
    //     podPlayerConfig: const PodPlayerConfig(
    //         autoPlay: true,
    //         isLooping: false,
    //         videoQualityPriority: [720, 360]
    //     )
    // )..initialise().onError((error, stackTrace) {
    //   print("Error: $error");
    //   setState(() {
    //     isSecondaryPlayer=true;
    //   });
    youtubePlayerIntialize();
    // });

    super.initState();
  }

  youtubePlayerIntialize() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.videos![widget.index].videoId!.toString(),
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
//   _controller = YoutubePlayerController(
//
//     params: const YoutubePlayerParams(
//       showControls: true,
//
//
//       mute: false,
//
//       showFullscreenButton: true,
//
//
//       loop: false,
//
//     ),
//
//
//
//   );
// _controller!.enterFullScreen(lock: false);
//
//   _controller!.setFullScreenListener(
//         (isFullScreen) {
//       log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
//     },
//   );
//
//   if (widget.video.videos![widget.index].videoId != null) {
//     _controller?.loadVideoById(videoId:widget.video.videos![widget.index].videoId!);
//   }
// else{
//   Fluttertoast.showToast(msg: "Video not available");
//   }
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
        )
        // child: YoutubePlayerScaffold(
        //
        //   controller: _controller!,
        //
        //   aspectRatio: 16 / 9,
        //   enableFullScreenOnVerticalDrag: false,
        //
        //
        //
        //   autoFullScreen: true,
        //   builder: (context, player) {
        //     return Scaffold(
        //       appBar: AppBar(
        //         title:  Text(widget.video.videos![widget.index].title??""),
        //       ),
        //       body: LayoutBuilder(
        //         builder: (context, constraints) {
        //           if (kIsWeb && constraints.maxWidth > 750) {
        //             return Row(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Expanded(
        //                   flex: 3,
        //                   child: Column(
        //                     children: [
        //                       player,
        //                       const VideoPositionIndicator(),
        //                     ],
        //                   ),
        //                 ),
        //                 const Expanded(
        //                   flex: 2,
        //                   child: SingleChildScrollView(
        //                     child: Controls(),
        //                   ),
        //                 ),
        //               ],
        //             );
        //           }
        //
        //           return ListView(
        //             children: [
        //               player,
        //               const VideoPositionIndicator(),
        //               const Controls(),
        //             ],
        //           );
        //         },
        //       ),
        //     );
        //   },
        // ),
        );
    // return Scaffold(
    //   body:
    //
    // Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text("English Madhyam",style: TextStyle(color: purpleColor,fontSize: 16,fontWeight: FontWeight.w700),),
    //         ),
    //         YoutubePlayer(
    //
    //          controller: _controller!,
    //
    //          showVideoProgressIndicator: true,
    //          progressIndicatorColor: Colors.amber,
    //
    //          progressColors: const ProgressBarColors(
    //            playedColor: Colors.amber,
    //            handleColor: Colors.amberAccent,
    //          ),
    //          onReady: () {
    //            // _controller!.addListener(listener);
    //          },
    //              ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget forwardSeek() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      alignment: Alignment.topRight,
      child: Container(
        color: Colors.black,
        child: IconButton(
          icon: Icon(Icons.forward_10, color: Colors.white),
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
        icon: Icon(
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
}
