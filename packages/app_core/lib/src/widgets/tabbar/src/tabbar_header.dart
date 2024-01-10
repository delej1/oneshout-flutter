import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class TabbyHeader extends StatefulWidget {
  const TabbyHeader({
    super.key,
    required this.tabs,
    required this.controller,
    this.height = 40,
  });
  final List<String> tabs;
  final PageController controller;
  final double height;

  @override
  State<TabbyHeader> createState() => _TabbyHeaderState();
}

class _TabbyHeaderState extends State<TabbyHeader>
    with SingleTickerProviderStateMixin {
  // Coordinates
  double? _x;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  List<GlobalKey> _keys = [];
  int active = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      active = widget.controller.page!.ceil();

      if ((active % 1) == 0) {
        setState(() {
          active = active;
          _getOffset(_keys[active]);
        });
      }
    });
    _controller = AnimationController(vsync: this, duration: duration);
    for (var i = 0; i < widget.tabs.length; i++) {
      _keys.add(GlobalKey());
    }
    setState(() {
      _keys = _keys;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  // This function is called when the user presses the floating button
  void _getOffset(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final position = box?.localToGlobal(Offset.zero);
    if (position != null) {
      setState(() {
        _x = position.dx - Insets.md;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          Positioned(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i in widget.tabs) ...[
                  _buildTab(i, context),
                  HSpace.lg,
                ],
              ],
            ),
          ),
          AnimatedPositioned(
            left: _x,
            top: 30,
            duration: duration,
            child: DecoratedContainer(
              width: 20,
              height: 4,
              borderRadius: Corners.btn,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTab(String text, BuildContext context) {
    final index = widget.tabs.indexOf(text);
    var style = TextStyles.subtitle1;
    // .apply(color: Theme.of(context).colorScheme.onSurfaceVariant);

    if (active == index) {
      style = style.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
    }

    return GestureDetector(
      key: _keys[widget.tabs.indexOf(text)],
      onTap: () {
        _getOffset(_keys[index]);

        setState(() {
          active = index;
        });

        if (widget.controller.isInitialized) {
          widget.controller.animateToPage(
            index,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
          );
        }
      },
      child: Text(text, style: style),
    );
  }
}
