abstract interface class FirebaseMessagingDataSource {
  Future<String?> fetchToken();

  Stream<String> tokenRefreshStream();
}
