import 'package:flutter/material.dart';
{{^theme_switching}}
import 'package:{{project_name}}/app_settings.dart';{{/theme_switching}}{{#theme_switching}}
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{project_name}}/features/theme_switching/theme_switching.dart';{{/theme_switching}}
import 'package:{{project_name}}/core/core.dart';

class TextInputField extends StatefulWidget {
  final String initialValue;
  final Function(String)? onChange;
  final Function(String)? onSubmitted;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool obscureText;

  final InputDecoration? decoration;

  final IconData? icon;
  final Color? iconColor;
  final TextStyle? disabledStyle;
  final bool isEnabled;
  final FocusNode? focusNode;
  final TextEditingController? textController;
  final TextCapitalization textCapitalization;

  const TextInputField({
    Key? key,
    this.initialValue = '',
    this.decoration,
    this.onChange,
    this.onSubmitted,
    this.obscureText = false,
    this.icon,
    this.disabledStyle,
    this.isEnabled = true,
    this.focusNode,
    this.textController,
    this.suffix,
    this.keyboardType,
    this.maxLength,
    this.iconColor,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  TextEditingController? _textController;

  @override
  void initState() {
    if (widget.textController == null) {
      _textController = TextEditingController(text: widget.initialValue);
    } else {
      _textController = widget.textController;
      _textController!.text = widget.initialValue;
    }
    super.initState();
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    {{^theme_switching}}final theme = appTheme;{{/theme_switching}}
    return  {{#theme_switching}}BlocBuilder<ThemeCubit, ThemeData>(builder: (context, theme) => {{/theme_switching}}Stack(
      children: [
        TextField(
          textCapitalization: widget.textCapitalization,
          controller: _textController,
          focusNode: widget.focusNode,
          cursorColor: theme.primaryColor,
          style: widget.isEnabled
              ? theme.textTheme.bodyMedium
              : widget.disabledStyle ??
                  theme.textTheme.labelLarge
                      ?.copyWith(color: theme.disabledColor),
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          enabled: widget.isEnabled,
          onChanged: widget.onChange,
          obscureText: widget.obscureText,
          onSubmitted: widget.onSubmitted,
          decoration: widget.decoration ??
              InputDecoration(
                fillColor: theme.primaryColor.withOpacity(0.5),
                hintStyle: theme.textTheme.labelSmall,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                focusedBorder: OutlineInputBorder(
                  borderRadius: kBorderRadiusSmall,
                  borderSide: BorderSide(color: theme.primaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: kBorderRadiusSmall,
                  borderSide: BorderSide(color: theme.primaryColor, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: kBorderRadiusSmall,
                  borderSide: BorderSide(color: theme.primaryColor, width: 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: kBorderRadiusSmall,
                  borderSide: BorderSide(color: theme.primaryColor, width: 1),
                ),
              ),
        ),
        if (widget.icon != null)
          Positioned(
            left: 10,
            top: 14,
            child: Icon(
              widget.icon,
              size: theme.iconTheme.size ?? 20,
              color: widget.iconColor ?? theme.iconTheme.color,
            ),
          )
      ],
    ){{#theme_switching}},){{/theme_switching}};
  }
}
