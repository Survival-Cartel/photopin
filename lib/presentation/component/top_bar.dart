import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';

import '../../core/styles/app_font.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? profileImg;
  final VoidCallback onNotificationTap;

  const TopBar({super.key, this.profileImg, required this.onNotificationTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: Text(
        'Photopin',
        style: AppFonts.mediumTextBold.copyWith(color: AppColors.primary100),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: onNotificationTap,
          icon: const Icon(Icons.notifications_none),
          color: AppColors.gray2,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child:
              profileImg != null
                  ? Container(
                    key: const Key('profileImgContainer'),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(profileImg!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                  : const Icon(Icons.person, size: 24, color: AppColors.gray2),
        ),
      ],
    );
  }
}
