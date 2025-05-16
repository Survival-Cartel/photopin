import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photopin/fcm/data/repository/token_repository.dart';

class TokenRepositoryImpl implements TokenRepository {
  final FirebaseFirestore _firebaseFirestore;

  TokenRepositoryImpl(this._firebaseFirestore);

  @override
  Future<String?> fetchToken(String userId) async {
    final DocumentSnapshot snap =
        await _firebaseFirestore.collection('tokens').doc(userId).get();

    final Map<String, dynamic> maps = snap.data() as Map<String, dynamic>;

    return maps['token'];
  }

  @override
  Future<void> saveToken(String userId, String token) async {
    await _firebaseFirestore.collection('tokens').doc(userId).set(
        {'token': token});
  }
}
