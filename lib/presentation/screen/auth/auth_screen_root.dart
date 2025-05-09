import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/screen/auth/auth_action.dart';
import 'package:photopin/presentation/screen/auth/auth_screen.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';

class AuthScreenRoot extends StatefulWidget {
  final AuthViewModel authViewModel;
  const AuthScreenRoot({super.key, required this.authViewModel});

  @override
  State<AuthScreenRoot> createState() => _AuthScreenRootState();
}

class _AuthScreenRootState extends State<AuthScreenRoot> {
  StreamSubscription? _errorSubscription;

  @override
  void initState() {
    super.initState();
    _errorSubscription = widget.authViewModel.errorStream.listen((error) {
      if (mounted) {
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.warningBackground, // 필요에 따라 색상 지정
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _errorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.authViewModel,
      builder: (context, _) {
        return AuthScreen(
          state: widget.authViewModel.state,
          onAction: (action) {
            switch (action) {
              case Login():
                widget.authViewModel.action(action);
              case Logout():
                widget.authViewModel.action(action);
              case OnClick():
              //TODO : 화면 이동 로직 추가
            }
          },
        );
      },
    );
  }
}
