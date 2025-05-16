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
  }
}
