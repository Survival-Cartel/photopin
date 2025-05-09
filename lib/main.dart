import 'package:flutter/material.dart';
import 'package:photopin/presentation/screen/home/home_screen.dart';
import 'package:photopin/user/domain/model/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
        userId: UserModel(
          id: '001',
          email: 'Roy@@',
          profileImg: '',
          displayName: 'roy',
        ), // 테스트용 ID
      ),
    );
  }
}
