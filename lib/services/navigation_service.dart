// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/navigation_paths.dart';
import '../screens/dashboard/dashboard.dart';

final navigationServiceProvider = Provider<NavigationService>((ref) {
  return NavigationService(ref);
});

class NavigationService {
  late Ref reference;

  NavigationService(this.reference);

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> tabNavigatorKey = GlobalKey<NavigatorState>();

  ValueNotifier<int> currentPathIndex = ValueNotifier<int>(0);

  String determineHomePath() {
    return NavigationPath.authPath;
  }

  GoRouter get router => GoRouter(
        navigatorKey: navigatorKey,
        initialLocation: NavigationPath.authPath,
        errorBuilder: (_, __) {
          return const Scaffold();
        },
        routes: [
          ShellRoute(
            navigatorKey: tabNavigatorKey,
            pageBuilder: (context, state, child) {
              return NoTransitionPage(
                child: Dashboard(body: child),
              );
            },
            routes: [
              GoRoute(
                path: NavigationPath.authPath,
                pageBuilder: (_, state) {
                  return const NoTransitionPage(
                    child: Scaffold(),
                  );
                },
              ),
            ],
          ),
        ],
      );
}

String getPath(String path, {Map<String, dynamic>? queryParameters}) {
  return Uri(path: path, queryParameters: queryParameters).toString();
}
