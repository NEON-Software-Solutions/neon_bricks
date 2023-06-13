import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:{{project_name}}/core/core.dart';
import 'package:{{project_name}}/features/user_profile/domain/domain.dart';

import 'widgets/user_avatar.dart';

class UserProfilePage extends StatelessWidget {
  final User user;
  const UserProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('homePageTitle').tr(),
        actions: [
          IconButton(
            onPressed: () => context.router.navigate(const MainAppRoute()),
            icon: const Icon(CupertinoIcons.home),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(CupertinoIcons.person),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Hello, ${user.name}!'),
            UserAvatar(
              user: user,
            ),
          ],
        ),
      ),
    );
  }
}
