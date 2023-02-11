import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplues/models/user.dart';

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);
}
