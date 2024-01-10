import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppStateWidget extends StatelessWidget {
  AppStateWidget({
    super.key,
    this.type = AppState.general,
    this.title,
    this.message,
    this.icon,
    this.actionButton,
    this.actionButtonLabel,
    this.action,
  });
  AppState type;
  String? message;
  String? title;
  Widget? icon;
  Widget? actionButton;
  String? actionButtonLabel;
  VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppState.notFound:
        title = title ?? 'Not Found';
        message = message ?? "Sorry, we didn't find any result for you'";
        icon = icon ?? _getIcon(AppState.notFound);
        actionButtonLabel = actionButtonLabel ?? 'Back';
        action = action ?? () => Navigator.of(context).pop();
        break;
      case AppState.noResult:
        title = title ?? 'Nothing Found';
        message = message ?? "Sorry, we didn't find any result for you'";
        icon = icon ?? _getIcon(AppState.notFound);
        actionButtonLabel = actionButtonLabel ?? 'Back';
        action = action ?? () => Navigator.of(context).pop();
        break;
      case AppState.general:
        title = title ?? 'Ooops!';
        message = message ?? 'An error occured';
        icon = icon ?? _getIcon(AppState.general);
        actionButtonLabel = actionButtonLabel ?? 'Back';
        action = action ?? () => Navigator.of(context).pop();
        break;
      case AppState.loading:
        title = title ?? '';
        message = message ?? 'Please wait...';
        icon = icon ?? const SizedBox.shrink();
        break;
      case AppState.serverError:
        title = title ?? 'Server Error!';
        message =
            message ?? 'Sorry, an error occured on the server. Please retry.';
        icon = icon ?? _getIcon(AppState.serverError);
        actionButtonLabel = actionButtonLabel ?? 'Retry';
        action = action ?? () => Navigator.of(context).pop();
        break;
      case AppState.noConnection:
        title = title ?? 'No Internet!';
        message =
            message ?? 'Please check the internet connection\n and try again.';
        icon = icon ?? _getIcon(AppState.noConnection);
        actionButtonLabel = actionButtonLabel ?? 'Retry';
        action = action ?? () => Navigator.of(context).pop();
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: icon,
        ),
        // const Spacer(),
        if (type == AppState.loading)
          const Center(child: CircularProgressIndicator())
        else
          title!.isNotEmpty
              ? Text(title!, style: TextStyles.errorTitleStyle)
              : const SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Text(
            message!,
            style: TextStyles.errorBodyStyle,
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        if (type != AppState.loading)
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: PrimaryBtn(onPressed: action, label: actionButtonLabel),
            ),
          ),
        if (type != AppState.loading) const Spacer(),
      ],
    );
  }

  Widget _getIcon(AppState type) {
    switch (type) {
      case AppState.general:
        return Image.asset('assets/images/state_error.png', height: 200);

      case AppState.notFound:
        return Image.asset('assets/images/state_notfound.png', height: 200);

      case AppState.serverError:
        return Image.asset('assets/images/state_notfound.png', height: 200);

      case AppState.noConnection:
        return Image.asset('assets/images/state_notfound.png', height: 200);

      case AppState.noResult:
        return Image.asset('assets/images/state_notfound.png', height: 200);

      case AppState.loading:
        return Image.asset('assets/images/state_notfound.png', height: 200);
    }
  }
}
