part of 'settings_widgets.dart';

/// [ActionSettingsTile] is a simple settings tile that can open a new screen
/// by tapping the tile.
class ActionSettingsTile<T> extends StatefulWidget {
  /// Settings Key string for storing the state of Radio buttons in cache (assumed to be unique)
  final String settingKey;

  /// title string for the tile
  final String title;

  /// Selected value by default
  final T defaultValue;

  /// subtitle string for the tile
  final String? subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// widget to be placed at first in the tile
  final Widget? leading;

  /// widget that will be displayed on tap of the tile
  final Widget? child;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  final VoidCallback? onTap;

  /// on change callback for handling the value change
  final OnChanged<T>? onChange;

  ActionSettingsTile(
      {required this.title,
      required this.settingKey,
      required this.defaultValue,
      this.subtitle,
      this.titleTextStyle,
      this.subtitleTextStyle,
      this.enabled = true,
      this.leading,
      this.onTap,
      this.onChange,
      this.child});

  @override
  State<ActionSettingsTile<T>> createState() => _ActionSettingsTileState<T>();
}

class _ActionSettingsTileState<T> extends State<ActionSettingsTile<T>> {
  late T selectedValue;

  @override
  void initState() {
    selectedValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return _SettingsTile(
          leading: widget.leading,
          title: widget.title,
          subtitle: selectedValue as String, // widget.subtitle,
          titleTextStyle: widget.titleTextStyle,
          subtitleTextStyle: widget.subtitleTextStyle,
          enabled: widget.enabled,
          onTap: () => _handleTap(context, onChanged),
          child: widget.child != null ? getIcon(context, onChanged) : Text(''),
        );
      },
    );
  }

  Widget getIcon(BuildContext context, OnChanged<T> onChanged) {
    return IconButton(
      icon: Icon(Icons.navigate_next),
      onPressed: widget.enabled ? () => _handleTap(context, onChanged) : null,
    );
  }

  Future<void> _handleTap(BuildContext context, OnChanged<T> onChanged) async {
    widget.onTap?.call();

    if (widget.child != null) {
      final result = await Navigator.of(context).push<T>(MaterialPageRoute<T>(
        builder: (BuildContext context) => widget.child!,
      ));
      if (result != null) {
        selectedValue = result;
        onChanged(result);
        widget.onChange?.call(result);
        // await Settings.setValue<T>(
        //   widget.settingKey,
        //   result,
        //   notify: true,
        // );
      }
    }
  }
}

/// [CountrySettingsTile] is a simple settings tile that can open a new screen
/// by tapping the tile.
class CountrySettingsTile<T> extends StatefulWidget {
  /// Settings Key string for storing the state of Radio buttons in cache (assumed to be unique)
  final String settingKey;

  /// title string for the tile
  final String title;

  /// Selected value by default
  final T defaultValue;

  /// subtitle string for the tile
  final String? subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// widget to be placed at first in the tile
  final Widget? leading;

  /// widget that will be displayed on tap of the tile
  final Widget? child;

  final List<Country>? filteredCountries;
  final List<Country>? countryList;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  final VoidCallback? onTap;

  /// on change callback for handling the value change
  final OnChanged<Country>? onChange;

  CountrySettingsTile({
    required this.title,
    required this.settingKey,
    required this.defaultValue,
    this.subtitle,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.enabled = true,
    this.leading,
    this.onTap,
    this.onChange,
    this.child,
    this.countryList,
    this.filteredCountries,
  });

  @override
  State<CountrySettingsTile<T>> createState() => _CountrySettingsTileState<T>();
}

class _CountrySettingsTileState<T> extends State<CountrySettingsTile<T>> {
  late T selectedValue;

  @override
  void initState() {
    selectedValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return _SettingsTile(
          leading: widget.leading,
          title: widget.title,
          subtitle: selectedValue as String, // widget.subtitle,
          titleTextStyle: widget.titleTextStyle,
          subtitleTextStyle: widget.subtitleTextStyle,
          enabled: widget.enabled,
          onTap: () => _handleTap(context, onChanged),
          child: widget.child != null ? getIcon(context, onChanged) : Text(''),
        );
      },
    );
  }

  Widget getIcon(BuildContext context, OnChanged<T> onChanged) {
    return IconButton(
      icon: Icon(Icons.navigate_next),
      onPressed: widget.enabled ? () => _handleTap(context, onChanged) : null,
    );
  }

  Future<void> _handleTap(BuildContext context, OnChanged<T> onChanged) async {
    widget.onTap?.call();

    final _countryList = countries.toList();
    final _filteredCountries = _countryList;

    await Navigator.of(context).push<Country>(
      MaterialPageRoute<Country>(
        builder: (BuildContext context) => CountryPickerDialog(
          isCountryPicker: true,
          filteredCountries: widget.filteredCountries ?? _filteredCountries,
          countryList: widget.countryList ?? _countryList,
          selectedCountry: countries.first,
          onCountryChanged: (Country country) async {
            selectedValue = country.name as T;
            onChanged(country.name as T);
            widget.onChange?.call(country);
          },
        ),
      ),
    );

    // await Navigator.of(context).push<Country>(MaterialPageRoute<Country>(
    //   builder: (BuildContext context) => widget.child!,
    // ));
    // if (result != null) {
    //   selectedValue = result as T;
    //   onChanged(result.name as T);
    //   widget.onChange?.call(result);
    //   // await Settings.setValue<T>(
    //   //   widget.settingKey,
    //   //   result,
    //   //   notify: true,
    //   // );
    // }
  }
}

/// [LanguageSettingsTile] is a simple settings tile that can open a new screen
/// by tapping the tile.
class LanguageSettingsTile<T> extends StatefulWidget {
  /// Settings Key string for storing the state of Radio buttons in cache (assumed to be unique)
  final String settingKey;

  /// title string for the tile
  final String title;

  /// Selected value by default
  final T defaultValue;

  /// subtitle string for the tile
  final String? subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// widget that will be displayed on tap of the tile
  final Widget? child;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// widget to be placed at first in the tile
  final Widget? leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  final VoidCallback? onTap;

  /// on change callback for handling the value change
  final OnChanged<Language>? onChange;

  final List<Locale> locales;

  LanguageSettingsTile({
    required this.title,
    required this.settingKey,
    required this.defaultValue,
    this.subtitle,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.child,
    this.enabled = true,
    this.leading,
    this.onTap,
    this.onChange,
    required this.locales,
  });

  @override
  State<LanguageSettingsTile<T>> createState() =>
      _LanguageSettingsTileState<T>();
}

class _LanguageSettingsTileState<T> extends State<LanguageSettingsTile<T>> {
  late T selectedValue;

  @override
  void initState() {
    selectedValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return _SettingsTile(
          leading: widget.leading,
          title: widget.title,
          subtitle: LanguageLocale().getNativeName(selectedValue as String),
          titleTextStyle: widget.titleTextStyle,
          subtitleTextStyle: widget.subtitleTextStyle,
          enabled: widget.enabled,
          onTap: () => _handleTap(context, onChanged),
          child: widget.child != null ? getIcon(context, onChanged) : Text(''),
        );
      },
    );
  }

  Widget getIcon(BuildContext context, OnChanged<T> onChanged) {
    return IconButton(
      icon: Icon(Icons.navigate_next),
      onPressed: widget.enabled ? () => _handleTap(context, onChanged) : null,
    );
  }

  Future<void> _handleTap(BuildContext context, OnChanged<T> onChanged) async {
    widget.onTap?.call();
    // final df = selectedValue;
    // final locale = widget.locales.firstWhere((l) => l.languageCode == df);
    // final selectedLocale =
    // widget.locales.firstWhere((l) => l.languageCode == df);
    //Locale(df.languageCode, df.countryCode);

    final child = widget.child ??
        LanguageWidget(
          locales: widget.locales,
          selected: selectedValue as String,
        );

    final result = await Navigator.of(context).push<Language>(
      MaterialPageRoute<Language>(
        builder: (BuildContext context) => child,
      ),
    );

    if (result == null) return;

    print(result.toJson());
    // print(result.nativeName);
    selectedValue = result.languageCode as T;
    onChanged(result.languageCode as T);
    widget.onChange?.call(result);
    // EasyLocalization.of(context)
    //     ?.setLocale(Locale(value.languageCode, value.countryCode));
    // print(
    // Settings.getValue<Language>(widget.settingKey, Language()).nativeName);
  }
}
