import 'package:flutter/material.dart';

abstract class EditBottomSheet extends StatefulWidget {
  final String? thumbnailUrl;
  final String title;
  final String comment;

  final VoidCallback onTapClose;
  // final Function(String photoName, String journalId, String comment) onTapApply;
  final VoidCallback onTapCancel;

  const EditBottomSheet({
    super.key,
    required this.thumbnailUrl,
    required this.title,
    required this.comment,
    required this.onTapClose,
    required this.onTapCancel,
  });

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    //   return BottomSheet(
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //     backgroundColor: AppColors.white,
    //     builder: (context) {
    //       return SingleChildScrollView(
    //         padding: EdgeInsets.only(
    //           left: 16,
    //           top: 16,
    //           right: 16,
    //           bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
    //         ),
    //         child: Column(
    //           spacing: 16,
    //           children: [
    //             Row(
    //               spacing: 12,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Expanded(
    //                   child: TextLimitInputField(
    //                     controller: titleController,
    //                     hintText: 'Write Title',
    //                     maxLength: 30,
    //                   ),
    //                 ),
    //                 GestureDetector(
    //                   onTap: () {
    //                     widget.onTapClose();
    //                   },
    //                   child: const Icon(
    //                     Icons.close,
    //                     size: 20,
    //                     color: AppColors.gray2,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             AspectRatio(
    //               // TODO: 현재는 고정으로 16:9 비율, 추후 카메라 기능 들어오면 수정
    //               aspectRatio: 16 / 9,
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(10),
    //                   image: DecorationImage(
    //                     image: NetworkImage(widget.thumbnailUrl),
    //                     fit: BoxFit.cover,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Column(
    //               spacing: 12,
    //               children: [
    //                 Row(
    //                   spacing: 12,
    //                   children: [
    //                     const BaseIcon(
    //                       iconColor: AppColors.primary80,
    //                       size: 16,
    //                       iconData: Icons.calendar_month,
    //                     ),
    //                     Text(
    //                       _formattedDateTime(),
    //                       style: AppFonts.smallTextRegular,
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   spacing: 12,
    //                   children: [
    //                     const BaseIcon(
    //                       iconColor: AppColors.secondary100,
    //                       size: 16,
    //                       iconData: Icons.comment,
    //                     ),
    //                     Expanded(
    //                       child: TextLimitInputField(
    //                         controller: commentController,
    //                         hintText: 'Write Comment',
    //                         maxLength: 30,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   children: [
    //                     const BaseIcon(
    //                       iconColor: AppColors.primary80,
    //                       size: 16,
    //                       iconData: Icons.note,
    //                     ),
    //                     const SizedBox(width: 12),
    //                     Expanded(
    //                       child: DropdownMenu<String>(
    //                         controller: journalController,
    //                         inputDecorationTheme: const InputDecorationTheme(
    //                           contentPadding: EdgeInsets.zero,
    //                           border: InputBorder.none,
    //                         ),
    //                         initialSelection:
    //                             widget.journals.isNotEmpty
    //                                 ? widget.journalId
    //                                 : null,
    //                         menuStyle: MenuStyle(
    //                           backgroundColor: WidgetStateProperty.all(
    //                             AppColors.white,
    //                           ),
    //                           padding: WidgetStateProperty.all(EdgeInsets.zero),
    //                           elevation: WidgetStateProperty.all(2),
    //                         ),
    //                         onSelected: (value) {
    //                           _journalId = value!;
    //                         },
    //                         textStyle: AppFonts.smallTextRegular,
    //                         dropdownMenuEntries:
    //                             widget.journals.isEmpty
    //                                 ? []
    //                                 : List.generate(widget.journals.length, (
    //                                   int index,
    //                                 ) {
    //                                   return DropdownMenuEntry(
    //                                     label: widget.journals[index].name,
    //                                     value: widget.journals[index].id,
    //                                   );
    //                                 }),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             Row(
    //               spacing: 12,
    //               children: [
    //                 Expanded(
    //                   child: BaseIconButton(
    //                     buttonType: ButtonType.small,
    //                     buttonColor: AppColors.primary100,
    //                     iconName: Icons.edit,
    //                     buttonName: 'Apply',
    //                     onClick: () {
    //                       widget.onTapApply(
    //                         titleController.text,
    //                         _journalId,
    //                         commentController.text,
    //                       );
    //                     },
    //                   ),
    //                 ),
    //                 Expanded(
    //                   child: BaseIconButton(
    //                     buttonType: ButtonType.small,
    //                     buttonColor: AppColors.warning,
    //                     iconName: Icons.cancel,
    //                     buttonName: 'Cancel',
    //                     onClick: widget.onTapCancel,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //     onClosing: widget.onClosing ?? () {},
    //   );
  }
}
