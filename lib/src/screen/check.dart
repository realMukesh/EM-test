//
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// class CurrentAlbumPage extends StatefulWidget {
//   final Album ?album;
//
//   CurrentAlbumPage({@required this.album});
//
//   @override
//   _CurrentPlayingPageState createState() => _CurrentPlayingPageState();
// }
//
// class _CurrentPlayingPageState extends State<CurrentAlbumPage>
//     with TickerProviderStateMixin {
//   final double iconSize = 35.0;
//   final Color iconColor = Colors.deepOrangeAccent;
//
//   AnimationController _needleAnimCtrl;
//   AnimationController _recordAnimCtrl;
//   OverlayState _overlayState;
//   OverlayEntry _overlayEntry;
//   CurrentAlbumBloc _bloc;
//
//   @override
//   initState() {
//     super.initState();
//     _recordAnimCtrl = AnimationController(
//         duration: Duration(milliseconds: 4000), vsync: this);
//     _needleAnimCtrl = AnimationController(
//         duration: Duration(milliseconds: 1000),
//         vsync: this,
//         lowerBound: -0.2,
//         upperBound: 0.0)
//       ..addStatusListener((status) => _startRecordAnimation(status));
//   }
//
//   // Starts animating the Record Widget as soon as
//   // the needle animation is completed.
//   void _startRecordAnimation(AnimationStatus status) {
//     if (status == AnimationStatus.completed) _recordAnimCtrl.repeat();
//     if (status == AnimationStatus.reverse) _recordAnimCtrl.stop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _bloc = BlocProvider.of<CurrentAlbumBloc>(context);
//     return SafeArea(
//       child: Material(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             iconTheme: IconThemeData(
//               color: Colors.pink,
//             ),
//             title: ValueListenableBuilder<List<String>>(
//                 valueListenable: _bloc.songInfo,
//                 builder: (_, list, __) => Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       list.isNotEmpty ? list.elementAt(0) : "",
//                       style: TextStyle(fontSize: 18.0, color: Colors.pink),
//                     ),
//                     Text(
//                       list.isNotEmpty ? list.elementAt(1) : "",
//                       style: TextStyle(fontSize: 14.0, color: Colors.pink),
//                     ),
//                   ],
//                 )),
//             leading: IconButton(
//               icon: Icon(Icons.keyboard_backspace, size: 30.0),
//               onPressed: () {},
//             ),
//           ),
//           body: Stack(
//             fit: StackFit.expand,
//             children: <Widget>[
//               _buildRecordWidget(),
//               _buildNeedleWidget(),
//               _buildPlaybackControls(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRecordWidget() {
//     return Positioned(
//       top: 100.0,
//       child: GestureDetector(
//         child: RotationTransition(
//           turns: _recordAnimCtrl,
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             alignment: Alignment.center,
//             child: Hero(
//               tag: "${widget.album.id}",
//               child: RecordWidget.largeImage(
//                 diameter: 260.0,
//                 albumArt: widget.album.albumArt,
//               ),
//             ),
//           ),
//         ),
//         onDoubleTap: () => _showSongsList(context),
//       ),
//     );
//   }
//
//   Widget _buildNeedleWidget() {
//     return Positioned(
//       top: 50.0,
//       right: 0.0,
//       child: RotationTransition(
//         turns: _needleAnimCtrl,
//         // To make the needle swivel around the white circle
//         // the alignment is placed placed at the center of the white circle
//         alignment: FractionalOffset(4 / 5, 1 / 6),
//         child: NeedleWidget(
//           size: 130.0,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlaybackControls() {
//     return Positioned(
//       bottom: 0.0,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: 150.0,
//         color: Colors.white,
//         child: StreamBuilder<List<AudioMedia>>(
//             stream: _bloc.albumSongsListStream,
//             builder: (BuildContext context,
//                 AsyncSnapshot<List<AudioMedia>> snapshot) {
//               bool data = snapshot.hasData && snapshot.data.isNotEmpty;
//               return Column(
//                 children: <Widget>[
//                   StreamBuilder<List<String>>(
//                       stream: _bloc.uiStream,
//                       initialData: ["0.0", "00:00", "00:00"],
//                       builder: (context, snapshot) {
//                         List<String> list = snapshot.data;
//                         return Column(
//                           children: <Widget>[
//                             Slider(
//                               value: double.parse(list.elementAt(0)),
//                               min: 0.0,
//                               max: list.elementAt(2) == "00:00" ? 0.0 : 1.0,
//                               onChanged: data ? (value) => _seek(value) : null,
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(horizontal: 16.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Text("${list.elementAt(1)}"),
//                                   Text("${list.elementAt(2)}"),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         IconButton(
//                           icon: Icon(Icons.repeat),
//                           onPressed: data ? () {} : null,
//                           iconSize: iconSize,
//                           color: iconColor,
//                         ),
//                         IconButton(
//                             onPressed: data ? () {} : null,
//                             icon: ImageIcon(
//                               AssetImage('assets/rewind.png'),
//                               size: iconSize,
//                               color: iconColor,
//                             )),
//                         CircleAvatar(
//                           backgroundColor: iconColor,
//                           radius: 30.0,
//                           child: ValueListenableBuilder<String>(
//                               valueListenable: _bloc.playState,
//                               builder: (_, value, __) {
//                                 return IconButton(
//                                   icon: Icon(
//                                     value == "play" || value == "resume"
//                                         ? Icons.pause
//                                         : Icons.play_arrow,
//                                     size: iconSize,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: data ? _playOrPauseSong : null,
//                                 );
//                               }),
//                         ),
//                         IconButton(
//                             onPressed: data ? () {} : null,
//                             icon: ImageIcon(
//                               AssetImage('assets/forward.png'),
//                               size: iconSize,
//                               color: iconColor,
//                             )),
//                         IconButton(
//                           icon: Icon(Icons.favorite_border),
//                           onPressed: data ? () {} : null,
//                           iconSize: iconSize,
//                           color: iconColor,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               );
//             }),
//       ),
//     );
//   }
//
//   void _showSongsList(BuildContext context) {
//     _overlayState = Overlay.of(context);
//     _overlayEntry = OverlayEntry(
//         builder: (context) => AspectRatio(
//           aspectRatio: 1.0,
//           child: GestureDetector(
//             onHorizontalDragUpdate: (_) => _removeOverlay(),
//             child: ClipPath(
//               clipper: SongListClipper(
//                   screenWidth: MediaQuery.of(context).size.width,
//                   padding: 8.0),
//               child: OverflowBox(
//                 alignment: Alignment.center,
//                 maxWidth: MediaQuery.of(context).size.width + 100.0,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width + 100.0,
//                   child: CircleAvatar(
//                     child: _buildSongList(context),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//     _overlayState.insert(_overlayEntry);
//   }
//
//   Widget _buildSongList(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.symmetric(horizontal: 100.0),
//       child: Center(
//         child: StreamBuilder(
//             stream: _bloc.albumSongsListStream,
//             builder: (BuildContext context,
//                 AsyncSnapshot<List<AudioMedia>> snapshot) {
//               return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: snapshot.data?.length ?? 0,
//                   itemBuilder: (context, index) {
//                     AudioMedia media = snapshot.data.elementAt(index);
//                     return Column(
//                       children: <Widget>[
//                         Divider(
//                           height: 10.0,
//                           color: Colors.white70,
//                         ),
//                         Text(
//                           media.title,
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                         index == snapshot.data.length - 1
//                             ? Divider(
//                           height: 10.0,
//                           color: Colors.white70,
//                         )
//                             : Container()
//                       ],
//                     );
//                   });
//             }),
//       ),
//     );
//   }
//
//   void _removeOverlay() => _overlayEntry?.remove();
//
//   Future<Null> _playOrPauseSong() async {
//     if (_bloc.playState.value != "play" &&
//         _bloc.playState.value != "pause" &&
//         _bloc.playState.value != "resume") {
//       _needleAnimCtrl.forward();
//       // Wait for the needle animation to complete
//       // before adding the song
//       await Future.delayed(Duration(milliseconds: 1000));
//       _bloc.startSong.add(0);
//       _bloc.playState.addListener(_onPlaybackEvent);
//     } else if (_bloc.playState.value == "play" ||
//         _bloc.playState.value == "resume") {
//       _bloc.playState.value = "pause";
//     } else {
//       _bloc.playState.value = "resume";
//     }
//   }
//
//   Future<Null> _onPlaybackEvent() async {
//     switch (_bloc.playState.value) {
//       case "stop":
//         _recordAnimCtrl.stop();
//         _needleAnimCtrl.reverse();
//         // Wait for the needle reverse animation to complete
//         // before resetting the controller
//         await Future.delayed(Duration(milliseconds: 1000));
//         _needleAnimCtrl.reset();
//         break;
//       case "error":
//         _recordAnimCtrl.stop();
//         _needleAnimCtrl.reverse();
//         break;
//       case "pause":
//         _recordAnimCtrl.stop();
//         break;
//       case "resume":
//         _recordAnimCtrl.repeat();
//         break;
//     }
//   }
//
//   void _seek(double value) {
//     _bloc.seekTo.add(value);
//   }
//
//   @override
//   void dispose() {
//     _needleAnimCtrl.dispose();
//     _recordAnimCtrl.dispose();
//     _removeOverlay();
//     _bloc.dispose();
//     super.dispose();
//   }
// }
// class AlbumsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final AlbumsPageBloc bloc = BlocProvider.of<AlbumsPageBloc>(context);
//     return StreamBuilder<List<Album>>(
//       stream: bloc.albumListStream,
//       builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
//         if (!snapshot.hasData)
//           return Container(
//             child: Center(child: Text("Loading Albums....")),
//           );
//         return ListView.builder(
//           itemCount: snapshot.data.length,
//           itemBuilder: (context, index) {
//             Album album = snapshot.data.elementAt(index);
//             return GestureDetector(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Hero(
//                       tag: "${album.id}",
//                       child: RecordWidget(
//                         diameter: 130.0,
//                         albumArt: album.albumArt,
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               "${album.artist}",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20.0,
//                                   color: Color(0xFF444444)),
//                             ),
//                             Text(
//                               "${album.album}",
//                               style: TextStyle(
//                                   fontSize: 15.0,
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Divider(
//                               height: 5.0,
//                             ),
//                             Text(
//                               "${album.numOfSongs} Songs",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               onTap: () => _navigateToCurrentPlaying(context, album),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _navigateToCurrentPlaying(BuildContext context, Album album) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) {
//         return BlocProvider<CurrentAlbumBloc>(
//           bloc: CurrentAlbumBloc(album.id),
//           child: CurrentAlbumPage(
//             album: album,
//           ),
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

      ),
    );
  }
}
