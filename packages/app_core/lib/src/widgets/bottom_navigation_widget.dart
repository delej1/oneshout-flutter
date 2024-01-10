import 'package:app_core/app_core.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/build_icon.dart';
import 'package:awesome_bottom_bar/widgets/hexagon/hexagon.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:awesome_bottom_bar/widgets/inspired/transition_container.dart';
import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({
    Key? key,
    required this.items,
    required this.backgroundColor,
    required this.color,
    required this.colorSelected,
    required this.fixed,
    required this.indexSelected,
    this.onTap,
  }) : super(key: key);
  final bool fixed;
  final int indexSelected;
  final Function(int index)? onTap;
  final Color color;
  final Color colorSelected;
  final Color backgroundColor;
  final List<TabItem> items;

  @override
  Widget build(BuildContext context) {
    return BottomBarInspiredOutside(
      items: items,
      backgroundColor: Theme.of(context).colorScheme.primary,
      color: Colors.white.withOpacity(0.5),
      colorSelected: Colors.white,
      titleStyle: TextStyles.caption.copyWith(fontSize: 9),
      indexSelected: indexSelected,
      onTap: onTap,
      top: -30,
      padbottom: 0,
      fixed: true,
      fixedIndex: 2,
      itemStyle: ItemStyle.hexagon,
      chipStyle: ChipStyle(
        drawHexagon: true,
        color: Theme.of(context).colorScheme.primary,
        // background: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
    );
  }
}

class BottomBarInspiredOutside extends StatefulWidget {
  const BottomBarInspiredOutside({
    Key? key,
    required this.items,
    required this.backgroundColor,
    required this.color,
    required this.colorSelected,
    this.height = 40,
    this.elevation,
    this.fixed = false,
    this.indexSelected = 0,
    this.onTap,
    this.iconSize = 22,
    this.titleStyle,
    this.countStyle,
    this.chipStyle,
    this.itemStyle,
    this.borderRadius,
    this.boxShadow,
    this.top,
    this.animated = true,
    this.duration,
    this.curve,
    this.sizeInside = 48,
    this.curveSize = 70,
    this.isAnimated = true,
    this.padTop = 12,
    this.padbottom = 12,
    this.pad = 4,
    this.radius = 0,
    this.fixedIndex = 0,
  }) : super(key: key);
  final List<TabItem> items;

  final double? height;
  final Color backgroundColor;
  final double? elevation;
  final bool fixed;
  final int indexSelected;
  final Function(int index)? onTap;
  final Color color;
  final Color colorSelected;
  final double iconSize;
  final TextStyle? titleStyle;
  final CountStyle? countStyle;
  final ChipStyle? chipStyle;
  final ItemStyle? itemStyle;
  final List<BoxShadow>? boxShadow;
  final BorderRadius? borderRadius;
  final double? top;
  final bool animated;
  final bool isAnimated;
  final Duration? duration;
  final Curve? curve;
  final double? sizeInside;
  final double? curveSize;
  final double? padTop;
  final double? padbottom;
  final double? pad;
  final double? radius;
  final int? fixedIndex;

  @override
  // ignore: library_private_types_in_public_api
  _BottomBarInspiredOutsideState createState() =>
      _BottomBarInspiredOutsideState();
}

class _BottomBarInspiredOutsideState extends State<BottomBarInspiredOutside> {
  @override
  Widget build(BuildContext context) {
    return Inspired(
      height: widget.height!,
      // count: widget.items.length,
      background: widget.backgroundColor,
      fixed: widget.fixed,
      elevation: widget.elevation,
      animated: widget.animated,
      isAnimated: widget.animated,
      pad: widget.pad,
      padTop: widget.padTop,
      padbottom: widget.padbottom,
      radius: widget.radius,
      fixedIndex: widget.fixedIndex,
      items: widget.items,
      // itemBuilder: (_, int index, bool active) => buildItem(
      //   context,
      //   item: widget.items[index],
      //   index: index,
      //   isSelected: index == widget.indexSelected,
      // ),
      initialActive: widget.indexSelected,
      // iconChip: (int index) => widget.items[index].icon as IconData,
      onTap: widget.onTap,
      chipStyle: widget.chipStyle ??
          const ChipStyle(notchSmoothness: NotchSmoothness.defaultEdge),
      curveSize: widget.curveSize,
      top: widget.top ?? -28,
      containerSize: 56,
      itemStyle: widget.itemStyle,
      color: widget.color,
      colorSelected: widget.colorSelected,
    );
  }

  Widget buildItem(
    BuildContext context, {
    required TabItem item,
    required int index,
    bool isSelected = false,
  }) {
    Color itemColor() {
      // if (widget.fixed) {
      //   return isSelected ? widget.chipStyle!.background! : widget.color;
      // }
      return isSelected ? widget.colorSelected : widget.color;
    }

    if (widget.fixed ? widget.fixedIndex == index : isSelected) {
      if (widget.animated) {
        return TransitionContainer.scale(
          data: index,
          duration: widget.duration ?? const Duration(milliseconds: 350),
          curve: widget.curve ?? Curves.easeInOut,
          child: buildContentItem(
            item,
            itemColor(),
            widget.iconSize,
            widget.sizeInside!,
          ),
        );
      }
      return buildContentItem(
        item,
        itemColor(),
        widget.iconSize,
        widget.sizeInside!,
      );
    }

    return Container(
      padding: EdgeInsets.only(bottom: widget.padbottom!, top: widget.padTop!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BuildIcon(
            item: item,
            iconColor: itemColor(),
            iconSize: widget.iconSize,
            countStyle: widget.countStyle,
          ),
          if (item.title is String && item.title != '') ...[
            SizedBox(height: widget.pad),
            Text(
              item.title!,
              style: Theme.of(context)
                  .textTheme
                  .overline
                  ?.merge(widget.titleStyle)
                  .copyWith(color: itemColor()),
              textAlign: TextAlign.center,
            )
          ],
        ],
      ),
    );
  }

  Widget buildContentItem(
    TabItem item,
    Color itemColor,
    double iconSize,
    double sizeInside,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.itemStyle == ItemStyle.circle)
          Container(
            width: sizeInside,
            height: sizeInside,
            decoration: BoxDecoration(
              color: widget.chipStyle?.background,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: BuildIcon(
              item: item,
              iconColor: widget.fixed ? widget.colorSelected : itemColor,
              iconSize: iconSize,
              countStyle: widget.countStyle,
            ),
          ),
        if (widget.itemStyle == ItemStyle.hexagon)
          HexagonWidget(
            width: sizeInside,
            height: sizeInside,
            cornerRadius: 8,
            color: widget.chipStyle?.background ?? Colors.blue,
            child: BuildIcon(
              item: item,
              iconColor: widget.fixed ? widget.colorSelected : itemColor,
              iconSize: iconSize,
              countStyle: widget.countStyle,
            ),
          ),
      ],
    );
  }
}
