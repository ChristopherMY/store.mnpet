import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:better_video_player/better_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store_mundo_pet/clean_architecture/domain/model/vimeo_video_config.dart';

class VimeoVideoPlayer extends StatefulWidget {
  const VimeoVideoPlayer({
    Key? key,
    required this.url,
    required this.defaultImage,
  }) : super(key: key);

  final String url;
  final String defaultImage;

  @override
  State<VimeoVideoPlayer> createState() => _VimeoVideoPlayerState();
}

class _VimeoVideoPlayerState extends State<VimeoVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  final BetterVideoPlayerController controllerBetterVideo =
      BetterVideoPlayerController();
  late BetterVideoPlayerConfiguration betterVideoPlayerConfiguration;

  ValueNotifier<bool> isVimeoVideoLoaded = ValueNotifier(false);

  bool get _isVimeoVideo {
    var regExp = RegExp(
      r"^((https?):\/\/)?(www.)?vimeo\.com\/([0-9]+).*$",
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(widget.url);
    if (match != null && match.groupCount >= 1) return true;
    return false;
  }

  late String vimeoMp4Video;

  double videoContainerRatio = 0.5;

  double getScale() {
    double? videoRatio = controllerBetterVideo.videoPlayerValue?.aspectRatio;

    if (videoRatio! < videoContainerRatio) {
      return videoContainerRatio / videoRatio;
    } else {
      return videoRatio / videoContainerRatio;
    }
  }

  @override
  void initState() {
    super.initState();

    controllerBetterVideo.addListener(
      () {
        final bool isPlaying = controllerBetterVideo.value.isLoading;
        if (isPlaying == false) {
          //controllerBetterVideo.play();
          //controllerBetterVideo.detachVideoPlayerController();
        }
      },
    );

    /*
    playerEventSubscription =
        controllerBetterVideo.playerEventStream.listen((event) {
      if (controllerBetterVideo.value.isVideoFinish) {
        // swiperController.next(animation: true);
      }
    });
    */

    /// checking that vimeo url is valid or not
    if (_isVimeoVideo) {
      _videoPlayer();
    }
  }

  @override
  void deactivate() {
    //  controllerBetterVideo.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    /// disposing the controllers
    controllerBetterVideo.pause();
    controllerBetterVideo.dispose();
    //playerEventSubscription.cancel();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    //playerEventSubscription.cancel();
    //controllerBetterVideo.pause();
    super.didChangeDependencies();
  }

  Future _videoPlayer() async {
    if (_isVimeoVideo) {
      /// getting the vimeo video configuration from api and setting managers
      await _getVimeoVideoConfigFromUrl(widget.url).then((value) {
        vimeoMp4Video = value?.request?.files?.progressive![0].url ?? '';
        print("Este es el link: ${vimeoMp4Video}");
        isVimeoVideoLoaded.value = !isVimeoVideoLoaded.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder(
      valueListenable: isVimeoVideoLoaded,
      builder: (context, bool isVideo, child) => Container(
        child: isVideo
            ? BetterVideoPlayer(
                controller: controllerBetterVideo,
                configuration: BetterVideoPlayerConfiguration(
                  autoPlay: true,
                  allowedScreenSleep: false,
                  // controls: _CustomControls(isFullScreen: false),
                  // fullScreenControls: _CustomControls(isFullScreen: false),
                  placeholder: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          widget.defaultImage,
                        ),
                      ),
                    ),
                  ),
                ),
                dataSource: BetterVideoPlayerDataSource(
                  BetterVideoPlayerDataSourceType.network,
                  vimeoMp4Video,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      widget.defaultImage,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  /// used to get valid vimeo video configuration
  Future<VimeoVideoConfig?> _getVimeoVideoConfigFromUrl(
    String url, {
    bool trimWhitespaces = true,
  }) async {
    if (trimWhitespaces) url = url.trim();

    /**
        here i'm converting the vimeo video id only and calling config api for vimeo video .mp4
        supports this types of urls
        https://vimeo.com/70591644 => 70591644
        www.vimeo.com/70591644 => 70591644
        vimeo.com/70591644 => 70591644
     */
    var vimeoVideoId = '';
    var videoIdGroup = 4;
    for (var exp in [
      RegExp(r"^((https?):\/\/)?(www.)?vimeo\.com\/([0-9]+).*$"),
    ]) {
      RegExpMatch? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        vimeoVideoId = match.group(videoIdGroup) ?? '';
      }
    }

    final response = await _getVimeoVideoConfig(vimeoVideoId: vimeoVideoId);
    return (response != null) ? response : null;
  }

  /// give vimeo video configuration from api
  Future<VimeoVideoConfig?> _getVimeoVideoConfig({
    required String vimeoVideoId,
  }) async {
    try {
      http.Response responseData = await http.get(
        Uri.parse('https://player.vimeo.com/video/$vimeoVideoId/config'),
      );

      var vimeoVideo = VimeoVideoConfig.fromMap(jsonDecode(responseData.body));
      return vimeoVideo;
    } catch (e) {
      log('Dio Error : ', name: e.toString());
      return null;
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/*
class _CustomControls extends BetterVideoPlayerControls {
  final bool isFullScreen;

  _CustomControls({this.isFullScreen});

  @override
  State<StatefulWidget> createState() {
    return _CustomControlsState();
  }
}

class _CustomControlsState extends BetterVideoPlayerControlsState {
  Widget buildPlayPause(Function() onTap) {
    final controller = context.watch<BetterVideoPlayerController>();
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      onPressed: onTap,
      child: controller.value.videoPlayerController?.value?.isPlaying ?? false
          ? Image.asset("assets/player/pause.png", width: 26, height: 26)
          : Image.asset("assets/player/play.png", width: 26, height: 26),
    );
  }

  Widget buildExpand(Function() onTap) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      onPressed: onTap,
      child: widget.isFullScreen
          ? Image.asset("assets/player/full_screen_exit.png",
              width: 26, height: 26)
          : Image.asset("assets/player/full_screen.png", width: 26, height: 26),
    );
  }

  Widget buildReplay(VoidCallback onTap) {
    return Container(
      color: Colors.black38,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset("assets/player/replay.png",
                      width: 26, height: 26),
                ),
                Text(
                  "Repetir",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCenterPause(VoidCallback onTap) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black26,
            ),
            child: Image.asset("assets/player/play.png", width: 26, height: 26),
          ),
        ),
      ),
    );
  }

  Widget buildWifiInterrupted(VoidCallback onTap) {
    return Container(
      color: Colors.black38,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "La reproducción consumirá datos, confirme para continuar mirando ",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 32,
                onPressed: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF671F),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Text(
                      "Reanudar",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildError(Function() onTap) {
    return Container(
      color: Colors.black38,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "No se puede conectar a la red, verifique la configuración de la red e intente nuevamente",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 32,
                onPressed: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF671F),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Text(
                      "Haga clic para intentarlo de nuevo ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopBar(Function() onTap) {
    if (widget.isFullScreen)
      return Align(
        alignment: Alignment.topLeft,
        child: CupertinoButton(
          onPressed: onTap,
          child: Container(
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      );
    else
      return SizedBox();
  }

  List<Widget> buildCustomWidgets(bool isHide) {
    return [
      AnimatedOpacity(
        opacity: !isHide ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Align(
          alignment: Alignment.centerLeft,
          child: CupertinoButton(
            onPressed: null,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black26,
              ),
              child: Icon(Icons.chevron_left, size: 26, color: Colors.white),
            ),
          ),
        ),
      ),
      AnimatedOpacity(
        opacity: !isHide ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Align(
          alignment: Alignment.centerRight,
          child: CupertinoButton(
            onPressed: null,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black26,
              ),
              child: Icon(Icons.chevron_right, size: 26, color: Colors.white),
            ),
          ),
        ),
      ),
    ];
  }
}
*/
