import 'package:flutter/material.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/base_icon.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/presentation/component/base_icon_button.dart';

/// showModalBottomSheet() 함수를 사용하여 띄울 수 있는 모달 바텀 시트입니다.
/// 기본적으로 showModalBottomSheet의 isDismissible 속성을 반드시 false로 설정해야 [onClosing]과 [onTapClose] 호출이 보장됩니다.
/// [onClosing] 인자는 바텀 시트가 닫히기 전, 어떤 동작을 해야할 때 사용되며 [onTapClose] 인자는 [onClosing]이 호출된 후에 실행됩니다.
class MapBottomSheet extends StatefulWidget {
  final String title;
  final String imageUrl;
  final DateTime dateTime;
  final String location;
  final String comment;

  final VoidCallback onTapClose;
  final VoidCallback onTapEdit;
  final VoidCallback onTapShare;
  final VoidCallback? onClosing;

  const MapBottomSheet({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.dateTime,
    required this.location,
    required this.comment,
    required this.onTapClose,
    required this.onTapEdit,
    required this.onTapShare,
    this.onClosing,
  });

  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  String _formattedDateTime() =>
      '${widget.dateTime.formDateString()}, ${widget.dateTime.year} • ${widget.dateTime.hour}:${widget.dateTime.minute} ${widget.dateTime.formMeridiem()}';

  @override
  void dispose() {
    widget.onClosing?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.white,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            top: 16,
            right: 16,
            bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
            spacing: 16,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: AppFonts.mediumTextBold.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      widget.onTapClose();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.gray2,
                    ),
                  ),
                ],
              ),
              AspectRatio(
                // TODO: 현재는 고정으로 16:9 비율, 추후 카메라 기능 들어오면 수정
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                spacing: 12,
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      const BaseIcon(
                        iconColor: AppColors.primary80,
                        size: 16,
                        iconData: Icons.calendar_month,
                      ),
                      Text(
                        _formattedDateTime(),
                        style: AppFonts.smallTextRegular,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      const BaseIcon(
                        iconColor: AppColors.secondary100,
                        size: 16,
                        iconData: Icons.location_on,
                      ),
                      Text(widget.location, style: AppFonts.smallTextRegular),
                    ],
                  ),
                  Row(
                    children: [
                      const BaseIcon(
                        iconColor: AppColors.primary80,
                        size: 16,
                        iconData: Icons.comment,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.comment,
                          softWrap: true,
                          style: AppFonts.smallTextRegular,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: BaseIconButton(
                      buttonType: ButtonType.small,
                      buttonColor: AppColors.primary100,
                      iconName: Icons.edit,
                      buttonName: 'Edit',
                      onClick: widget.onTapEdit,
                    ),
                  ),
                  Expanded(
                    child: BaseIconButton(
                      buttonType: ButtonType.small,
                      buttonColor: AppColors.secondary100,
                      iconName: Icons.share,
                      buttonName: 'Share',
                      onClick: widget.onTapShare,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      onClosing: () {},
    );
  }
}
