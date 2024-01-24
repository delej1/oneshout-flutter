// ignore_for_file: lines_longer_than_80_chars

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

export 'raw_styled_btn.dart';

/// Accent colored btn (orange), wraps RawBtn
class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn({
    Key? key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.leadingIcon = true,
    this.isCompact = false,
    this.cornerRadius,
  }) : super(key: key);
  final Widget? child;
  final String? label;
  final IconData? icon;
  final bool leadingIcon;
  final bool isCompact;
  final double? cornerRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;

    return RawBtn(
      cornerRadius: cornerRadius,
      normalColors: BtnColors(
        bg: disabled
            ? theme.colorScheme.surfaceVariant
            : theme.colorScheme.primary,
        fg: disabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onPrimary,
      ),
      hoverColors: BtnColors(
        bg: theme.colorScheme.primary.withOpacity(0.8),
        fg: theme.colorScheme.onPrimary,
      ),
      onPressed: onPressed,
      isCompact: isCompact,
      child: BtnContent(
        label: label,
        icon: icon,
        leadingIcon: leadingIcon,
        isCompact: isCompact,
        child: child,
      ),
    );
  }
}

/// Surface colors btn (white), wraps RawBtn
class SecondaryBtn extends StatelessWidget {
  const SecondaryBtn({
    Key? key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.leadingIcon = true,
    this.isCompact = false,
    this.cornerRadius,
  }) : super(key: key);
  final Widget? child;
  final String? label;
  final IconData? icon;
  final bool leadingIcon;
  final bool isCompact;
  final double? cornerRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;

    final Widget content = BtnContent(
      label: label,
      icon: icon,
      leadingIcon: leadingIcon,
      isCompact: isCompact,
      child: child,
    );
    if (isCompact) {
      return RawBtn(
        cornerRadius: cornerRadius,
        normalColors: BtnColors(
          bg: disabled
              ? theme.colorScheme.secondary.withOpacity(0.1)
              : theme.colorScheme.secondary,
          fg: disabled
              ? theme.colorScheme.onSecondary.withOpacity(0.1)
              : theme.colorScheme.onSecondary,
          outline: theme.colorScheme.secondary,
        ),
        hoverColors: BtnColors(
          bg: theme.colorScheme.secondary.withOpacity(.15),
          fg: theme.colorScheme.onSecondary,
          outline: theme.colorScheme.secondary,
        ),
        isCompact: isCompact,
        onPressed: onPressed,
        child: content,
      );
    }
    return RawBtn(
      normalColors: BtnColors(
        bg: disabled
            ? theme.colorScheme.secondary.withOpacity(0.1)
            : theme.colorScheme.secondary,
        fg: disabled
            ? theme.colorScheme.onSecondary.withOpacity(0.1)
            : theme.colorScheme.onSecondary,
        outline: theme.colorScheme.secondary,
      ),
      hoverColors: BtnColors(
        bg: theme.colorScheme.secondary.withOpacity(0.8),
        fg: theme.colorScheme.onSecondary,
        outline: theme.colorScheme.secondary,
      ),
      isCompact: isCompact,
      onPressed: onPressed,
      child: content,
    );
  }
}

/// Accent colored btn (orange), wraps RawBtn
class OutlinedBtn extends StatelessWidget {
  const OutlinedBtn({
    Key? key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.leadingIcon = true,
    this.isCompact = false,
    this.cornerRadius,
  }) : super(key: key);
  final Widget? child;
  final String? label;
  final IconData? icon;
  final bool leadingIcon;
  final bool isCompact;
  final double? cornerRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // final disabled = onPressed == null;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: isCompact
            ? ButtonStyles.compactMinimumSize
            : ButtonStyles.minimumSize,
        padding: isCompact ? ButtonStyles.compactPadding : ButtonStyles.padding,
      ),
      child: BtnContent(
        label: label,
        icon: icon,
        iconColor: Theme.of(context).colorScheme.primary,
        leadingIcon: leadingIcon,
        isCompact: isCompact,
        child: child,
      ),
    );
  }
}

/// Takes any child, applies no padding, and falls back to default colors
class SimpleBtn extends StatelessWidget {
  const SimpleBtn({
    Key? key,
    required this.onPressed,
    required this.child,
    this.focusMargin,
    this.normalColors,
    this.hoverColors,
    this.cornerRadius,
    this.ignoreDensity,
    this.isCompact = false,
    this.icon,
  }) : super(key: key);
  final Widget child;
  final VoidCallback? onPressed;
  final double? focusMargin;
  final BtnColors? normalColors;
  final BtnColors? hoverColors;
  final double? cornerRadius;
  final bool? ignoreDensity;
  final bool isCompact;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RawBtn(
      cornerRadius: cornerRadius,
      normalColors: normalColors,
      hoverColors: hoverColors ??
          BtnColors(
            bg: theme.colorScheme.primary.withOpacity(0.1),
            fg: theme.colorScheme.primary,
          ),
      focusMargin: focusMargin ?? 0,
      isCompact: isCompact,
      onPressed: onPressed,
      ignoreDensity: ignoreDensity ?? true,
      child: BtnContent(
        icon: icon,
        child: child,
      ),
    );
  }
}

/// Text Btn - wraps a [SimpleBtn]
class TextBtn extends StatelessWidget {
  const TextBtn(
    this.label, {
    Key? key,
    required this.onPressed,
    this.isCompact = false,
    this.style,
    this.showUnderline = false,
    this.icon,
    this.leadingIcon = true,
  }) : super(key: key);
  final String label;
  final VoidCallback? onPressed;
  final bool isCompact;
  final bool leadingIcon;
  final TextStyle? style;
  final bool showUnderline;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final finalStyle = style ??
        TextStyle(
          decoration:
              showUnderline ? TextDecoration.underline : TextDecoration.none,
        );
    final hasIcon = icon != null;

    return SimpleBtn(
      ignoreDensity: false,
      onPressed: onPressed,
      child: Row(
        textDirection: leadingIcon ? TextDirection.ltr : TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasIcon)
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: isCompact ? 14 : 16,
            ),
          if (hasIcon) ...[
            HSpace.sm,
          ],
          Text(
            label,
            style: finalStyle,
          ),
        ],
      ),
    );
  }
}

/// Icon Btn - wraps a [SimpleBtn]
class IconBtn extends StatelessWidget {
  const IconBtn(
    this.icon, {
    Key? key,
    required this.onPressed,
    this.color,
    this.padding = EdgeInsets.zero,
    this.ignoreDensity,
    this.isCompact = false,
  }) : super(key: key);
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final EdgeInsets? padding;
  final bool? ignoreDensity;
  final bool isCompact;
  @override
  Widget build(BuildContext context) {
    const enableTouchMode = false;
    // ignore: dead_code
    const extraPadding = enableTouchMode ? 3 : 0;
    final _color = color ?? Theme.of(context).colorScheme.primary;
    return SimpleBtn(
      isCompact: isCompact,
      ignoreDensity: ignoreDensity,
      onPressed: onPressed,
      child: AnimatedPadding(
        duration: Times.fast,
        curve: Curves.easeOut,
        padding: padding ?? EdgeInsets.all(Insets.xs + extraPadding),
        child: Icon(icon, color: _color, size: 20),
      ),
    );
  }
}

/// Text Btn - wraps a [SimpleBtn]
class TextLink extends StatelessWidget {
  const TextLink(
    this.label, {
    Key? key,
    required this.onPressed,
    this.style,
    this.showUnderline = false,
    this.icon,
    this.leadingIcon = true,
    this.highlight = false,
    this.color,
  }) : super(key: key);
  final String label;
  final VoidCallback? onPressed;
  final bool leadingIcon;
  final TextStyle? style;
  final bool showUnderline;
  final IconData? icon;
  final bool highlight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final finalStyle = style ??
        TextStyle(
          fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          color: color ?? Theme.of(context).colorScheme.primary,
          decoration:
              showUnderline ? TextDecoration.underline : TextDecoration.none,
        );
    final hasIcon = icon != null;

    return GestureDetector(
      onTap: onPressed,
      child: Row(
        textDirection: leadingIcon ? TextDirection.ltr : TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasIcon)
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 16),
          if (hasIcon) ...[
            HSpace.sm,
          ],
          Text(
            label,
            style: finalStyle,
          ),
        ],
      ),
    );
  }
}

/// Google Signin Button
class GoogleBtn extends StatelessWidget {
  const GoogleBtn({
    Key? key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.leadingIcon = true,
    this.isCompact = false,
    this.cornerRadius,
  }) : super(key: key);
  final Widget? child;
  final String? label;
  final IconData? icon;
  final bool leadingIcon;
  final bool isCompact;
  final double? cornerRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;

    return RawBtn(
      cornerRadius: cornerRadius,
      normalColors: BtnColors(
        bg: disabled
            ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
            : theme.colorScheme.surfaceVariant,
        fg: disabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onSurface,
      ),
      hoverColors: BtnColors(
        bg: theme.colorScheme.primary.withOpacity(0.8),
        fg: theme.colorScheme.onPrimary,
      ),
      onPressed: onPressed,
      child: BtnContent(
        label: label,
        icon: icon,
        leadingIcon: leadingIcon,
        isCompact: isCompact,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'assets/images/google_logo.png',
                package: 'app_core',
              ),
              height: 24,
              width: 24,
            ),
            // Image.asset(
            //   'assets/images/google_logo.png',
            //   height: 24,
            //   width: 24,
            // ),
            HSpace.md,
            const Text('Login with Google'),
          ],
        ),
      ),
    );
  }
}

/// Phone Signin Button
class PhoneNumberBtn extends StatelessWidget {
  const PhoneNumberBtn({
    Key? key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.leadingIcon = true,
    this.isCompact = false,
    this.cornerRadius,
  }) : super(key: key);
  final Widget? child;
  final String? label;
  final IconData? icon;
  final bool leadingIcon;
  final bool isCompact;
  final double? cornerRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;

    return RawBtn(
      cornerRadius: cornerRadius,
      normalColors: BtnColors(
        bg: disabled
            ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
            : theme.colorScheme.surfaceVariant,
        fg: disabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onSurface,
      ),
      hoverColors: BtnColors(
        bg: theme.colorScheme.primary.withOpacity(0.8),
        fg: theme.colorScheme.onPrimary,
      ),
      onPressed: onPressed,
      child: BtnContent(
        label: label,
        icon: icon,
        leadingIcon: leadingIcon,
        isCompact: isCompact,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone, size: 24),
            HSpace.md,
            const Text('Login with Phone Number'),
          ],
        ),
      ),
    );
  }
}

/// Apple Signin Button
class AppleLoginBtn extends StatelessWidget {
  const AppleLoginBtn({
    Key? key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.leadingIcon = true,
    this.isCompact = false,
    this.cornerRadius,
  }) : super(key: key);
  final Widget? child;
  final String? label;
  final IconData? icon;
  final bool leadingIcon;
  final bool isCompact;
  final double? cornerRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;

    return RawBtn(
      cornerRadius: cornerRadius,
      normalColors: BtnColors(
        bg: disabled
            ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
            : theme.colorScheme.surfaceVariant,
        fg: disabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onSurface,
      ),
      hoverColors: BtnColors(
        bg: theme.colorScheme.primary.withOpacity(0.8),
        fg: theme.colorScheme.onPrimary,
      ),
      onPressed: onPressed,
      child: BtnContent(
        label: label,
        icon: icon,
        leadingIcon: leadingIcon,
        isCompact: isCompact,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'assets/images/apple_logo.png',
                package: 'app_core',
              ),
              height: 24,
              width: 24,
            ),
            HSpace.md,
            const Text('Login with Apple'),
          ],
        ),
      ),
    );
  }
}

class FacebookLoginBtn extends StatelessWidget {
  const FacebookLoginBtn({
    Key? key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.leadingIcon = true,
    this.isCompact = false,
    this.cornerRadius,
  }) : super(key: key);
  final Widget? child;
  final String? label;
  final IconData? icon;
  final bool leadingIcon;
  final bool isCompact;
  final double? cornerRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;

    return RawBtn(
      cornerRadius: cornerRadius,
      normalColors: BtnColors(
        bg: disabled
            ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
            : theme.colorScheme.surfaceVariant,
        fg: disabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onSurface,
      ),
      hoverColors: BtnColors(
        bg: theme.colorScheme.primary.withOpacity(0.8),
        fg: theme.colorScheme.onPrimary,
      ),
      onPressed: onPressed,
      child: BtnContent(
        label: label,
        icon: icon,
        leadingIcon: leadingIcon,
        isCompact: isCompact,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'assets/images/facebook_logo.png',
                package: 'app_core',
              ),
              height: 24,
              width: 24,
            ),
            HSpace.md,
            const Text('Login with Facebook'),
          ],
        ),
      ),
    );
  }
}

class TwitterLoginBtn extends StatelessWidget {
  const TwitterLoginBtn({
    Key? key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.leadingIcon = true,
    this.isCompact = false,
    this.cornerRadius,
  }) : super(key: key);
  final Widget? child;
  final String? label;
  final IconData? icon;
  final bool leadingIcon;
  final bool isCompact;
  final double? cornerRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;

    return RawBtn(
      cornerRadius: cornerRadius,
      normalColors: BtnColors(
        bg: disabled
            ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
            : theme.colorScheme.surfaceVariant,
        fg: disabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onSurface,
      ),
      hoverColors: BtnColors(
        bg: theme.colorScheme.primary.withOpacity(0.8),
        fg: theme.colorScheme.onPrimary,
      ),
      onPressed: onPressed,
      child: BtnContent(
        label: label,
        icon: icon,
        leadingIcon: leadingIcon,
        isCompact: isCompact,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'assets/images/twitter_logo.png',
                package: 'app_core',
              ),
              height: 24,
              width: 24,
            ),
            HSpace.md,
            const Text('Login with Twitter'),
          ],
        ),
      ),
    );
  }
}

/// Stock Button
class StockBtn extends StatelessWidget {
  const StockBtn({
    Key? key,
    this.onPressed,
    this.label,
    this.child,
    this.leadingIcon = true,
    this.isCompact = false,
    this.cornerRadius,
    required this.type,
  }) : super(key: key);
  final Widget? child;
  final String? label;
  final bool leadingIcon;
  final bool isCompact;
  final double? cornerRadius;
  final Function()? onPressed;
  final TransactionDirection type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabled = onPressed == null;
    final btnlabel = label ??
        (type == TransactionDirection.inward ? 'Stock In' : 'Stock Out');
    return RawBtn(
      cornerRadius: cornerRadius ?? Corners.btn,
      normalColors: BtnColors(
        bg: disabled
            ? theme.colorScheme.surfaceVariant
            : theme.colorScheme.primary,
        fg: disabled
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.onPrimary,
      ),
      hoverColors: BtnColors(
        bg: theme.colorScheme.primary.withOpacity(0.8),
        fg: theme.colorScheme.onPrimary,
      ),
      onPressed: onPressed,
      isCompact: isCompact,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          HSpace.md,
          Expanded(
            child: Text(
              btnlabel.toUpperCase(),
              textAlign: TextAlign.center,
            ),
          ),
          HSpace.md,
          ClipOval(
            child: Container(
              padding: EdgeInsets.all(Insets.md),
              color: Colors.white,
              child: TransactionArrow(
                direction: type,
              ),
            ),
          )
        ],
      ),
    );
  }
}
