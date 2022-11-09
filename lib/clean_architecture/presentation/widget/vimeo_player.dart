import 'package:better_video_player/better_video_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

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

class _VimeoVideoPlayerState extends State<VimeoVideoPlayer> {
  final BetterVideoPlayerController controllerBetterVideo =
      BetterVideoPlayerController();

  // late BetterVideoPlayerConfiguration betterVideoPlayerConfiguration;

  double videoContainerRatio = 0.5;

  double getScale() {
    double? videoRatio = controllerBetterVideo.videoPlayerValue?.aspectRatio;

    if (videoRatio! < videoContainerRatio) {
      return videoContainerRatio / videoRatio;
    } else {
      return videoRatio / videoContainerRatio;
    }
  }

  void listenerVideoPlayer() {
    final bool isPlaying = controllerBetterVideo.value.isLoading;
    if (isPlaying == false) {
      //controllerBetterVideo.play();
      //controllerBetterVideo.detachVideoPlayerController();
    }
  }

  @override
  void initState() {
    super.initState();

    controllerBetterVideo.addListener(listenerVideoPlayer);

    /*
      playerEventSubscription =
          controllerBetterVideo.playerEventStream.listen((event) {
        if (controllerBetterVideo.value.isVideoFinish) {
          // swiperController.next(animation: true);
        }
      });
    */
  }

  // @override
  // void deactivate() {
  //   //  controllerBetterVideo.pause();
  //   super.deactivate();
  // }

  // void pauseVideo() async {
  //   if (controllerBetterVideo.videoPlayerValue!.isPlaying) {
  //     print("Esta deteniendo");
  //     await controllerBetterVideo.pause();
  //   }
  // }

  @override
  void dispose() {
    /// disposing the controllers
    controllerBetterVideo.removeListener(listenerVideoPlayer);
    controllerBetterVideo.dispose();
    // pauseVideo();

    // playerEventSubscription.cancel();

    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   //playerEventSubscription.cancel();
  //   //controllerBetterVideo.pause();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return BetterVideoPlayer(
      controller: controllerBetterVideo,
      configuration: BetterVideoPlayerConfiguration(
        autoPlay: true,
        allowedScreenSleep: false,
        // controls: _CustomControls(isFullScreen: false),
        // fullScreenControls: _CustomControls(isFullScreen: false),
        placeholder: ExtendedImage.network(
          widget.defaultImage,
          fit: BoxFit.fill,
          cache: true,
          timeLimit: const Duration(seconds: 10),
          enableMemoryCache: true,
          enableLoadState: false,
        ),
      ),
      dataSource: BetterVideoPlayerDataSource(
        BetterVideoPlayerDataSourceType.network,
        widget.url,
      ),
    );
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
