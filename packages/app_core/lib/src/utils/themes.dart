// ignore_for_file: lines_longer_than_80_chars

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

Map<int, Color> baseColorSwatch = {
  50: Colors.deepPurple.shade50,
  100: Colors.deepPurple.shade100,
  200: Colors.deepPurple.shade200,
  300: Colors.deepPurple.shade300,
  400: Colors.deepPurple.shade400,
  500: Colors.deepPurple.shade500,
  600: Colors.deepPurple.shade600,
  700: Colors.deepPurple.shade700,
  800: Colors.deepPurple.shade800,
  900: Colors.deepPurple.shade900,
};

const buttonTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Colors.white,
  fontFamily: 'PoppinsRegular',
);

// @injectable
abstract class ThemeServiceImpl {
  AdaptiveThemeMode? theme;
  @preResolve
  Future<AdaptiveThemeMode?> adaptiveThemeMode = AdaptiveTheme.getThemeMode();

  final light = _lightThemeData;
  final dark = _darkThemeData;

  // @factoryMethod
  // static Future<ThemeServiceImpl> init() async {
  //   await ThemeServiceImpl().resetTheme();
  //   return ThemeServiceImpl();
  // }

  Future<void> changeTheme(BuildContext context) async {
    AdaptiveTheme.of(context).toggleThemeMode();
    // theme = await AdaptiveTheme.getThemeMode();

    // SystemChrome.setSystemUIOverlayStyle(
    //   theme == AdaptiveThemeMode.light
    //       ? const SystemUiOverlayStyle(
    //           statusBarColor: Colors.transparent,
    //           statusBarBrightness: Brightness.dark,
    //           statusBarIconBrightness: Brightness.dark,
    //         )
    //       : const SystemUiOverlayStyle(
    //           statusBarColor: Colors.transparent,
    //           statusBarBrightness: Brightness.light,
    //           statusBarIconBrightness: Brightness.light,
    //         ),
    // );
  }

  Future<void> resetTheme() async {
    theme = await AdaptiveTheme.getThemeMode();
  }
}

class ThemeEvent {
  ThemeEvent({required this.appTheme});
  final ThemeData appTheme;
}

class ThemeState {
  ThemeState({required this.themeData});
  final ThemeData themeData;
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: AppTheme.light)) {
    on<ThemeEvent>((event, emit) {});
  }

  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    yield ThemeState(themeData: event.appTheme);
  }
}

class AppTheme {
  static final light = _lightThemeData;
  static final dark = _darkThemeData;
}

class AppColors {
  // final theme = getItCore<ThemeService>().theme!.isDark
  // ? _darkThemeData
  //   : _lightThemeData;
  // final scheme =
  // theme!.isDark ? _darkThemeData : _lightThemeData;

  // Color get primary => theme.colorScheme.onSurface.withOpacity(0.5);
  // static Color onPrimary = Get.theme.colorScheme.onPrimary;
  // static Color primaryLight = Get.theme.primaryColorLight;
}

/// Base ThemeData
///
/// The Dark and Light themes extend the properties of this theme.
ThemeData _baseThemeData = ThemeData(
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyles.appBar,
    // toolbarHeight: 80,
  ),
  textTheme: TextTheme(
    headline1: TextStyles.h1,
    headline2: TextStyles.h2,
    headline3: TextStyles.h3,
    headline4: TextStyles.h6,
    headline5: TextStyles.h5,
    headline6: TextStyles.h6,
    button: TextStyles.button,
    subtitle1: TextStyles.subtitle1,
    subtitle2: TextStyles.title2, //home screen
    bodyText1: TextStyles.body1,
    bodyText2: TextStyles.body2, // home's card title,
    overline: TextStyles.overline,
    caption: TextStyles.caption, // Home screen
  ),
  cardTheme: CardTheme(
    color: _lightColorScheme.surface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  inputDecorationTheme: InputDecorationThemes.outlined,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: TextStyles.button,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: TextStyles.button,
      minimumSize: ButtonStyles.minimumSize,
      padding: ButtonStyles.padding,
      shape: ButtonStyles.shape,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: TextStyles.button,
      minimumSize: ButtonStyles.minimumSize,
      padding: ButtonStyles.padding,
      shape: ButtonStyles.outlinedShape,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.zero,
  ),
  dividerTheme: const DividerThemeData(
    thickness: 1,
    space: 1,
  ),
);

final _baseTextTheme = _baseThemeData.textTheme;
final _baseInputDecoration = _baseThemeData.inputDecorationTheme;
final _baseAppBarTheme = _baseThemeData.appBarTheme;
final _baseCardTheme = _baseThemeData.cardTheme;
final _listTileTheme = _baseThemeData.listTileTheme;
final _dividerTheme = _baseThemeData.dividerTheme;
final _elevatedButtonTheme = _baseThemeData.elevatedButtonTheme;

ColorScheme _lightColorScheme = ColorScheme(
  primary: Colors.indigo,
  onPrimary: Colors.indigo.shade50,
  //
  secondary: Colors.purple.shade600,
  onSecondary: Colors.purple.shade50,
  //
  surface: Colors.white, // Colors.indigo.shade50,
  onSurface: Colors.grey.shade800,
  surfaceVariant: Colors.black.withOpacity(0.05),
  onSurfaceVariant: Colors.grey.shade500,
  onInverseSurface: Colors.grey.shade500,
  //
  background: Colors.indigo.shade50,
  onBackground: Colors.grey.shade800,
  //
  error: Colors.redAccent.shade400,
  onError: Colors.red.shade100,
  brightness: Brightness.light,
  shadow: Colors.blueGrey.withOpacity(0.3),
);

/// Light ThemeData ===========================================================
ThemeData _lightThemeData = _baseThemeData.copyWith(
  colorScheme: _lightColorScheme,
  primaryColorLight: Colors.indigo.shade50,
  scaffoldBackgroundColor: _lightColorScheme.primary,
  canvasColor: Colors.white, // _lightColorScheme.background,
  appBarTheme: _baseAppBarTheme.copyWith(
    iconTheme: IconThemeData(color: _lightColorScheme.background),
    color: Colors.transparent, // baseColorSwatch[500],
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // systemNavigationBarColor: Colors.transparent,
      statusBarBrightness:
          DeviceOS.isAndroid ? Brightness.light : Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: _baseAppBarTheme.titleTextStyle!.copyWith(
      color: _lightColorScheme.background,
    ),
  ),
  textTheme: _baseTextTheme.copyWith(
    bodyText1: _baseTextTheme.bodyText1!.copyWith(color: Colors.black87),
    bodyText2: _baseTextTheme.bodyText2!.copyWith(color: Colors.black87),
    subtitle1: _baseTextTheme.subtitle1!.copyWith(color: Colors.black87),
    subtitle2: _baseTextTheme.subtitle2!.apply(color: Colors.black45),
    caption: _baseTextTheme.caption!.copyWith(color: Colors.grey.shade600),
    headline2: _baseTextTheme.headline2!.apply(color: Colors.grey.shade800),
    headline5: _baseTextTheme.headline5!.apply(color: Colors.grey.shade800),
    overline: _baseTextTheme.overline!.apply(color: Colors.grey.shade500),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: _elevatedButtonTheme.style!.merge(
      ElevatedButton.styleFrom(
        foregroundColor: _lightColorScheme.onPrimary,
        backgroundColor: _lightColorScheme.primary,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: _elevatedButtonTheme.style!.merge(
      OutlinedButton.styleFrom(
        foregroundColor: _lightColorScheme.primary,
        side: BorderSide(color: _lightColorScheme.primary),
      ),
    ),
  ),
  cardTheme: _baseCardTheme.copyWith(
    color: _lightColorScheme.surface,
    shadowColor: _lightColorScheme.shadow,
  ),
  inputDecorationTheme: _baseInputDecoration.copyWith(
    hintStyle: _baseInputDecoration.hintStyle!.copyWith(color: Colors.black26),
    labelStyle:
        _baseInputDecoration.labelStyle!.copyWith(color: Colors.black38),
    floatingLabelStyle: _baseInputDecoration.floatingLabelStyle!
        .copyWith(color: Colors.black38),
  ),
  listTileTheme: _listTileTheme.copyWith(iconColor: Colors.black45),
  dividerColor: Colors.black12.withOpacity(0.1),
  dividerTheme: _dividerTheme.copyWith(),
);

ColorScheme _darkColorScheme = ColorScheme(
  primary: Colors.indigo,
  secondary: Colors.purple.shade600,
  surface: const Color(0xFF18192E), //Colors.indigo.shade50,
  background: const Color(0xFF0E0E1F), //Colors.indigo.shade100,
  error: Colors.redAccent.shade400,
  onPrimary: Colors.indigo.shade50,
  onSecondary: Colors.purple.shade50,
  onSurface: Colors.white70,
  onBackground: Colors.grey.shade800,
  onError: Colors.red.shade100,
  brightness: Brightness.dark,
  surfaceVariant: const Color.fromARGB(255, 17, 20, 68),
  onSurfaceVariant: Colors.indigo.shade500,
);

/// DARK ThemeData ============================================================
ThemeData _darkThemeData = _baseThemeData.copyWith(
  colorScheme: _darkColorScheme,
  primaryColorLight: Colors.indigo.shade900,
  // brightness: Brightness.dark,
  // primaryColor: Colors.indigo.shade600,
  scaffoldBackgroundColor: _darkColorScheme.background,
  canvasColor: _darkColorScheme.background,
  dialogBackgroundColor: _darkColorScheme.background,
  appBarTheme: _baseAppBarTheme.copyWith(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness:
          DeviceOS.isAndroid ? Brightness.light : Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
    iconTheme: IconThemeData(color: _darkColorScheme.primary),
    color: Colors.transparent, // baseColorSwatch[500],
    titleTextStyle: _baseAppBarTheme.titleTextStyle!.copyWith(
      color: _darkColorScheme.primary,
    ),
  ),
  textTheme: _baseThemeData.textTheme.copyWith(
    bodyText1: _baseTextTheme.bodyText1!.copyWith(color: Colors.white),
    bodyText2: _baseTextTheme.bodyText2!.copyWith(color: Colors.white),
    subtitle1: _baseTextTheme.subtitle1!.copyWith(color: Colors.white),
    subtitle2: _baseTextTheme.subtitle2!.copyWith(color: Colors.white54),
    headline1: _baseTextTheme.headline1!.copyWith(color: Colors.white),
    headline2: _baseTextTheme.headline2!.copyWith(color: Colors.white),
    headline6: _baseTextTheme.headline6!.copyWith(color: Colors.white),
  ),
  cardTheme: _baseCardTheme.copyWith(
    color: _darkColorScheme.surface,
    shadowColor: _darkColorScheme.shadow,
  ),
  inputDecorationTheme: _baseInputDecoration.copyWith(
    hintStyle: _baseInputDecoration.hintStyle!.copyWith(color: Colors.white12),
    labelStyle:
        _baseInputDecoration.labelStyle!.copyWith(color: Colors.white38),
    floatingLabelStyle: _baseInputDecoration.floatingLabelStyle!
        .copyWith(color: Colors.white38),
  ),
  listTileTheme: _listTileTheme.copyWith(
    iconColor: Colors.white54,
    textColor: Colors.white70,
    style: ListTileStyle.list,
  ),
  dividerTheme: _dividerTheme.copyWith(color: Colors.black26),
);
