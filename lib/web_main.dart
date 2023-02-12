import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR apiKey",
        authDomain: "YOUR authDomain",
        projectId: "YOUR projectId",
        storageBucket: "YOUR storageBucket",
        messagingSenderId: "YOUR messagingSenderId",
        appId: "YOUR appId",
        measurementId: "YOUR measurementId",
      ),
    );
    runApp(const ProviderScope(
      child: SharepluesApp(),
    ));
  }, (error, stack) => print(error));
}
