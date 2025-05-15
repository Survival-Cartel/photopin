import 'package:flutter/material.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/base_button.dart';

class SelectJournalModal extends StatefulWidget {
  final List<JournalModel> journals;
  final void Function(String journalId) onApply;
  const SelectJournalModal({
    super.key,
    required this.journals,
    required this.onApply,
  });

  @override
  State<SelectJournalModal> createState() => _SelectJournalModalState();
}

class _SelectJournalModalState extends State<SelectJournalModal> {
  String journalId = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Text('비교할 Journal 을 골라주세요.', style: AppFonts.normalTextRegular),
      content: SizedBox(
        height: 180,
        child: Column(
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu(
              onSelected: (value) {
                setState(() {
                  journalId = value ?? '';
                });
              },
              initialSelection: journalId,
              dropdownMenuEntries: [
                const DropdownMenuEntry(label: '선택 없음', value: ''),
                ...List.generate(widget.journals.length, (index) {
                  return DropdownMenuEntry(
                    label: widget.journals[index].name,
                    value: widget.journals[index].id,
                  );
                }),
              ],
            ),
            BaseButton(
              buttonName: '선택하기',
              onClick: () {
                widget.onApply(journalId);
              },
              buttonType: ButtonType.medium,
            ),
          ],
        ),
      ),
    );
  }
}
