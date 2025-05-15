abstract interface class TokenRepository {
  Future<String?> fetchToken(String userId);
}
