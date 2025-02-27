part of './controller_widget_builder.dart';

enum FullScreenType {
  rotateScreen,
  rotateBox,
}

showFullScreenIJKPlayer(
  BuildContext context,
  IjkMediaController controller, {
  Widget customWidget,
  ValueChanged<bool> onFullButton,
  IJKControllerWidgetBuilder fullscreenControllerWidgetBuilder,
  FullScreenType fullScreenType = FullScreenType.rotateBox,
  StatusWidgetBuilder statusWidgetBuilder,
  bool hideSystemBar = true,
  void Function(bool enter) onFullscreen,
}) async {
  if (fullScreenType == FullScreenType.rotateBox) {
    _showFullScreenWithRotateBox(
      context,
      controller,
      customWidget: customWidget,
      onFullButton: onFullButton,
      fullscreenControllerWidgetBuilder: fullscreenControllerWidgetBuilder,
      hideSystemBar: hideSystemBar,
      onFullscreen: onFullscreen,
    );
    return;
  }

  _showFullScreenWithRotateScreen(
    context,
    controller,
    customWidget,
    onFullButton,
    fullscreenControllerWidgetBuilder,
    statusWidgetBuilder,
    hideSystemBar: hideSystemBar,
    onFullscreen: onFullscreen,
  );
}

_showFullScreenWithRotateScreen(
    BuildContext context,
    IjkMediaController controller,
    Widget customWidget,
    ValueChanged<bool> onFullButton,
    IJKControllerWidgetBuilder fullscreenControllerWidgetBuilder,
    StatusWidgetBuilder statusWidgetBuilder,
    {bool hideSystemBar,
  void Function(bool enter) onFullscreen,}
    ) async {

  if (hideSystemBar) {
    IjkManager.showStatusBar(false);
  }
  Navigator.push(
    context,
    FullScreenRoute(
      builder: (c) {
        return IjkPlayer(
          mediaController: controller,
          statusWidgetBuilder: statusWidgetBuilder,
           controllerWidgetBuilder: (ctl) {
                return DefaultIJKControllerWidget(
                  controller: controller,
                  customWidget: customWidget,
                  currentFullScreenState: true,
                  onFullButton: onFullButton,
                  fullscreenControllerWidgetBuilder: (ctl) {
                    return fullscreenControllerWidgetBuilder(ctl);
                  },
                );
              },
        );
      },
    ),
  ).then((_) {
    IjkManager.unlockOrientation();
    IjkManager.setCurrentOrientation(DeviceOrientation.portraitUp);
    if (hideSystemBar) {
      IjkManager.showStatusBar(true);
    }
    onFullscreen?.call(false);
  });

  onFullscreen?.call(true);

  var info = await controller.getVideoInfo();

  Axis axis;

  if (info.width == 0 || info.height == 0) {
    axis = Axis.horizontal;
  } else if (info.width > info.height) {
    if (info.degree == 90 || info.degree == 270) {
      axis = Axis.vertical;
    } else {
      axis = Axis.horizontal;
    }
  } else {
    if (info.degree == 90 || info.degree == 270) {
      axis = Axis.horizontal;
    } else {
      axis = Axis.vertical;
    }
  }

  if (axis == Axis.horizontal) {
    IjkManager.setLandScape();
  } else {
    IjkManager.setPortrait();
  }
}

_showFullScreenWithRotateBox(
  BuildContext context,
  IjkMediaController controller, {
  Widget customWidget,
  ValueChanged<bool> onFullButton,
  IJKControllerWidgetBuilder fullscreenControllerWidgetBuilder,
  StatusWidgetBuilder statusWidgetBuilder,
  bool hideSystemBar,
  void Function(bool enter) onFullscreen,
}) async {
  var info = await controller.getVideoInfo();

  Axis axis;

  if (info.width == 0 || info.height == 0) {
    axis = Axis.horizontal;
  } else if (info.width > info.height) {
    if (info.degree == 90 || info.degree == 270) {
      axis = Axis.vertical;
    } else {
      axis = Axis.horizontal;
    }
  } else {
    if (info.degree == 90 || info.degree == 270) {
      axis = Axis.horizontal;
    } else {
      axis = Axis.vertical;
    }
  }

  if (hideSystemBar) {
    IjkManager.showStatusBar(false);
  }

  Navigator.push(
    context,
    FullScreenRoute(
      builder: (ctx) {
        var mediaQueryData = MediaQuery.of(ctx);

        int quarterTurns;

        if (axis == Axis.horizontal) {
          if (mediaQueryData.orientation == Orientation.landscape) {
            quarterTurns = 0;
          } else {
            quarterTurns = 1;
          }
        } else {
          quarterTurns = 0;
        }
        /*else {
          if (mediaQueryData.orientation == Orientation.portrait) {
            quarterTurns = 0;
          } else {
            quarterTurns = -1;
          }
        }*/

        return SafeArea(
          child: RotatedBox(
            quarterTurns: quarterTurns,
            child: IjkPlayer(
              mediaController: controller,
              statusWidgetBuilder: statusWidgetBuilder,
              controllerWidgetBuilder: (ctl) {
                return DefaultIJKControllerWidget(
                  controller: controller,
                  customWidget: customWidget,
                  onFullButton: onFullButton,
                  currentFullScreenState: true,
                  fullscreenControllerWidgetBuilder: (ctl) {
                    return fullscreenControllerWidgetBuilder(ctl);
                  },
                );
              },
            ),
          ),
        );
      },
    ),
  ).then((data) {
    if (hideSystemBar) {
      IjkManager.showStatusBar(true);
    }
    onFullscreen?.call(false);
  });

  onFullscreen?.call(true);
}

Widget _buildFullScreenMediaController(
    IjkMediaController controller, bool fullScreen) {
  return DefaultIJKControllerWidget(
    controller: controller,
    currentFullScreenState: true,
  );
}

Widget buildFullscreenMediaController(IjkMediaController controller) {
  return _buildFullScreenMediaController(controller, true);
}
