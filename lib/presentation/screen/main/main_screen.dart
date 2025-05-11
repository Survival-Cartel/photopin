import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/presentation/component/bottom_bar.dart';
import 'package:photopin/presentation/component/top_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      // 현재 로그인한 사용자 ID 가져오기
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        // 로그인 안 된 경우 처리
        return;
      }

      // Firestore에서 사용자 문서 가져오기
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();

      // 문서가 존재하고 profileImg 필드가 있는지 확인
      if (userDoc.exists && userDoc.data() != null) {
        final userData = userDoc.data() as Map<String, dynamic>;

        // profileImg가 있고 빈 문자열이 아닌 경우에만 상태 업데이트
        final profileImg = userData['profileImg'] as String?;
        if (mounted && profileImg != null && profileImg.isNotEmpty) {
          setState(() {
            _profileImageUrl = profileImg;
          });
        }
      }
    } catch (e) {
      debugPrint('프로필 이미지 로드 중 오류 발생: $e');
    }
  }

  void changeTab(int index) {
    widget.navigationShell.goBranch(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // profileImg 값이 null이거나 빈 문자열인 경우 null을 전달하여 기본 아이콘이 표시되도록 함
    final String? profileImgToDisplay =
        (_profileImageUrl == null || _profileImageUrl!.isEmpty)
            ? null
            : _profileImageUrl;

    return Scaffold(
      appBar: TopBar(profileImg: profileImgToDisplay, onNotificationTap: () {}),
      body: widget.navigationShell,
      bottomSheet: BottomBar(
        selectedIndex: _selectedIndex,
        changeTab: changeTab,
      ),
    );
  }
}
