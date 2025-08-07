import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebviewYTPlayerScreen extends StatefulWidget {
  final String videoId;

  const WebviewYTPlayerScreen({required this.videoId, super.key});

  @override
  _WebviewYTPlayerScreenState createState() => _WebviewYTPlayerScreenState();
}

class _WebviewYTPlayerScreenState extends State<WebviewYTPlayerScreen> {
  late String embedUrl;

  @override
  void initState() {
    super.initState();

    /// YouTube embed URL with proper query params
    embedUrl = 'https://www.youtube.com/embed/${"22bLNq6iCjU"}?'
        'autoplay=1&mute=0&playsinline=1&rel=0&modestbranding=1&controls=1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Video Player'),
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(embedUrl)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              mediaPlaybackRequiresUserGesture: false,
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
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
          },
        ),
      ),
    );
  }
}
