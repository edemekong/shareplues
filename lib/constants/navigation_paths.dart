import 'package:flutter/material.dart';

@immutable
class NavigationPath {
  const NavigationPath._();
  static const String dashboardPath = '/dashboard';
  static const String feedPath = '/news_feed';
  static const String authPath = '/authentication';
  static const String profilePath = '/profile';
  static const String chatPath = '/chat';
  static const String messagePath = '/message';
  static const String postPath = '/post';
}
