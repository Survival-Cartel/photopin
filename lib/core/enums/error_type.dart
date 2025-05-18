enum ErrorType implements Exception {
  journalCreate('저널이 생성에 실패하였습니다.'),
  journalDelete('저널 삭제에 실패하였습니다.'),
  journalUpdate('저널 수정이 실패하였습니다.'),
  photoSave('사진이 저장에 실패하였습니다.'),
  photoDelete('사진 삭제에 실패하였습니다.'),
  photoUpdate('사진 정보가 변경에 실패하였습니다.'),
  photoInJournal('사진이 저널 추가에 실패하였습니다.');

  final String message;

  const ErrorType(this.message);
}
