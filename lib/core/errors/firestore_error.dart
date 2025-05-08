enum FirestoreError implements Exception {
  notFoundError('데이터가 존재하지 않습니다.'),
  timeOutError('timeout');

  final String message;

  const FirestoreError(this.message);
}
