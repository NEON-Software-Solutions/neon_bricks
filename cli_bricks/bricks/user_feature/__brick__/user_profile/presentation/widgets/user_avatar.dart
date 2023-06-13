import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

{{#theme_switching}}import 'package:flutter_bloc/flutter_bloc.dart';{{/theme_switching}}
import 'package:neon_core/neon_core.dart';

{{#theme_switching}}import 'package:{{project_name}}/features/theme_switching/theme_switching.dart';{{/theme_switching}}{{^theme_switching}}
import 'package:{{project_name}}/app_settings.dart';{{/theme_switching}}
import 'package:{{project_name}}/features/user_profile/domain/domain.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final bool isGrey;
  final bool withBorder;
  final Color? borderColor;
  final User? user;

  const UserAvatar({
    Key? key,
    this.size = 50,
    this.withBorder = true,
    this.user,
    this.borderColor,
    this.isGrey = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {{^theme_switching}}final theme = appTheme;{{/theme_switching}}
    final hasSpecialShape = !isWebInMobile(context);
    {{#theme_switching}}return BlocBuilder<ThemeCubit, ThemeData>(builder: (context, theme) { {{/theme_switching}}
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isWebInMobile(context) || withBorder
                    ? Border.all(
                        width: 1,
                        color: theme.iconTheme.color ?? Colors.white,
                      )
                    : null,
              ),
              child: hasSpecialShape
                  ? _getImage(
                      context,
                      withFadeIn: false,
                      placeholderColor: theme.iconTheme.color ?? Colors.white30,
                    )
                  : ClipOval(
                      child: _getImage(
                        context,
                        placeholderColor:
                            theme.iconTheme.color ?? Colors.white30,
                      ),
                    ),
            ),
          ),
        ],
      );
  }{{#theme_switching}},
    );
  }{{/theme_switching}}

  Widget _getImage(BuildContext context,
      {bool withFadeIn = true, required Color placeholderColor}) {
    final placeholder = Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(size * 0.2),
      child: Icon(
        CupertinoIcons.person_fill,
        color: placeholderColor,
      ),
    );

    if (user == null) return placeholder;
    if (user!.profileImageUrl != null) {
      return RedirectedCachedNetworkImage(
        key: Key(user!.id),
        url: user!.profileImageUrl!,
        buildRedirectURL: (url) => url,
        placeholder: withFadeIn ? placeholder : Container(),
        color: isGrey ? Colors.grey : null,
        withFade: withFadeIn,
      );
    } else {
      return placeholder;
    }
  }

}