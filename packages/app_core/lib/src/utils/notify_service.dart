import 'package:app_core/app_core.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NT { normal, success, error, warning, loading }

class NotifyTypeColor extends Equatable {
  const NotifyTypeColor({this.fg = Colors.white, this.bg = Colors.black54});
  final Color fg;
  final Color bg;
  @override
  List<Object> get props => [fg, bg];

  NotifyTypeColor copyWith({
    Color? fg,
    Color? bg,
  }) {
    return NotifyTypeColor(
      fg: fg ?? this.fg,
      bg: bg ?? this.bg,
    );
  }
}

class INotify {
  final context = AppCore.context;
  NotifyTypeColor getTypeColor(NT type) {
    var color = const NotifyTypeColor();

    switch (type) {
      case NT.success:
        color = color.copyWith(bg: Colors.green);
        break;
      case NT.normal:
        break;
      case NT.error:
        color = color.copyWith(
          bg: Theme.of(context).colorScheme.error,
          fg: Theme.of(context).colorScheme.onError,
        );
        break;
      case NT.warning:
        color = color.copyWith(
          bg: Colors.amber,
          fg: Colors.black87,
        );
        break;
      case NT.loading:
        break;
    }
    return color;
  }

  IconData? getTypeIcon(NT type) {
    switch (type) {
      case NT.success:
        return Icons.check;
      case NT.normal:
        return null;
      case NT.error:
        return Icons.cancel_outlined;
      case NT.warning:
        return null;
      case NT.loading:
        return null;
    }
  }

  BoxConstraints getSizeForDeviceType() {
    if (DeviceScreen.isTablet(context) || DeviceScreen.isMonitor(context)) {
      return const BoxConstraints(maxWidth: 568, minWidth: 288);
    } else {
      return const BoxConstraints();
    }
  }

  static AnimationController createAnimationController(
    Duration duration, {
    Duration? reverseDuration,
  }) {
    return AnimationController(
      vsync: TickerProviderImpl(),
      duration: duration,
      reverseDuration: reverseDuration,
    );
  }
}

final notify = INotify();

extension ExtensionNotify on INotify {
  void loading() {
    BotToast.showLoading();
  }

  void closeLoading() {
    BotToast.closeAllLoading();
  }

  void toast(
    String text, {
    NT type = NT.normal,
    Widget? icon,
    Duration? duration = const Duration(seconds: 2),
  }) {
    final typeColor = getTypeColor(type);
    BotToast.showText(
      text: text,
      duration: duration,
      contentColor: typeColor.bg,
      align: const Alignment(0, -0.9),
      wrapToastAnimation: (controller, cancel, Widget child) =>
          CustomAnimationWidget(
        controller: controller,
        child: child,
      ),
      contentPadding: EdgeInsets.only(
        top: Insets.lg,
        bottom: Insets.lg,
        left: icon == null ? Insets.lg : 0,
        right: Insets.lg,
        // right: onAction != null || showClose ? 0 : Insets.lg,
      ),
      textStyle: TextStyles.notificationText.copyWith(color: typeColor.fg),
    );
  }

  void snack(
    String text, {
    String title = '',
    TextAlign textAlign = TextAlign.left,
    NT type = NT.normal,
    bool important = false,
    bool showLeading = false,
    bool showClose = false,
    Widget? icon,
    String? actionText,
    VoidCallback? onAction,
    Duration? duration = const Duration(seconds: 2),
  }) {
    final typeColor = getTypeColor(type);
    final crossAxisAlignment = textAlign == TextAlign.left
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;

    BotToast.showAnimationWidget(
      clickClose: !important,
      duration: duration,
      onlyOne: true,
      animationDuration: const Duration(milliseconds: 200),
      wrapToastAnimation: (controller, cancel, Widget child) =>
          CustomAnimationWidget(
        controller: controller,
        child: child,
      ),
      toastBuilder: (cancel) {
        return Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Container(
              constraints: getSizeForDeviceType(),
              margin: EdgeInsets.all(Insets.lg),
              child: Card(
                color: typeColor.bg,
                elevation: DeviceScreen.isMonitor(context) ? 8 : 8,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: Insets.lg,
                    bottom: Insets.lg,
                    left: icon == null ? Insets.lg : 0,
                    right: onAction != null || showClose ? 0 : Insets.lg,
                  ),
                  child: Row(
                    children: <Widget>[
                      if (showLeading && icon != null) ...[icon],
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: crossAxisAlignment,
                          children: [
                            if (title.isNotEmpty)
                              Text(
                                title,
                                style: TextStyles.notificationTitle
                                    .copyWith(color: typeColor.fg),
                                textAlign: textAlign,
                              ),
                            Text(
                              text,
                              style: TextStyles.notificationText
                                  .copyWith(color: typeColor.fg),
                              textAlign: textAlign,
                            ),
                          ],
                        ),
                      ),
                      if (showClose && onAction == null) ...[
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          color: typeColor.fg,
                          onPressed: cancel,
                        )
                      ],
                      if (onAction != null) ...[
                        TextBtn(
                          actionText!.toUpperCase(),
                          onPressed: () {
                            onAction();
                            cancel();
                          },
                          style: TextStyles.button.copyWith(
                            fontWeight: FontWeight.bold,
                            color: typeColor.fg,
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomAnimationWidget extends StatefulWidget {
  const CustomAnimationWidget({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);
  final AnimationController controller;
  final Widget child;

  @override
  CustomAnimationWidgetState createState() => CustomAnimationWidgetState();
}

class CustomAnimationWidgetState extends State<CustomAnimationWidget> {
  static final Tween<Offset> tweenOffset = Tween<Offset>(
    begin: const Offset(0, 40),
    end: Offset.zero,
  );

  static final Tween<double> tweenScale = Tween<double>(begin: 0.7, end: 1);
  static final Tween<double> tweenOpacity = Tween<double>(begin: 0, end: 1);
  late Animation<double> animation;

  @override
  void initState() {
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: tweenOffset.evaluate(animation),
          child: FadeTransition(
            opacity: animation,
            child: Transform.scale(
              scale: tweenScale.evaluate(animation),
              child: Opacity(
                opacity: animation.value,
                child: child,
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

// class CustomOffsetAnimation extends StatefulWidget {
//   final AnimationController controller;
//   final Widget child;
//   final bool reverse;

//   const CustomOffsetAnimation(
//       {Key key, this.controller, this.child, this.reverse = false})
//       : super(key: key);

//   @override
//   _CustomOffsetAnimationState createState() => _CustomOffsetAnimationState();
// }

// class _CustomOffsetAnimationState extends State<CustomOffsetAnimation> {
//   Tween<Offset> tweenOffset;

//   Animation<double> animation;

//   @override
//   void initState() {
//     tweenOffset = Tween<Offset>(
//       begin: Offset(widget.reverse ? -0.8 : 0.8, 0.0),
//       end: Offset.zero,
//     );
//     animation =
//         CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       child: widget.child,
//       animation: widget.controller,
//       builder: (BuildContext context, Widget child) {
//         return FractionalTranslation(
//             translation: tweenOffset.evaluate(animation),
//             child: Opacity(
//               opacity: animation.value,
//               child: child,
//             ));
//       },
//     );
//   }
// }

// class CustomAttachedAnimation extends StatefulWidget {
//   final AnimationController controller;
//   final Widget child;

//   const CustomAttachedAnimation({Key key, this.controller, this.child})
//       : super(key: key);

//   @override
//   _CustomAttachedAnimationState createState() =>
//       _CustomAttachedAnimationState();
// }

// class _CustomAttachedAnimationState extends State<CustomAttachedAnimation> {
//   Animation<double> animation;
//   static final Tween<Offset> tweenOffset = Tween<Offset>(
//     begin: const Offset(0, 40),
//     end: const Offset(0, 0),
//   );

//   @override
//   void initState() {
//     animation =
//         CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       child: widget.child,
//       animation: widget.controller,
//       builder: (BuildContext context, Widget child) {
//         return ClipRect(
//           child: Align(
//             heightFactor: animation.value,
//             widthFactor: animation.value,
//             child: Opacity(
//               opacity: animation.value,
//               child: child,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
