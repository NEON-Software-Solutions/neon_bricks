import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:{{project_name}}/core/core.dart';{{#toast_service}}
import 'package:{{project_name}}/injection.dart';{{/toast_service}}{{^theme_switching}}
import 'package:{{project_name}}/app_settings.dart';{{/theme_switching}}{{#theme_switching}}
import 'package:{{project_name}}/features/theme_switching/theme_switching.dart';{{/theme_switching}}

import '../bloc/bloc.dart';

class LoginForm extends {{#toast_service}}StatelessWidget{{/toast_service}}{{^toast_service}}StatefulWidget{{/toast_service}} {
  final void Function()? switchToSignup;
  const LoginForm({
    Key? key,
    this.switchToSignup,
  }) : super(key: key);
{{^toast_service}}
    @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? _errorMessage;

{{/toast_service}}
  void _loginOnSubmit(BuildContext context) {
    if (context.read<LoginBloc>().canLogin) {
      _startLocalLogin(context);
    }
  }

  void _startLocalLogin(BuildContext context) {
    //TODO: implement this differently, if needed
    context.read<LoginBloc>().add(
          LoginEvent.startLocalLogin({{^toast_service}}
            onError: (errorMessage) {
              setState(() {
                _errorMessage = errorMessage;
              });
            },{{/toast_service}}{{#toast_service}}
            onError: (errMessage) => getIt<ToastService>().showErrorToast(
              context,
              errMessage,
            ),{{/toast_service}}
            onSuccess: (newUser) => context
                .read<AuthenticationBloc>()
                .add(AuthenticationEvent.updateUser(newUser)),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    {{^theme_switching}}final theme = appTheme;{{/theme_switching}}
    return {{#theme_switching}} BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, theme) =>{{/theme_switching}}
         BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: kPadHorMedium,
                child: TextInputField(
                  initialValue: state.email ?? '',
                  decoration: InputDecoration(
                    hintText: 'hintEmail'.tr(),
                    hintStyle: theme.textTheme.labelSmall,
                    errorStyle: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.errorColor),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  {{^toast_service}}
              onChange: (newValue) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
                context.read<LoginBloc>().add(
                      LoginEvent.changeEmail(email: newValue),
                    );
              },{{/toast_service}}{{#toast_service}}
                  onChange: (newValue) => context.read<LoginBloc>().add(
                        LoginEvent.changeEmail(email: newValue),
                      ),{{/toast_service}}
                  onSubmitted: (_) => _loginOnSubmit(context),
                ),
              ),
              Padding(
                padding: kPadHorMedium,
                child: TextInputField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'hintPassword'.tr(),
                    hintStyle: theme.textTheme.labelSmall,
                    errorStyle: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.errorColor),
                  ),
                  {{^toast_service}}
              onChange: (newValue) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
                context.read<LoginBloc>().add(
                      LoginEvent.changePassword(password: newValue),
                    );
              },{{/toast_service}}{{#toast_service}}
                  onChange: (newValue) => context.read<LoginBloc>().add(
                        LoginEvent.changePassword(password: newValue),
                      ),{{/toast_service}}
                  onSubmitted: (_) => _loginOnSubmit(context),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: kPadLarge,
                child: {{#toast_service}}ActionButton(
                  title: 'login'.tr(),
                  disabled: !context.read<LoginBloc>().canLogin,
                  onPressed: () => _startLocalLogin(context),
                ),{{/toast_service}}{{^toast_service}}
                Column(
              children: [
                ActionButton(
                  title: 'login'.tr(),
                  disabled: !context.read<LoginBloc>().canLogin,
                  onPressed: () => _startLocalLogin(context),
                ),
                const SizedBox(
                  height: 30,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn,
                  opacity: _errorMessage == null ? 0 : 1,
                  child: Text(
                    _errorMessage ?? '',
                    style: kTextLabelError,
                  ),
                ),
              ],
            ),
            {{/toast_service}}
              ),
              if ({{^toast_service}}widget.{{/toast_service}}switchToSignup != null) const SizedBox(height: 50),
              if ({{^toast_service}}widget.{{/toast_service}}switchToSignup != null)
                Padding(
                  padding: kPadLarge,
                  child: TextButton(
                    child: Text('goToSignUp'.tr()),
                    onPressed: {{^toast_service}}widget.{{/toast_service}}switchToSignup,
                  ),
                ),
            ],
          ),
        ){{#theme_switching}} ,){{/theme_switching}} ;
  }
}
