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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/trip.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        child: Container(
          color: Colors.black.withValues(alpha: 0.4),
          child: Center(
            child: Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/photopin.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 로딩 상태에 따른 조건부 렌더링
                    !state.isLoading
                        ? ElevatedButton.icon(
                          icon: Image.asset(
                            'assets/images/google_logo.webp',
                            height: 24,
                          ),
                          label: const Text('Continue with Google'),
                          onPressed: () {
                            onAction(AuthAction.login());
                            onAction(AuthAction.onClick());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        )
                        : const CircularProgressIndicator(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
