{{#navigator_service}}import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NavigatorService {
  //TODO: implement this
  void navigateTo(
    BuildContext context,
    String command, {
    String? contentId,
    String? senderId,
  }) async {
    switch (command) {
      case 'do-stuff':
        // do stuff
        break;
    }
  }
}{{/navigator_service}}