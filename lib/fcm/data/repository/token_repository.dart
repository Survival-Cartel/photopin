abstract interface class TokenRepository {
  Future<String?> fetchToken(String userId);

  Future<void> saveToken(String userId, String token);
}
