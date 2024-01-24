import 'package:app_core/src/widgets/tabbar/src/page_controller_tabbar_extension.dart';
import 'package:flutter/material.dart';

class TabbarIndicator extends StatefulWidget {
  const TabbarIndicator({
    Key? key,
    required this.controller,
    required this.tabs,
    this.color,
  }) : super(key: key);
  final PageController controller;
  final List<Widget> tabs;
  final Color? color;

  @override
  TabbarIndicatorState createState() => TabbarIndicatorState();
}

class TabbarIndicatorState extends State<TabbarIndicator> {
  GlobalKey<State<StatefulWidget>> containerKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        contentWidth = containerKey.currentContext?.size?.width ??
            MediaQuery.of(context).size.width;
      });
    });
  }

  double contentWidth = 80;

  double get padding {
    if (widget.controller.isNotInitialized) {
      return 1;
    } else {
      // final response = (widget.controller.offset) *
      //     (contentWidth - barWidth) /
      //     (widget.controller.position.maxScrollExtent);
      final response = (widget.controller.offset) *
          (contentWidth - barWidth) /
          (widget.controller.position.maxScrollExtent);

      if (response <= 0 || response.isNaN) {
        return 0;
      } else if (widget.controller.offset >
          widget.controller.position.maxScrollExtent) {
        return widget.controller.position.maxScrollExtent *
            (contentWidth - barWidth) /
            widget.controller.position.maxScrollExtent;
      }
      return response;
    }
  }

  // double get barWidth => contentWidth / widget.tabs.length;
  double get barWidth => 20;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, snapshot) {
        return SizedBox(
          key: containerKey,
          width: double.infinity,
          height: 2,
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: padding),
                color: widget.color ?? Theme.of(context).colorScheme.primary,
                width: barWidth,
                height: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
