// ignore_for_file: lines_longer_than_80_chars, comment_references

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

/// //////////////////////////////////////////////////////////////
/// Styles - Contains the design system for the entire app.
/// Includes paddings, text styles, timings etc. Does not include colors, check [AppTheme] file for that.

/// Used for all animations in the  app
class Times {
  static const Duration fastest = Duration(milliseconds: 150);
  static const fast = Duration(milliseconds: 250);
  static const medium = Duration(milliseconds: 350);
  static const slow = Duration(milliseconds: 700);
  static const slower = Duration(milliseconds: 1000);
}

class Sizes {
  static double hitScale = 1;
  static double get xxs => 2 * hitScale;
  static double get xs => 4 * hitScale;
  static double get sm => 8 * hitScale;
  static double get md => 12 * hitScale;
  static double get lg => 16 * hitScale;
  static double get xl => 24 * hitScale;
  static double get xxl => 32 * hitScale;
  static double get hit => 40 * hitScale;
  static double get buttonHeight => 50;
  static double get compactButtonHeight => 40;
}

class IconSizes {
  static const double scale = 1;
  static const double med = 24;
}

class Insets {
  static double scale = 1;
  static double offsetScale = 1;
  // Regular paddings
  static double get xxs => 2 * scale;
  static double get xs => 4 * scale;
  static double get sm => 8 * scale;
  static double get md => 12 * scale;
  static double get lg => 16 * scale;
  static double get xl => 24 * scale;
  static double get xxl => 32 * scale;
  static double get xxxl => 64 * scale;
  // Offset, used for the edge of the window, or to separate large sections in the app
  static double get offset => 16 * offsetScale;
}

class Corners {
  static const double btn = 8;
  static const BorderRadius btnBorder = BorderRadius.all(btnRadius);
  static const Radius btnRadius = Radius.circular(btn);

  static const double sm = 4;
  static const BorderRadius smBorder = BorderRadius.all(smRadius);
  static const Radius smRadius = Radius.circular(sm);

  static const double md = 8;
  static const BorderRadius mdBorder = BorderRadius.all(mdRadius);
  static const Radius mdRadius = Radius.circular(md);

  static const double lg = 16;
  static const BorderRadius lgBorder = BorderRadius.all(lgRadius);
  static const Radius lgRadius = Radius.circular(lg);

  static const double xl = 50;
  static const BorderRadius xlBorder = BorderRadius.all(xlRadius);
  static const Radius xlRadius = Radius.circular(xl);

  static const double full = 100;
  static const BorderRadius fullBorder = BorderRadius.all(xlRadius);
  static const Radius fullRadius = Radius.circular(xl);
}

class Strokes {
  static const double thin = 1;
  static const double thick = 4;
}

class Shadows {
  static List<BoxShadow> get universal => [
        BoxShadow(
          color: const Color(0xff333333).withOpacity(.15),
          blurRadius: 10,
        ),
      ];
  static List<BoxShadow> get small => [
        BoxShadow(
          color: const Color(0xff333333).withOpacity(.15),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ];
}

/// Font Sizes
/// You can use these directly if you need, but usually there should be a predefined style in TextStyles.
class FontSizes {
  /// Provides the ability to nudge the app-wide font scale in either direction
  static double get scale => 1;
  static double get s10 => 10 * scale;
  static double get s11 => 11 * scale;
  static double get s12 => 12 * scale;
  static double get s14 => 14 * scale;
  static double get s16 => 16 * scale;
  static double get s18 => 18 * scale;
  static double get s24 => 24 * scale;
  static double get s32 => 32 * scale;
  static double get s48 => 48 * scale;
}

/// Fonts - A list of Font Families, this is uses by the TextStyles class to create concrete styles.
class Fonts {
  // static const String raleway = "Raleway";
}

class ButtonStyles {
  static ButtonStyle elevated = ElevatedButton.styleFrom(
    textStyle: TextStyles.button,
    minimumSize: Size(0, Sizes.buttonHeight),
    padding: EdgeInsets.symmetric(
      horizontal: Insets.lg,
      vertical: Insets.md,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Corners.btn),
    ),
  );
  static RoundedRectangleBorder get shape => const RoundedRectangleBorder(
        borderRadius: Corners.btnBorder,
      );
  static RoundedRectangleBorder get outlinedShape =>
      const RoundedRectangleBorder(
        borderRadius: Corners.btnBorder,
      );
  static Size get minimumSize => Size(0, Sizes.buttonHeight);
  static Size get compactMinimumSize => Size(0, Sizes.compactButtonHeight);

  static EdgeInsets get padding => EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.sm,
      );
  static EdgeInsets get compactPadding => EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.xs,
      );
}

class InputDecorationThemes {
  static InputDecorationTheme get underlined => InputDecorationTheme(
        hintStyle: TextStyles.inputField,
        labelStyle: TextStyles.inputField,
        floatingLabelStyle: TextStyles.inputField,
        contentPadding: EdgeInsets.zero,
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red),
        // ),
      );
  static InputDecorationTheme get outlined => InputDecorationTheme(
        hintStyle: TextStyles.inputField,
        labelStyle: TextStyles.inputField,
        floatingLabelStyle: TextStyles.inputField,
        alignLabelWithHint: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(Corners.md)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.md,
        ),
      );
}

/// TextStyles - All the core text styles for the app should be declared here.
/// Don't try and create every variant in existence here, just the high level ones.
/// More specific variants can be created on the fly using `style.copyWith()`
/// `newStyle = TextStyles.body1.copyWith(lineHeight: 2, color: Colors.red)`
class TextStyles {
  /// Declare a base style for each Family
  static TextStyle textStyle =
      GoogleFonts.montserrat().copyWith(fontWeight: FontWeight.w400);
  static TextStyle poppinsTextStyle =
      GoogleFonts.montserrat().copyWith(fontWeight: FontWeight.w400);
  static TextStyle moneyStyle = GoogleFonts.robotoCondensed().copyWith(
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
  );

  //AppBar
  static TextStyle get appBar => poppinsTextStyle.copyWith(
        // fontFamily: 'PoppinsM',
        letterSpacing: 0.2,
        fontSize: 20,
      );

  //Headers
  static TextStyle get h1 => textStyle.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: FontSizes.s48,
        letterSpacing: -1,
        height: 1.17,
      );
  static TextStyle get h2 => h1.copyWith(
        fontSize: FontSizes.s32,
        letterSpacing: -.5,
        height: 1.16,
      );
  static TextStyle get h3 => h1.copyWith(
        fontSize: FontSizes.s24,
        letterSpacing: -.05,
        height: 1.29,
      );
  static TextStyle get h4 => h1.copyWith(
        fontSize: FontSizes.s18,
        // letterSpacing: -.05,
        // height: 1.29,
      );
  static TextStyle get h5 => textStyle.copyWith(
        fontSize: FontSizes.s24,
        fontWeight: FontWeight.w500,
        height: 1,
      );
  static TextStyle get h6 => poppinsTextStyle.copyWith(
        fontSize: FontSizes.s14,
      );

  //Subtitles
  static TextStyle get title1 => textStyle.copyWith(
        fontWeight: FontWeight.normal,
        fontSize: FontSizes.s14,
        height: 1.31,
      );
  static TextStyle get title2 => title1.copyWith(
        fontWeight: FontWeight.normal,
        fontSize: FontSizes.s12,
        height: 1.36,
      );

  //Body
  static TextStyle get body1 => textStyle.copyWith(
        fontWeight: FontWeight.normal,
        fontSize: FontSizes.s16,
        height: 1.5,
        letterSpacing: 0.15,
      );
  static TextStyle get body2 => body1.copyWith(
        fontSize: FontSizes.s14,
        height: 1.5,
        letterSpacing: .25,
      );
  static TextStyle get body3 => body1.copyWith(
        fontSize: FontSizes.s12,
        height: 1.5,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.4,
      );
  static TextStyle get subtitle1 => poppinsTextStyle.copyWith(
        fontSize: FontSizes.s16,
      );
  //callout
  static TextStyle get callout1 => textStyle.copyWith(
        fontWeight: FontWeight.w800,
        fontSize: FontSizes.s12,
        height: 1.17,
        letterSpacing: .5,
      );
  static TextStyle get callout2 =>
      callout1.copyWith(fontSize: FontSizes.s10, height: 1, letterSpacing: .25);

  static TextStyle get caption => textStyle.copyWith(
        // fontWeight: FontWeight.w500,
        fontSize: FontSizes.s10,
        height: 1.36,
      );
  static TextStyle get overline => textStyle.copyWith(
        // fontWeight: FontWeight.w500,
        fontSize: FontSizes.s10,
        height: 1.5,
      );
  static TextStyle get sectionHeader => textStyle.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: FontSizes.s14,
        height: 1.5,
      );

  //button text style
  static TextStyle get button => textStyle.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: FontSizes.s14,
      );

  static TextStyle get buttonCompact => textStyle.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: FontSizes.s14,
        letterSpacing: .5,
      );

  //input fields
  static TextStyle get inputField => poppinsTextStyle.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: FontSizes.s14,
        // height: 1.3,
      );
  //input fields
  static TextStyle get inputLabel => poppinsTextStyle.copyWith(
        // fontWeight: FontWeight.w600,
        fontSize: FontSizes.s12,
        // height: 1.3,
      );
  //toasts and notifications
  static TextStyle get notificationText =>
      textStyle.copyWith(fontWeight: FontWeight.w400, fontSize: FontSizes.s14);
  static TextStyle get notificationTitle =>
      textStyle.copyWith(fontWeight: FontWeight.w600, fontSize: FontSizes.s16);

  //errors
  static TextStyle get errorTitleStyle => textStyle.copyWith(
        fontSize: 30,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get errorBodyStyle => textStyle.copyWith(
        fontSize: 14,
        color: Colors.grey,
      );
}

final BuildContext ctx = AppCore.scaffoldMessengerKey.currentState!.context;

extension ExtensionTextStyle on Text {
  Text h1() => Text(data ?? '', textAlign: textAlign, style: TextStyles.h1);
  Text h2({TextStyle? style}) => Text(
        data ?? '',
        textAlign: textAlign,
        style: TextStyles.h2.merge(style),
      );
  Text h3({TextStyle? style}) =>
      Text(data ?? '', style: TextStyles.h3.merge(style));
  Text h4({TextStyle? style}) => Text(
        data ?? '',
        style: TextStyles.h4.merge(style),
      );
  Text h5({TextStyle? style}) => Text(
        data ?? '',
        textAlign: textAlign,
        maxLines: maxLines,
        softWrap: softWrap,
        style: Theme.of(ctx).textTheme.headline5,
      );
  Text h6() => Text(data ?? '', style: TextStyles.h6);
  Text caption({TextStyle? style}) => Text(
        data ?? '',
        textAlign: textAlign,
        maxLines: maxLines,
        softWrap: softWrap,
        style: Theme.of(ctx)
            .textTheme
            .caption!
            .merge(style)
            .copyWith(fontSize: 10, color: Colors.black54),
      );

  Text subtitle({TextStyle? style, BuildContext? cx}) => Text(
        data ?? '',
        textAlign: textAlign,
        maxLines: maxLines,
        softWrap: softWrap,
        style: TextStyles.title1.merge(style),
      );
  Text section({TextStyle? style}) =>
      Text(data ?? '', style: TextStyles.sectionHeader.merge(style));
  Text overline({TextStyle? style}) => Text(
        data ?? '',
        textAlign: textAlign,
        style: style ?? Theme.of(ctx).textTheme.overline,
      );
}

class GroupButtonStyle {
  static GroupButtonOptions outlined(BuildContext ctx) => GroupButtonOptions(
        elevation: 0,
        selectedShadow: [],
        unselectedShadow: [],
        selectedColor: Colors.transparent,
        unselectedColor: Colors.transparent,
        selectedBorderColor: Theme.of(ctx).colorScheme.primary,
        selectedTextStyle: TextStyle(
          color: Theme.of(ctx).colorScheme.primary,
        ),
        unselectedTextStyle: TextStyle(
          color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.5),
        ),
        borderRadius: Corners.btnBorder,
        buttonHeight: Sizes.compactButtonHeight,
        mainGroupAlignment: MainGroupAlignment.start,
        alignment: Alignment.center,
        textPadding: ButtonStyles.padding,
      );

  static GroupButtonOptions filled(BuildContext ctx) => GroupButtonOptions(
        // groupingType: GroupingType.row,
        elevation: 0,
        selectedShadow: [],
        unselectedShadow: [],
        selectedColor: Theme.of(ctx).colorScheme.primary,
        unselectedColor: Theme.of(ctx).colorScheme.background,
        selectedBorderColor: Theme.of(ctx).colorScheme.primary,
        selectedTextStyle: TextStyle(
          color: Theme.of(ctx).colorScheme.onPrimary,
          fontSize: 12,
        ),
        unselectedTextStyle: TextStyle(
          color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.5),
          fontSize: 12,
        ),
        borderRadius: Corners.btnBorder,
        buttonHeight: Sizes.compactButtonHeight,
        // buttonWidth: (DeviceScreen.width(ctx) - Insets.lg * 5) / 4,
        mainGroupAlignment: MainGroupAlignment.start,
        alignment: Alignment.center,
        textPadding: ButtonStyles.padding,
      );
}
