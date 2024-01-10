// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, library_private_types_in_public_api

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class BtnColors {
  BtnColors({required this.bg, required this.fg, this.outline});
  final Color bg;
  final Color fg;
  final Color? outline;
}

enum BtnTheme { primary, secondary, raw }

// A core btn that takes a child and wraps it in a btn that has a FocusNode.
// Colors are required. By default there is no padding.
// It takes care of adding a visual indicator  when the btn is Focused.
class RawBtn extends StatefulWidget {
  const RawBtn({
    Key? key,
    required this.child,
    required this.onPressed,
    this.normalColors,
    this.hoverColors,
    this.padding,
    this.focusMargin,
    this.enableShadow = false,
    this.enableFocus = true,
    this.ignoreDensity = false,
    this.cornerRadius,
    this.enabled,
    this.isCompact = false,
  }) : super(key: key);
  final Widget child;
  final VoidCallback? onPressed;
  final BtnColors? normalColors;
  final BtnColors? hoverColors;
  final EdgeInsets? padding;
  final double? focusMargin;
  final bool enableShadow;
  final bool enableFocus;
  final double? cornerRadius;
  final bool ignoreDensity;
  final bool? enabled;
  final bool isCompact;

  @override
  _RawBtnState createState() => _RawBtnState();
}

class _RawBtnState extends State<RawBtn> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(canRequestFocus: widget.enableFocus);
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant RawBtn oldWidget) {
    _focusNode.canRequestFocus = widget.enableFocus;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MaterialStateProperty<T> getMaterialState<T>({
      required T normal,
      required T hover,
    }) =>
        MaterialStateProperty.resolveWith<T>((Set states) {
          if (states.contains(MaterialState.hovered)) return hover;
          if (states.contains(MaterialState)) return hover;
          return normal;
        });

    final theme = Theme.of(context);
    final VisualDensity density = Theme.of(context).visualDensity;

    final List<BoxShadow> shadows =
        (widget.enableShadow) ? Shadows.universal : [];
    final BtnColors normalColors = widget.normalColors ??
        BtnColors(
          fg: theme.colorScheme.primary,
          bg: Colors.transparent,
        );
    final BtnColors hoverColors = widget.hoverColors ??
        BtnColors(
          fg: theme.colorScheme.onPrimaryContainer,
          bg: theme.colorScheme.primaryContainer,
        );

    final double focusMargin = widget.focusMargin ?? -5;

    return AnimatedOpacity(
      duration: Times.fast,
      opacity: widget.onPressed == null ? .7 : 1,
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          /// Core Btn
          DecoratedContainer(
            borderRadius: widget.cornerRadius ?? Corners.md,
            shadows: shadows,
            child: TextButton(
              key: widget.key,
              focusNode: _focusNode,
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                visualDensity: density,
                disabledMouseCursor: SystemMouseCursors.basic,
              ).copyWith(
                minimumSize: MaterialStateProperty.all(
                  widget.isCompact
                      ? ButtonStyles.compactMinimumSize
                      : ButtonStyles.minimumSize,
                ),
                padding: widget.ignoreDensity
                    ? MaterialStateProperty.all(EdgeInsets.zero)
                    : widget.isCompact
                        ? MaterialStateProperty.all(ButtonStyles.compactPadding)
                        : MaterialStateProperty.all(ButtonStyles.padding),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      widget.cornerRadius ?? Corners.btn,
                    ),
                  ),
                ),
                side: getMaterialState(
                  normal: BorderSide(
                    color: normalColors.outline ?? Colors.transparent,
                  ),
                  hover: BorderSide(
                    color: hoverColors.outline ?? Colors.transparent,
                  ),
                ),
                overlayColor: MaterialStateProperty.all(
                  normalColors.fg.withOpacity(0.2),
                ),
                foregroundColor: getMaterialState(
                  normal: normalColors.fg,
                  hover: hoverColors.fg,
                ),
                backgroundColor: getMaterialState(
                  normal: normalColors.bg,
                  hover: hoverColors.bg,
                ),
              ),
              child: widget.child,
            ),
          ),

          /// Focus Decoration
          if (_focusNode.hasFocus) ...[
            PositionedAll(
              // Use negative margin for the focus state, so it lands outside our buttons actual footprint and doesn't mess up our alignments/paddings.
              all: focusMargin,
              child: RoundedBorder(
                radius:
                    widget.cornerRadius ?? (Corners.md - (focusMargin * .6)),
                color: theme.focusColor,
              ),
            )
          ],
        ],
      ),
    );
  }
}

// BtnContent that takes care of all the compact sizing and spacing
// Accepts label, icon and child, with child taking precedence.
class BtnContent extends StatelessWidget {
  const BtnContent({
    Key? key,
    this.label,
    this.icon,
    this.child,
    this.leadingIcon = false,
    this.isCompact = false,
    this.labelStyle,
    this.iconColor,
  }) : super(key: key);
  final bool leadingIcon;
  final bool isCompact;
  final Widget? child;
  final String? label;
  final IconData? icon;
  final TextStyle? labelStyle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final bool hasIcon = icon != null;
    final bool hasLbl = StringUtils.isNotEmpty(label);

    final _labelStyle = labelStyle ??
        (isCompact ? TextStyles.buttonCompact : TextStyles.button);

    return child ??
        Row(
          mainAxisSize: isCompact ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: leadingIcon ? TextDirection.rtl : TextDirection.ltr,
          children: [
            if (hasLbl) ...[
              Text((label ?? '').toUpperCase(), style: _labelStyle),
            ],

            /// Spacer - Show if both pieces of content are visible
            if (hasIcon && hasLbl) ...[
              HSpace.sm,
            ],

            /// Icon?
            if (hasIcon) ...[
              Icon(
                icon,
                size: isCompact ? 20 : 24,
                color: iconColor ?? Theme.of(context).colorScheme.onPrimary,
              ),
            ]
          ],
        );
  }
}
