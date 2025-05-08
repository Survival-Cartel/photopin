import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photopin/core/errors/firestore_error.dart';

///```
/// [firestoreTimeOut] 의 인자로 실행할 쿼리문을 전달.
/// 예)
/// final QuerySnapshot<PhotoDto> snapshot =
///   await FirestoreTimeout.firestoreTimeOut<PhotoDto>(
///   photoStore.where('id', isEqualTo: id).get(),
/// );
/// ```
abstract class FirestoreTimeout<T> {
  static Future<QuerySnapshot<T>> firestoreTimeOut<T>(
    Future<QuerySnapshot<T>> query, {
    int sec = 8,
  }) {
    return query.timeout(
      Duration(seconds: sec),
      onTimeout: () => throw FirestoreError.timeOutError,
    );
  }
}
