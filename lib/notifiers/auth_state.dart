import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplues/models/user.dart';
import 'package:shareplues/repositories/user_repository.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<User?> {
  final Ref reference;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController handleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isLogin = false;

  final GlobalKey<FormState> authformKey = GlobalKey<FormState>();

  UserRepository get userRepo => reference.read(userRepositoryProvider);

  User get initialUserData => User(
        uid: '',
        name: nameController.text,
        handle: handleController.text,
        email: emailController.text,
        profileImageUrl: '',
        active: true,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

  AuthStateNotifier(this.reference) : super(null) {
    userRepo.currentUserNotifier.addListener(_userListener);
  }

  void _userListener() {
    state = userRepo.currentUser;
  }

  @override
  void dispose() {
    super.dispose();
    userRepo.currentUserNotifier.removeListener(_userListener);
  }

  void createAccount() async {
    final validate = authformKey.currentState?.validate();
    if (validate == true) {
      final register = await userRepo.registerWithEmail(initialUserData);

      if (register.isRight) {
        debugPrint('email sent');
      } else {
        final errorTile = register.left.getTitle;
        final errorMessage = register.left.getMessage;

        debugPrint('error $errorTile $errorMessage');
      }
    }
  }

  void loginWithEmail() async {
    final validate = authformKey.currentState?.validate();
    if (validate == true) {
      final login = await userRepo.sendLoginEmailLink(emailController.text.trim());

      if (login.isRight) {
        debugPrint('email sent');
      } else {
        final errorTile = login.left.getTitle;
        final errorMessage = login.left.getMessage;
        debugPrint('error $errorTile $errorMessage');
      }
    }
  }

  void checkUserHandle() async {
    final getUsername = await userRepo.getEmailFromUser(handleController.text.trim());

    if (getUsername.isRight) {
      final emails = getUsername.right;
      print(emails);
    }
  }

  void switchTo() {
    isLogin = !isLogin;
  }
}
