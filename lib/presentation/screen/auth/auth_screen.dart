import 'package:flutter/material.dart';
import 'package:photopin/presentation/screen/auth/auth_action.dart';
import 'package:photopin/presentation/screen/auth/auth_state.dart';

class AuthScreen extends StatelessWidget {
  final AuthState state;
  final void Function(AuthAction) onAction;
  const AuthScreen({super.key, required this.state, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !state.isLoading
                ? ElevatedButton(
                  child: const Text('login'),
                  onPressed: () {
                    onAction(AuthAction.login());
                    onAction(AuthAction.onClick());
                  },
                )
                : const CircularProgressIndicator(),
            Text(state.email),
            ElevatedButton(
              child: const Text('logout'),
              onPressed: () async {
                onAction(AuthAction.logout());
              },
            ),
          ],
        ),
      ),
    );
  }
}
