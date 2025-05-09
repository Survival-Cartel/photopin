import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/main_icon_card.dart';
import 'package:photopin/presentation/component/recent_activity_tile.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel userId;

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 17),
            Text(
              'Hello, ${userId.displayName}!',
              style: AppFonts.headerTextBold.copyWith(
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Continue your travel journeys',
              style: AppFonts.mediumTextRegular.copyWith(
                color: AppColors.gray2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: MainIconCard(
                    onTap: () => print('New Photo'),
                    title: 'New Photo',
                    iconData: Icons.camera_alt,
                    iconColor: AppColors.primary100,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MainIconCard(
                    onTap: () => print('New Journal'),
                    title: 'New Journal',
                    iconData: Icons.auto_stories,
                    iconColor: AppColors.secondary100,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MainIconCard(
                    onTap: () => print('Share'),
                    title: 'Share',
                    iconData: Icons.share,
                    iconColor: AppColors.primary100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text('Recent Activity', style: AppFonts.largeTextBold),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    print('See All tapped');
                  },
                  child: Text(
                    'See All',
                    style: AppFonts.smallTextRegular.copyWith(
                      color: AppColors.primary100,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RecentActivityTile(
              title: 'Link shared: Paris Trip',
              dateTime: DateTime.now(),
              onTap: () {
                print('viewmodel 만들고 수정하기');
              },
              iconData: CupertinoIcons.link,
            ),
          ],
        ),
      ),
    );
  }
}
