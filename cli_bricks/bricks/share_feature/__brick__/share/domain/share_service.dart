import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';

import 'package:{{project_name}}/features/share/domain/dynamic_links_service.dart';
import 'package:{{project_name}}/injection.dart';

@lazySingleton
class ShareService {
  Future<void> shareAppContent(
    BuildContext context, {
    required String contentId,
  }) async {
    final link =
        await getIt<DynamicLinkService>().buildShareLink(contentId: contentId);
    Share.share(
      link,
      subject: 'Foo-Bar', //TODO
    );
  }
}
