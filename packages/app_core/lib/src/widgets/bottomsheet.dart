import 'package:app_core/src/utils/utils.dart';
import 'package:app_core/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as mds;

class MyBottomSheet {
  // const MyBottomSheet({Key? key}) : super(key: key);
  // ignore: prefer_constructors_over_static_methods
  static MyBottomSheet get to => MyBottomSheet();

  void showQuickMenu({
    required BuildContext context,
    required List<Widget> children,
  }) {
    mds.showCupertinoModalBottomSheet<dynamic>(
      topRadius: Corners.btnRadius,
      // useRootNavigator: true,
      context: context,
      builder: (context) => Material(
        child: SafeArea(
          minimum: EdgeInsets.all(Insets.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: const DecoratedContainer(
                  color: Colors.grey,
                  borderRadius: 50,
                  height: 5,
                  width: 40,
                ),
              ),
              VSpace.xl,
              GridView.count(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                crossAxisCount: 3,
                // childAspectRatio: 1,
                crossAxisSpacing: Insets.md,
                mainAxisSpacing: Insets.md,
                children: children,
              )
            ],
          ),
        ),
      ),
    );
  }

  void showFullMenu({
    required BuildContext context,
    required List<Widget> children,
  }) {
    mds.showCupertinoModalBottomSheet<dynamic>(
      expand: true,
      topRadius: Corners.btnRadius,
      useRootNavigator: true,
      context: context,
      builder: (context) => Material(
        child: SafeArea(
          minimum: EdgeInsets.all(Insets.lg),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> show<T>({
    required BuildContext context,
    required List<Widget> children,
    String title = '',
    bool centered = false,
  }) async {
    await mds.showCupertinoModalBottomSheet<T>(
      topRadius: Corners.lgRadius,
      context: context,
      builder: (context) => Material(
        child: SafeArea(
          minimum: EdgeInsets.all(Insets.xl),
          child: ListView(
            shrinkWrap: true,
            // mainAxisSize: MainAxisSize.min,
            children: [
              VSpace.lg,
              if (title.isNotEmpty) ...[
                Text(
                  title,
                  style: TextStyles.appBar
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: centered ? TextAlign.center : TextAlign.start,
                ),
                VSpace.lg,
              ],
              ...children,
              VSpace.lg,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loading<T>({
    required BuildContext context,
    List<Widget>? children,
    String title = '',
  }) async {
    await mds.showCupertinoModalBottomSheet<T>(
      topRadius: Corners.btnRadius,
      context: context,
      builder: (context) => Material(
        child: SafeArea(
          minimum: EdgeInsets.all(Insets.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [VSpace.lg, const CircularProgressIndicator()],
          ),
        ),
      ),
    );
  }
}

class GridViewMenuWrapper extends StatelessWidget {
  const GridViewMenuWrapper({
    Key? key,
    required this.children,
  }) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: Insets.sm,
      mainAxisSpacing: Insets.sm,
      children: children,
    );
  }
}

class MenuRoundedButton extends StatelessWidget {
  const MenuRoundedButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.icon,
    required this.color,
    this.modalLauncher = false,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  final bool modalLauncher;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!modalLauncher) onTap();
        Navigator.of(context).pop();
        if (modalLauncher) {
          onTap();
        }
      },
      child: Column(
        children: [
          VSpace.lg,
          DecoratedContainer(
            color: color,
            borderRadius: 100,
            height: 50,
            width: 50,
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          VSpace.sm,
          Text(
            label,
            style: GoogleFonts.poppins().copyWith(fontSize: 11, height: 1),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class MultiSelectField<V> extends FormField<List<V>> {
  const MultiSelectField({super.key, required super.builder});
}
