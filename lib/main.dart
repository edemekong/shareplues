import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplues/services/navigation_service.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const ProviderScope(
      child: SharepluesApp(),
    ));
  }, (error, stack) => print(error));
}

class SharepluesApp extends ConsumerWidget {
  const SharepluesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(navigationServiceProvider);

    return MaterialApp.router(
      title: 'Shareplues',
      builder: (context, widget) => Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => widget!,
          ),
        ],
      ),
      routerConfig: state.router,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
      },
    );
  }
}
