import 'dart:developer';

import 'package:neon_core/neon_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'package:{{project_name}}/injection.dart';
import 'package:{{project_name}}/app_settings.dart';
import 'package:{{project_name}}/core/services/services.dart';

@lazySingleton
class DynamicLinkService {
  late BuildContext _cachedContext;

  static const socialMetaTagsTitle = 'Foo-Bar'; //TODO
  static const socialMetaTagsDefaultImageURL =
      'https://foo-bar.com/foo.jpg'; //TODO

  /// Link that is opened when the app is not installed. Need more granularity?
  /// Check out ifl and afl for iOS and Android, respectively.
  static const oflLink = 'foo-bar.com'; //TODO.

  Future<PendingDynamicLinkData?> getAndHandlePendingDynamicLink(
    BuildContext context, {
    required bool isLoggedIn,
    PendingDynamicLinkData? cachedUri,
  }) async {
    _cachedContext = context;
    if (!kIsWebOrMacOS) {
      final dynamicLinksInstance = getIt<FirebaseDynamicLinks>();
      final data = await dynamicLinksInstance.getInitialLink() ?? cachedUri;

      _handleDeepLink(data);

      dynamicLinksInstance.onLink.listen(
        (dynamicLinkData) => _handleDeepLink(dynamicLinkData),
      );

      if (data != null) {
        return data;
      }
    }

    return null;
  }

  _handleDeepLink(PendingDynamicLinkData? data) async {
    final deepLink = data?.link;
    if (deepLink != null) {
      log('handling deeplink: $deepLink');

      var path = deepLink.path;
      switch (path) {
        case '/content':
          //TODO: this is just demo logic. Feel free to remove this.
          String? contentId = deepLink.queryParameters['id'];{{#toast_service}}
          getIt<ToastService>().showSuccessToast(_cachedContext, contentId);{{/toast_service}}{{^toast_service}}
          print(contentId);{{/toast_service}}
          break;
        case '/foo':
          //TODO: implement some logic here
          break;
        case '/bar':
          //TODO: implement some logic here (maybe with parameter parsing and navigation?)
          String? someId = deepLink.queryParameters['some-id'];
          getIt<NavigatorService>().navigateTo(
              _cachedContext, 'navigateSomewhere',
              contentId: someId);
          break;
        default:
        //TODO: implement your default logic here

      }
    }
  }

  //TODO: rewrite this as needed
  Future<String> buildShareLink({
    required String contentId,
    String? thumbnailUrl,
    String? customSuffix,
  }) async {
    final url = 'https://foo-bar.com/content?id=$contentId'; //TODO

    if (kIsWebOrMacOS) {
      return _buildUriFromUrl(
        url: url,
        customSuffix: customSuffix,
      );
    } else {
      String? imageURL;

      //TODO: you might want to add custom images to each of your deeplinks,
      // instead of the [socialMetaTagsDefaultImageURL].

      // if (thumbnailUrl != null) {
      //   // both fine. depends on your needs.
      //   final response = await Dio().get('$thumbnailUrl?preferThumbnail=true');
      //   final response =
      //       await http.Client().get('$thumbnailUrl?preferThumbnail=true');

      //   try {
      //     //TODO: implement correct parsing of the response
      //     imageURL = response.data['url'] as String;
      //   } catch (e) {
      //     //TODO: implement error handling
      //     log(e.toString());
      //     rethrow;
      //   }
      // }

      final parameters = DynamicLinkParameters(
        uriPrefix: kDynamicLinkUriPrefix,
        link: Uri.parse(url),
        androidParameters: kDynamicLinkAndroidParameters,
        iosParameters: kDynamicLinkIosParameters,
        socialMetaTagParameters: _getSocialMetaTags(imageURL: imageURL),
      );

      return _buildUriFromDynamicLinkParameters(
        parameters: parameters,
        customSuffix: customSuffix,
      );
    }
  }

  //TODO: add more share functions, for example:

  // Future<String> buildShareUserLink(String userId) async {
  //   final url = 'https://www.foo-bar.com/user?id=$userId';
  //   final customSuffix = 'dynamicLinkUserInviteStringify'.tr();
  //   if (kIsWebOrMacOS) {
  //     return _buildUriFromUrl(
  //       url: url,
  //       customSuffix: customSuffix,
  //     );
  //   } else {
  //     final parameters = DynamicLinkParameters(
  //       uriPrefix: kDynamicLinkUriPrefix,
  //       link: Uri.parse(url),
  //       androidParameters: kDynamicLinkAndroidParameters,
  //       iosParameters: kDynamicLinkIosParameters,
  //       socialMetaTagParameters: _getSocialMetaTags(),
  //     );

  //     return _buildUriFromDynamicLinkParameters(
  //       parameters: parameters,
  //       customSuffix: customSuffix,
  //     );
  //   }
  // }

  Future<String> _buildUriFromDynamicLinkParameters({
    required DynamicLinkParameters parameters,
    String? customSuffix,
  }) async {
    var uri = parameters.link;
    uri = Uri.parse('$uri&ofl=$oflLink');

    // Building a Short Link with Firebase Dynamic Links requires a http call.
    final isOffline = await getIt<InternetConnectionService>().isOffline;
    if (isOffline) return _stringify(uri, customSuffix: customSuffix);

    final longLink = await getIt<FirebaseDynamicLinks>().buildLink(parameters);
    final shortenedLink = await getIt<FirebaseDynamicLinks>().buildShortLink(
        DynamicLinkParameters(
          link: parameters.link,
          uriPrefix: parameters.uriPrefix,
          androidParameters: parameters.androidParameters,
          iosParameters: parameters.iosParameters,
          socialMetaTagParameters: parameters.socialMetaTagParameters,
          navigationInfoParameters: parameters.navigationInfoParameters,
          longDynamicLink: Uri.parse('$longLink&ofl=$oflLink'),
        ),
        shortLinkType: ShortDynamicLinkType.short);
    return _stringify(shortenedLink.shortUrl, customSuffix: customSuffix);
  }

  String _buildUriFromUrl({
    required String url,
    String? customSuffix,
  }) {
    final uri = Uri.parse(url);
    return _stringify(uri, customSuffix: customSuffix);
  }

  String _stringify(Uri uri, {String? customSuffix}) {
    if (customSuffix == null || customSuffix == '') return uri.toString();

    return '${uri.toString()}\n$customSuffix';
  }

  SocialMetaTagParameters _getSocialMetaTags({String? imageURL}) =>
      SocialMetaTagParameters(
        title: socialMetaTagsTitle,
        description: 'shareDescription'.tr(),
        imageUrl: Uri.parse(imageURL ?? socialMetaTagsDefaultImageURL),
      );
}
