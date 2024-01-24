import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class FilteredChip extends StatefulWidget {
  const FilteredChip({
    super.key,
    this.active = 0,
    required this.onChanged,
    this.children = const [],
    this.height,
  });

  final int? active;
  final void Function(int) onChanged;
  final List<String> children;
  final double? height;

  @override
  State<FilteredChip> createState() => _FilteredChipState();
}

class _FilteredChipState extends State<FilteredChip> {
  late int activeValue;

  @override
  void initState() {
    super.initState();
    activeValue = widget.active!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? Sizes.xxl,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.children.length,
        itemBuilder: (BuildContext context, int index) {
          final c = widget.children[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                activeValue = index;
              });
              widget.onChanged(index);
            },
            child: _chip(
              label: c,
              active: index == activeValue,
              context: context,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return HSpace.md;
        },
      ),
    );
  }

  Widget _chip({
    required bool active,
    required String label,
    required BuildContext context,
  }) {
    final bgColor = active
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.background.withOpacity(0.5);

    final fgColor = active
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onBackground.withOpacity(0.5);
    return DecoratedContainer(
      height: Sizes.xxl,
      width: Sizes.xxl,
      borderRadius: Insets.sm,
      padding: EdgeInsets.all(Insets.xs),
      color: bgColor,
      child: Center(
        child: Text(
          label,
          style: TextStyles.title2.copyWith(
            color: fgColor,
          ),
        ),
      ),
    );
  }
}

class FilteredChipExt extends StatefulWidget {
  const FilteredChipExt({
    super.key,
    this.active = 0,
    required this.onChanged,
    this.children = const [],
    this.icons = const [],
    this.height,
  });

  final int? active;
  final void Function(int) onChanged;
  final List<String> children;
  final List<IconData> icons;
  final double? height;

  @override
  State<FilteredChipExt> createState() => _FilteredChipExtState();
}

class _FilteredChipExtState extends State<FilteredChipExt> {
  late int activeValue;

  @override
  void initState() {
    super.initState();
    activeValue = widget.active!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? Sizes.compactButtonHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (String label in widget.children) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  activeValue = widget.children.indexOf(label);
                });
                widget.onChanged(widget.children.indexOf(label));
              },
              child: _chip(
                label: widget.children[widget.children.indexOf(label)],
                active: widget.children.indexOf(label) == activeValue,
                context: context,
                index: widget.children.indexOf(label),
              ),
            ),
            HSpace.md,
          ]
        ],
      ),
    );
  }

  Widget _chip({
    required bool active,
    required String label,
    required BuildContext context,
    required int index,
  }) {
    final bgColor = active
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.background.withOpacity(0.5);

    final fgColor = active
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onBackground.withOpacity(0.5);
    return DecoratedContainer(
      height: widget.height,
      // width: Sizes.xxl,
      borderRadius: Insets.sm,
      padding: EdgeInsets.all(Insets.sm),
      color: bgColor,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.icons.isNotEmpty)
              Icon(
                widget.icons[index],
                color: fgColor,
              ),
            Text(
              label,
              style: TextStyles.title2.copyWith(color: fgColor, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
