// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';
import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplues/repositories/user_repository.dart';
import 'package:shareplues/services/local_storage.dart';
import '../constants/app_config.dart';
import '../constants/storage_keys.dart';
import '../models/user.dart';

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  return DeepLinkService(ref);
});

class DeepLinkService {
  final Ref reference;

  LocalStorageService get storageService => reference.read(localStorageServiceProvider);
  UserRepository get userRepo => reference.read(userRepositoryProvider);

  DeepLinkService(this.reference) {
    _startDeepLink();
  }

  StreamSubscription<PendingDynamicLinkData>? _dynamicLinkStream;

  Future<void> _startDeepLink() async {
    FirebaseDynamicLinks.instance.getInitialLink().then((data) async {
      if (data == null) {
        return;
      }
      await _startDeepLinkProcess(data);
    });

    closeDeepLinkSubscription();
    _dynamicLinkStream = FirebaseDynamicLinks.instance.onLink.listen((data) async {
      await _startDeepLinkProcess(data);
    });
  }

  void closeDeepLinkSubscription() {
    _dynamicLinkStream = null;
    _dynamicLinkStream?.cancel();
  }

  Future<void> _startDeepLinkProcess(PendingDynamicLinkData data) async {
    if (!userRepo.userExist) {
      _performSignIn(data);
    } else {
      _performInAppActions(data);
    }
  }

  Future<bool> handleInAppDynamicLink(String url) async {
    try {
      final link = await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(url));
      if (link != null) {
        await _performInAppActions(link);
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<Uri> createEmailVerificationLink(Uri uri) async {
    final parameters = DynamicLinkParameters(
      uriPrefix: AppConfig.dynamicLinkBaseUrl,
      link: uri,
      androidParameters: AndroidParameters(
        packageName: AppConfig.applicationId,
        fallbackUrl: uri,
      ),
      navigationInfoParameters: const NavigationInfoParameters(forcedRedirectEnabled: false),
      iosParameters: IOSParameters(
        bundleId: AppConfig.bundleId,
        fallbackUrl: uri,
        appStoreId: AppConfig.appStoreId,
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'Verify Your Email',
        description: 'Click link to verify your email at Snappbum Inc',
      ),
    );

    return parameters.link;
  }

  Future<void> _performInAppActions(PendingDynamicLinkData data) async {
    // final Uri deepLink = data.link;
  }

  Future<void> _performSignIn(PendingDynamicLinkData data) async {
    final Map<String, dynamic> query = data.link.queryParameters;
    final isSignin = query["mode"] == "signIn";

    if (!isSignin) return;

    try {
      String? userString = await storageService.getLocalStoredData(AppStorageKey.STORAGE_USER_REGISTRATION_DETAILS);
      String? email = await storageService.getLocalStoredData(AppStorageKey.STORAGE_EMAIL_KEY);

      User? user;

      if (userString != null) {
        user = User.fromMap(jsonDecode(userString));
      }

      if (email == null && user?.email == null) return;

      final confirmEmailLink = await userRepo.confirmEmailLink(email ?? user!.email, data.link.toString(), user: user);

      if (confirmEmailLink.isRight) {
        // navigate to dashboard
      } else {}
    } catch (_) {}
  }
}
