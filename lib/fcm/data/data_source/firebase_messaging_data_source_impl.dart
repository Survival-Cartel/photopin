import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:photopin/fcm/data/data_source/firebase_messaging_data_source.dart';

class FirebaseMessagingDataSourceImpl implements FirebaseMessagingDataSource {
  final FirebaseMessaging _firebaseMessaging;

  FirebaseMessagingDataSourceImpl(this._firebaseMessaging);

  @override
  Future<String?> fetchToken() {
    return _firebaseMessaging.getToken();
  }

  @override
  Stream<String> tokenRefreshStream() {
    return _firebaseMessaging.onTokenRefresh;
  }
}
