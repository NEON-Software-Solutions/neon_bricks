import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:{{project_name}}/core/core.dart';{{#toast_service}}
import 'package:{{project_name}}/injection.dart';{{/toast_service}}{{^theme_switching}}
import 'package:{{project_name}}/app_settings.dart';{{/theme_switching}}{{#theme_switching}}
import 'package:{{project_name}}/features/theme_switching/theme_switching.dart';{{/theme_switching}}

import '../bloc/bloc.dart';

class SignUpForm extends {{#toast_service}}StatelessWidget{{/toast_service}}{{^toast_service}}StatefulWidget{{/toast_service}} {
  final void Function()? switchToLogin;
  const SignUpForm({
    Key? key,
    this.switchToLogin,
  }) : super(key: key);

{{^toast_service}}
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String? _errorMessage;

{{/toast_service}}
  void _signUpOnSubmit(BuildContext context) {
    if (context.read<SignUpBloc>().canSignup) {
      _signUp(context);
    }
  }

  void _signUp(BuildContext context) {
    //TODO: implement this differently, if needed.
    context.read<SignUpBloc>().add(
          SignUpEvent.signUp({{^toast_service}}
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
      BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: kPadHorMedium,
                child: TextInputField(
                  initialValue: state.username ?? '',
                  decoration: InputDecoration(
                    hintText: 'hintUsername'.tr(),
                    hintStyle: theme.textTheme.labelSmall,
                    errorStyle: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.errorColor),
                  ),
                  keyboardType: TextInputType.name,{{^toast_service}}
              onChange: (newValue) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
                context.read<SignUpBloc>().add(
                        SignUpEvent.changeUsername(username: newValue));
              },{{/toast_service}}{{#toast_service}}
                  onChange: (newValue) => context.read<SignUpBloc>().add(
                        SignUpEvent.changeUsername(username: newValue),
                      ),{{/toast_service}}
                  onSubmitted: (_) => _signUpOnSubmit(context),
                ),
              ),
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
                context.read<SignUpBloc>().add(
                        SignUpEvent.changeEmail(email: newValue));
              },{{/toast_service}}{{#toast_service}}
                  onChange: (newValue) => context.read<SignUpBloc>().add(
                        SignUpEvent.changeEmail(email: newValue),
                      ),{{/toast_service}}
                  onSubmitted: (_) => _signUpOnSubmit(context),
                ),
              ),
              Padding(
                padding: kPadHorMedium,
                child: TextInputField(
                  initialValue: state.password ?? '',
                  decoration: InputDecoration(
                    hintText: 'hintPassword'.tr(),
                    hintStyle: theme.textTheme.labelSmall,
                    errorStyle: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.errorColor),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  {{^toast_service}}
              onChange: (newValue) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
                context.read<SignUpBloc>().add(
                        SignUpEvent.changePassword(password: newValue));
              },{{/toast_service}}{{#toast_service}}
                  onChange: (newValue) => context.read<SignUpBloc>().add(
                        SignUpEvent.changePassword(password: newValue),
                      ),{{/toast_service}}
                  onSubmitted: (_) => _signUpOnSubmit(context),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: kPadLarge,
                child: {{#toast_service}}ActionButton(
                  title: 'signUp'.tr(),
                  disabled: !context.read<SignUpBloc>().canSignup,
                  onPressed: () => _signUp(context),
                ),{{/toast_service}}{{^toast_service}}
                Column(
              children: [
                ActionButton(
                  title: 'signUp'.tr(),
                  disabled: !context.read<SignUpBloc>().canSignup,
                  onPressed: () => _signUp(context),
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
            ),{{/toast_service}}
              ),
              if ({{^toast_service}}widget.{{/toast_service}}switchToLogin != null) const SizedBox(height: 50),
              if ({{^toast_service}}widget.{{/toast_service}}switchToLogin != null)
                Padding(
                  padding: kPadLarge,
                  child: TextButton(
                    child: Text('goToLogin'.tr()),
                    onPressed: {{^toast_service}}widget.{{/toast_service}}switchToLogin,
                  ),
                ),
            ],
          ),
        ){{#theme_switching}} ,){{/theme_switching}} ;
  }
}
