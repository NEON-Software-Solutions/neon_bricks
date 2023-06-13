import 'package:flutter/material.dart';

import 'presentation.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _showLogin = true;

  void _switchForms() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _showLogin
          ? LoginForm(
              switchToSignup: _switchForms,
            )
          : SignUpForm(
              switchToLogin: _switchForms,
            ),
    );
  }
}
