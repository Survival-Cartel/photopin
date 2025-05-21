import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/banner_ad.dart';
import 'package:photopin/presentation/component/journal_card.dart';
import 'package:photopin/presentation/component/main_icon_card.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_state.dart';

class HomeScreen extends StatelessWidget {
  final HomeState state;
  final void Function(HomeAction) onAction;

  const HomeScreen({super.key, required this.state, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 17),
                    Text(
                      'Hello, ${state.currentUser.displayName}!',
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
                            onTap: () {
                              onAction(HomeAction.cameraClick());
                            },
                            title: 'New Photo',
                            iconData: Icons.camera_alt,
                            iconColor: AppColors.primary100,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MainIconCard(
                            onTap: () {
                              onAction(HomeAction.newJournalClick());
                            },
                            title: 'New Journal',
                            iconData: Icons.auto_stories,
                            iconColor: AppColors.secondary100,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MainIconCard(
                            onTap: () {
                              onAction(HomeAction.shareClick());
                            },
                            title: 'Share',
                            iconData: Icons.share,
                            iconColor: AppColors.primary100,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Row(
                    //   children: [
                    //     Text('Recent Activity', style: AppFonts.largeTextBold),
                    //     const Spacer(),
                    //     GestureDetector(
                    //       onTap: () {
                    //         onAction(HomeAction.seeAllClick());
                    //       },
                    //       child: Text(
                    //         'See all',
                    //         style: AppFonts.smallTextRegular.copyWith(
                    //           color: AppColors.primary100,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 12),
                    // RecentActivityTile(
                    //   title: 'Link shared: Paris Trip',
                    //   dateTime: DateTime.now(),
                    //   onTap: () {
                    //     onAction(HomeAction.recentActivityClick());
                    //   },
                    //   iconData: CupertinoIcons.link,
                    // ),
                    BannerAd(path: 'assets/images/gupae.png'),
                    const SizedBox(height: 24),
                    Text('Your Journals', style: AppFonts.largeTextBold),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.journals.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 18);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          String? thumbnailUrl =
                              state
                                          .photoMap[state.journals[index].id]
                                          ?.isNotEmpty ==
                                      true
                                  ? state
                                      .photoMap[state.journals[index].id]!
                                      .first
                                      .imageUrl
                                  : null;
                          int? photoCount =
                              state.photoMap[state.journals[index].id]?.length;
                          return JournalCard(
                            imageUrl: thumbnailUrl,
                            journal: state.journals[index],
                            photoCount: photoCount ?? 0,
                            onTap:
                                (String journalId) => onAction(
                                  HomeAction.myJounalClick(journalId),
                                ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
