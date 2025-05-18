enum ActionType {
  journalCreate('저널이 생성되었습니다.'),
  journalDelete('저널이 삭제되었습니다.'),
  journalUpdate('저널이 수정되었습니다.'),
  photoSave('사진이 저장되었습니다.'),
  photoDelete('사진이 삭제되었습니다.'),
  photoUpdate('사진 정보가 변경되었습니다.'),
  photoInJournal('사진이 저널에 추가되었습니다.');

  final String message;

  const ActionType(this.message);
}
