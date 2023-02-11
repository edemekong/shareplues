import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplues/services/deeplink_service.dart';

import '../constants/app_config.dart';
import '../models/results.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref reference;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? currentFirebaseUser = FirebaseAuth.instance.currentUser;

  AuthService(this.reference);

  Future<String?> reloadFirebaseUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    return currentFirebaseUser?.uid;
  }

  Future<Either<HandleError, bool>> isEmailInUse(String email) async {
    if (!email.contains("@") || email.split(".").length < 2) {
      return const Left(HandleError('Invalid Email', code: 'invalid-email'));
    }
    try {
      List<String> users = await firebaseAuth.fetchSignInMethodsForEmail(email);
      if (users.isEmpty) {
        return const Right(false);
      } else {
        return const Right(true);
      }
    } on FirebaseAuthException catch (e) {
      return Left(HandleError(e.message ?? '', code: e.code));
    }
  }

  Future<Either<HandleError, bool>> resetEmailSend(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(HandleError(e.message ?? '', code: e.code));
    }
  }

  Future<Either<HandleError, bool>> signOut() async {
    try {
      await firebaseAuth.signOut();
      currentFirebaseUser = null;
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(HandleError(e.message ?? '', code: e.code));
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final dynamicLinkRepo = reference.read(deepLinkServiceProvider);
      final user = firebaseAuth.currentUser;
      final link = "${AppConfig.dynamicLinkBaseUrl}/?email_verfication=${user?.email}";
      final url = await dynamicLinkRepo.createEmailVerificationLink(Uri.parse(link));
      await firebaseAuth.currentUser?.sendEmailVerification(_actionCodeSettings(url));
    } catch (_) {}
  }

  ActionCodeSettings _actionCodeSettings(Uri dynamicUrl) {
    return ActionCodeSettings(
      androidInstallApp: false,
      iOSBundleId: AppConfig.bundleId,
      androidPackageName: AppConfig.applicationId,
      url: dynamicUrl.toString(),
      handleCodeInApp: true,
    );
  }

  Stream<User?> authStateChanges() {
    return firebaseAuth.authStateChanges();
  }

  Future<Uri> _dynamicLinkParametersShortLink(Uri uri) async {
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
    );

    return parameters.link;
  }

  Future<Either<HandleError, bool>> sendLoginEmailLink(String email) async {
    try {
      final emailInUse = await isEmailInUse(email);
      if (emailInUse.isRight) {
        if (emailInUse.isRight && emailInUse.right) {
          Uri uri = Uri.parse('${AppConfig.dynamicLinkBaseUrl}/user-login');

          final Uri dynamicUrl = await _dynamicLinkParametersShortLink(uri);

          await firebaseAuth.sendSignInLinkToEmail(email: email, actionCodeSettings: _actionCodeSettings(dynamicUrl));

          return const Right(true);
        } else {
          return const Left(HandleError("This user does not exist", code: 'user-does-not-exists'));
        }
      } else {
        final result = emailInUse.left;
        return Left(result);
      }
    } on FirebaseAuthException catch (e) {
      return Left(HandleError(e.code));
    }
  }

  Future<Either<HandleError, HandleSuccess<bool>>> sendEmailRegistrationLink(String email) async {
    try {
      final emailInUse = await isEmailInUse(email);

      if (emailInUse.isRight) {
        final result = emailInUse.right;
        if (!result) {
          Uri uri = Uri.parse('${AppConfig.dynamicLinkBaseUrl}/register');

          final Uri dynamicUrl = await _dynamicLinkParametersShortLink(uri);

          await firebaseAuth.sendSignInLinkToEmail(
            email: email,
            actionCodeSettings: _actionCodeSettings(dynamicUrl),
          );
          return Right(HandleSuccess(result, "Link sent successfully"));
        } else {
          return const Left(HandleError('Email is already in registered'));
        }
      } else {
        final result = emailInUse.left;
        return Left(result);
      }
    } on FirebaseAuthException catch (e) {
      return Left(HandleError(e.code));
    }
  }

  Future<Either<HandleError, User?>> confirmEmailLink({required String email, required String dynamicLink}) async {
    try {
      final emailInUse = await isEmailInUse(email);

      if (emailInUse.isRight) {
        final userCredential = await firebaseAuth.signInWithEmailLink(email: email, emailLink: dynamicLink);
        final user = userCredential.user;
        currentFirebaseUser = user;
        return Right(user);
      } else {
        final result = emailInUse.left;
        return Left(result);
      }
    } on FirebaseAuthException catch (e) {
      return Left(HandleError(e.message ?? "", code: e.code));
    }
  }

  Future<void> deleteCurrentFirebaseUser() async {
    if (firebaseAuth.currentUser != null) {
      await firebaseAuth.currentUser?.delete();
      currentFirebaseUser = null;
      await signOut();
    }
  }
}
