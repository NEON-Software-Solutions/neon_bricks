import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:shimmer/shimmer.dart';
{{^theme_switching}}
import 'package:{{project_name}}/app_settings.dart';{{/theme_switching}}{{#theme_switching}}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name}}/features/theme_switching/theme_switching.dart';{{/theme_switching}}
import 'package:{{project_name}}/core/core.dart';

enum ActionButtonType { filled, border, none, shimmer }

class ActionButton extends StatefulWidget {
  final bool disabled;
  final bool fullWidth;
  final ActionButtonType buttonType;
  final Color? fillColor;
  final Color? borderColor;
  final String title;
  final TextStyle? titleStyle;
  final double height;
  final double width;
  final double minFontSize;
  final TextOverflow? overflow;
  final int maxLines;
  final EdgeInsets? padding;
  final Function()? onPressed;
  final Widget? prefix;
  final bool disableHapticFeedback;

  const ActionButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.height = 50,
    this.width = 80,
    this.disabled = false,
    this.buttonType = ActionButtonType.none,
    this.minFontSize = 8,
    this.maxLines = 1,
    this.padding,
    this.overflow,
    this.titleStyle,
    this.fillColor,
    this.borderColor,
    this.fullWidth = true,
    this.prefix,
    this.disableHapticFeedback = false,
  }) : super(key: key);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _isActive = false;
  @override
  Widget build(BuildContext context) {
    {{^theme_switching}}final theme = appTheme;

    {{/theme_switching}}return {{#theme_switching}}BlocBuilder<ThemeCubit, ThemeData>(builder: (context, theme) =>{{/theme_switching}}widget.buttonType == ActionButtonType.shimmer
        ? Shimmer.fromColors(
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: kBorderRadiusSmall,
                color: theme.primaryColor,
              ),
            ),
            baseColor: theme.primaryColor,
            highlightColor: theme.primaryColorLight,
          )
        : Opacity(
            opacity: widget.disabled ? 0.5 : 1,
            child: GestureDetector(
              onTap: () async {
                if (widget.disabled) {
                  return;
                }
                if (!widget.disableHapticFeedback) {
                  await HapticFeedback.mediumImpact();
                }
                {{#firebase_crashlytics_feature}} try { {{/firebase_crashlytics_feature}}widget.onPressed?.call();{{#firebase_crashlytics_feature}} 
                } catch (e, stackTrace) {
                  await handleError(error: e, stackTrace: stackTrace);
                } {{/firebase_crashlytics_feature}}
              },
              onTapDown: (details) {
                setState(() {
                  _isActive = true;
                });
              },
              onTapUp: (details) => _setInactive(),
              onPanEnd: (details) => _setInactive(),
              onTapCancel: () => _setInactive(),
              onPanCancel: () => _setInactive(),
              child: AnimatedContainer(
                constraints: widget.fullWidth ? kButtonConstraints : null,
                width: widget.fullWidth ? double.infinity : null,
                height: widget.height,
                duration: const Duration(milliseconds: 100),
                padding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: widget.borderColor ?? _getBorderColor(theme)),
                    borderRadius: kBorderRadiusSmall,
                    color: widget.fillColor ?? _getBackgroundColor(theme)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.prefix != null) widget.prefix!,
                      if (widget.prefix != null && widget.title.isNotEmpty)
                        const SizedBox(width: 7),
                      Flexible(
                        fit: FlexFit.loose,
                        child: AutoSizeText(
                          widget.title,
                          overflow: widget.overflow,
                          minFontSize: widget.minFontSize,
                          maxLines: widget.maxLines,
                          textAlign: TextAlign.center,
                          style:
                              widget.titleStyle ?? theme.textTheme.displaySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ){{#theme_switching}},){{/theme_switching}};
  }

  _setInactive() {
    setState(() {
      _isActive = false;
    });
  }

  _getBackgroundColor(ThemeData data) {
    if (widget.buttonType == ActionButtonType.filled) {
      if (_isActive) {
        return data.colorScheme.secondary;
      }
      return data.colorScheme.secondary;
    } else if (widget.buttonType == ActionButtonType.border) {
      if (_isActive) {
        return data.colorScheme.secondary;
      }
      return data.primaryColor;
    } else {
      if (_isActive) {
        return data.colorScheme.secondary;
      }
      return data.primaryColor;
    }
  }

  _getBorderColor(ThemeData data) {
    if (widget.buttonType == ActionButtonType.filled) {
      if (_isActive) {
        return data.colorScheme.secondary;
      }
      return data.colorScheme.secondary;
    } else if (widget.buttonType == ActionButtonType.border) {
      return data.colorScheme.secondary;
    } else {
      if (_isActive) {
        return data.primaryColor;
      }
      return data.primaryColor;
    }
  }
}
