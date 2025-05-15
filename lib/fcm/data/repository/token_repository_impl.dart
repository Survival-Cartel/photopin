import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photopin/fcm/data/repository/token_repository.dart';

class TokenRepositoryImpl implements TokenRepository {
  final FirebaseFirestore _firebaseFirestore;

  TokenRepositoryImpl(this._firebaseFirestore);

  @override
  Future<String?> fetchToken(String userId) async {
    final snap =
        await _firebaseFirestore.collection('tokens').doc(userId).get();
    return snap.data()?['token'] as String?;
  }
}
