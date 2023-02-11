// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplues/constants/storage_keys.dart';
import 'package:shareplues/models/results.dart';
import 'package:shareplues/models/user.dart';
import 'package:shareplues/services/auth_service.dart';
import 'package:shareplues/services/local_storage.dart';

import '../utils/validations.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref);
});

class UserRepository {
  late Ref reference;
  UserRepository(this.reference) {
    listenToAuthChanges();
  }

  final userCollection = FirebaseFirestore.instance.collection('users');
  final handleCollection = FirebaseFirestore.instance.collection('handles');

  AuthService get _authService => reference.read(authServiceProvider);
  LocalStorageService get _localStorageService => reference.read(localStorageServiceProvider);

  ValueNotifier<User?> currentUserNotifier = ValueNotifier<User?>(null);

  StreamSubscription? _currentUserSubscription;
  StreamSubscription? _authSubscription;

  String? localFirebaseUID;

  bool? get isVerifiedEmail => _authService.firebaseAuth.currentUser?.emailVerified;

  User? get currentUser {
    return currentUserNotifier.value;
  }

  String? get currentUserUID {
    return _authService.currentFirebaseUser?.uid ?? localFirebaseUID;
  }

  bool get userExist {
    return _authService.currentFirebaseUser != null;
  }

  set setCurrentUser(User user) {
    currentUserNotifier.value = user;
    currentUserNotifier.notifyListeners();
  }

  Future<String?> reloadCurrentFirebaseUser() async {
    try {
      return await _authService.reloadFirebaseUser();
    } on Exception catch (_) {}
    return null;
  }

  Future<void> listenToAuthChanges() async {
    try {
      _clearSubscription();
      _authSubscription = _authService.authStateChanges().listen((firebaseUser) async {
        if (firebaseUser != null) {
          localFirebaseUID = firebaseUser.uid;
          await getCurrentUser(firebaseUser.uid);
        } else {}
      });
    } catch (_) {}
  }

  void _clearSubscription() {
    _currentUserSubscription?.cancel();
    _authSubscription?.cancel();
  }

  Future<Either<HandleError, User>> getUser(String uid) async {
    try {
      final userSnapshot = await userCollection.doc(uid).get();
      if (userSnapshot.exists) {
        final user = User.fromMap(userSnapshot.data() as Map<String, dynamic>);
        return Right(user);
      } else {
        return const Left(HandleError("Failed to get user"));
      }
    } catch (e) {
      return Left(HandleError("$e"));
    }
  }

  Future<User?> getCurrentUser(String uid) async {
    try {
      final userSnapshot = await userCollection.doc(uid).get();
      User? user;
      if (userSnapshot.exists) {
        user = User.fromMap(userSnapshot.data() as Map<String, dynamic>);

        if (currentUser?.active == false && user.active) {
          triggerUserActiveState(true, DateTime.now());
        }

        setCurrentUser = user;

        if (_currentUserSubscription == null) {
          listenToCurrentUser(user.uid).listen((_) {});
        }

        if (!(currentUser?.active == true)) {
          triggerUserActiveState(true, DateTime.now());
        }
      }
      return user;
    } on FirebaseException catch (_) {
      return null;
    }
  }

  Stream<User?> listenToCurrentUser(String uid) async* {
    try {
      _clearSubscription();
      final userSnapshot = userCollection.doc(uid).snapshots();
      _currentUserSubscription = userSnapshot.listen((docSnap) async {
        if (docSnap.exists) {
          final user = User.fromMap(docSnap.data() as Map<String, dynamic>);
          setCurrentUser = user;
        }
      });
    } catch (_) {}
    yield currentUser;
  }

  Future<void> triggerUserActiveState(bool state, DateTime lastActive) async {
    if (!userExist) return;
    try {
      await userCollection.doc(currentUserUID).update({
        'active': state,
        'updatedAt': lastActive.millisecondsSinceEpoch,
      });
    } catch (_) {}
  }

  Future<Either<HandleError, List<String>>> getEmailFromUser(String query) async {
    try {
      final usernames = await handleCollection.where("handle", isEqualTo: query).limit(1).get(
            const GetOptions(source: Source.server),
          );
      if (usernames.docs.isNotEmpty) {
        final emails = usernames.docs.map((e) => e.data()["email"] as String).toList();
        return Right(emails);
      } else {
        return const Right(<String>[]);
      }
    } catch (e) {
      return Left(HandleError(e.toString()));
    }
  }

  Future<Either<HandleError, String>> sendLoginEmailLink(String emailOrUsername) async {
    try {
      String authenticatedEmail = emailOrUsername;
      final isEmail = AppValidations.vaidatedEmail(emailOrUsername) == null;
      final isUsername = AppValidations.validUsername(emailOrUsername) == null;

      if (isEmail && !isUsername) {
        final sendLoginEmailLink = await _authService.sendLoginEmailLink(emailOrUsername);
        if (sendLoginEmailLink.isRight && sendLoginEmailLink.right) {
          _localStorageService.storedData<String>(AppStorageKey.STORAGE_EMAIL_KEY, emailOrUsername);

          return Right(authenticatedEmail);
        } else {
          return Left(HandleError(sendLoginEmailLink.left.getMessage, code: sendLoginEmailLink.left.code));
        }
      } else if (isUsername && !isEmail) {
        final usersnames = await getEmailFromUser(emailOrUsername);
        if (usersnames.isRight && usersnames.right.isNotEmpty) {
          final email = usersnames.right.first;
          authenticatedEmail = email;

          final sendLoginEmailLink = await _authService.sendLoginEmailLink(email);
          if (sendLoginEmailLink.isRight && sendLoginEmailLink.right) {
            _localStorageService.storedData<String>(AppStorageKey.STORAGE_EMAIL_KEY, email);

            return Right(authenticatedEmail);
          } else {
            return Left(HandleError(sendLoginEmailLink.left.getMessage, code: sendLoginEmailLink.left.code));
          }
        }
      }
      return const Left(HandleError("Username does not exist", code: "username-not-found"));
    } catch (e) {
      return Left(HandleError(e.toString()));
    }
  }

  Future<Either<HandleError, User>> confirmEmailLink(String email, String link, {User? user}) async {
    try {
      final confirmEmailLink = await _authService.confirmEmailLink(email: email, dynamicLink: link);

      if (confirmEmailLink.isRight) {
        if (confirmEmailLink.right == null) {
          return const Left(HandleError("Failed to confirm link"));
        }
        final getUser = await getCurrentUser(confirmEmailLink.right!.uid);
        if (getUser != null) {
          return Right(getUser);
        } else {
          try {
            if (user == null) {
              return const Left(HandleError("An error occured"));
            }

            final firebaseUser = confirmEmailLink.right;
            WriteBatch batch = FirebaseFirestore.instance.batch();

            final newUser = user.copyWith(uid: firebaseUser?.uid);
            final userDoc = userCollection.doc(firebaseUser?.uid);
            final usernameDoc = handleCollection.doc(firebaseUser?.uid);

            batch.set(userDoc, newUser.toMap());

            batch.set(usernameDoc, {
              "uid": newUser.uid,
              "email": newUser.email,
              "handle": newUser.handle,
              "createdAt": newUser.createdAt,
              "updatedAt": newUser.updatedAt,
              "canEditAt": DateTime.now().add(const Duration(days: 60)).millisecondsSinceEpoch,
            });
            await batch.commit();

            final getUser = await getCurrentUser(firebaseUser!.uid);
            if (getUser != null) {
              return Right(getUser);
            } else {
              return const Left(HandleError("Failed to get user"));
            }
          } on FirebaseException catch (e) {
            await _authService.deleteCurrentFirebaseUser();
            currentUserNotifier.value = null;
            return Left(HandleError("Registration failed", code: e.code));
          }
        }
      } else {
        return Left(confirmEmailLink.left);
      }
    } catch (e) {
      return Left(HandleError(e.toString()));
    }
  }

  Future<Either<HandleError, bool>> registerWithEmail(User user) async {
    _localStorageService.deleteLocalStoredData(AppStorageKey.STORAGE_USER_REGISTRATION_DETAILS);
    final auth = await _authService.sendEmailRegistrationLink(user.email);

    if (auth.isRight) {
      final result = auth.right;
      await _localStorageService.storedData<User>(AppStorageKey.STORAGE_USER_REGISTRATION_DETAILS, user);
      return Right(result.data);
    } else {
      final result = auth.left;
      return Left(result);
    }
  }

  Future<bool> logout() async {
    try {
      await _localStorageService.deleteLocalStoredData(AppStorageKey.STORAGE_EMAIL_KEY);
      await _localStorageService.deleteLocalStoredData(AppStorageKey.STORAGE_USER_REGISTRATION_DETAILS);

      _authService.signOut();
      _authSubscription?.cancel();
      _currentUserSubscription?.cancel();
      currentUserNotifier.value = null;
      localFirebaseUID = null;
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }
}
