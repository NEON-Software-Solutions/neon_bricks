import 'package:flutter/material.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:injectable/injectable.dart';
import 'package:easy_localization/easy_localization.dart';{{#theme_switching}}
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{project_name}}/features/theme_switching/presentation/presentation.dart';{{/theme_switching}}
{{^theme_switching}}import 'package:{{project_name}}/app_settings.dart';{{/theme_switching}}

@lazySingleton
class ToastService {
  {{^theme_switching}}final theme = appTheme;{{/theme_switching}}

  void showErrorToast(BuildContext context, [String? message]) {
    {{#theme_switching}}final theme = context.read<ThemeCubit>().state;{{/theme_switching}}
    final errorToast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.errorColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                message ?? 'errorSomethingWentWrongPleaseTryAgain'.tr(),
                style: theme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
    _showCustomToast(context, errorToast);
  }

  void showSuccessToast(BuildContext context, [String? message]) {
    {{#theme_switching}}final theme = context.read<ThemeCubit>().state;{{/theme_switching}}

    final successToast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                message ?? '${'done'.tr()}!',
                style: theme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
    _showCustomToast(context, successToast);
  }

  void _showCustomToast(BuildContext context, Container toast) {
    showToastWidget(
      GestureDetector(
        onTap: () {
          dismissAllToast(showAnim: true);
        },
        child: toast,
      ),
      context: context,
      position: StyledToastPosition.top,
      duration: const Duration(
        seconds: 8,
      ),
      animDuration: const Duration(
        seconds: 1,
      ),
      isIgnoring: false,
      animationBuilder: (
        BuildContext context,
        AnimationController controller,
        Duration duration,
        Widget child,
      ) {
        return SlideTransition(
          position: getAnimation<Offset>(
            const Offset(0.0, -20.0),
            const Offset(0, 0),
            controller,
            curve: Curves.fastOutSlowIn,
          ),
          child: child,
        );
      },
      reverseAnimBuilder: (
        BuildContext context,
        AnimationController controller,
        Duration duration,
        Widget child,
      ) {
        return SlideTransition(
          position: getAnimation<Offset>(
            const Offset(0.0, 0.0),
            const Offset(0.0, -20.0),
            controller,
            curve: Curves.fastOutSlowIn,
          ),
          child: child,
        );
      },
    );
  }
}
