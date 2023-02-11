import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplues/models/user.dart';
import 'package:shareplues/repositories/user_repository.dart';

enum AuthState { idle, loading, loadingHandle, loadedHandle, loaded }

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref reference;

  TextEditingController nameController = TextEditingController();
  TextEditingController handleController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> authformKey = GlobalKey<FormState>();

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

  AuthStateNotifier(this.reference) : super(AuthState.idle);

  void createAccount() async {
    final validate = authformKey.currentState?.validate();
    if (validate == true && [AuthState.loaded].contains(state)) {
      state = AuthState.loading;
      final register = await userRepo.registerWithEmail(initialUserData);
      state = AuthState.idle;

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
    if (validate == true && [AuthState.loaded].contains(state)) {
      state = AuthState.loading;
      final login = await userRepo.sendLoginEmailLink(emailController.text.trim());
      state = AuthState.idle;

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
    if ([AuthState.loaded].contains(state)) {
      state = AuthState.loadingHandle;
      final getUsername = await userRepo.getEmailFromUser(handleController.text.trim());
      state = AuthState.loaded;

      if (getUsername.isRight) {
        final emails = getUsername.right;
        if (emails.isEmpty) {
          state = AuthState.loadedHandle;
        }
      }
    }
  }
}
