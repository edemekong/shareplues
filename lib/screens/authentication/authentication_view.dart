import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shareplues/notifiers/auth_state.dart';

class AuthenticationView extends ConsumerStatefulWidget {
  const AuthenticationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends ConsumerState<AuthenticationView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authStateProvider);
    final stateRead = ref.read(authStateProvider.notifier);
    ref.listen(authStateProvider, (a, b) {
      print('Hello ${a}');
      print('Hello ${b}');
    });

    return Form(
      key: stateRead.authformKey,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  ' Enter register credentials to continue registration',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: stateRead.handleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter handle',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stateRead.nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Full Name',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stateRead.emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Email',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: stateRead.createAccount,
                  child: const Text('Continue'),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: stateRead.switchTo,
                  child: Builder(builder: (context) {
                    // if (stateWatch.isLogin) {
                    //   return Row(
                    //     children: [
                    //       Text(
                    //         'New User?',
                    //         style: Theme.of(context).textTheme.bodyText2,
                    //       ),
                    //       const SizedBox(width: 8),
                    //       Text(
                    //         'Register',
                    //         style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //       ),
                    //     ],
                    //   );
                    // }
                    return Row(
                      children: [
                        Text(
                          'Already have an account?',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
