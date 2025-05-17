import 'package:photopin/fcm/data/repository/token_repository.dart';

class SaveTokenUseCase {
  final TokenRepository _tokenRepository;

  SaveTokenUseCase(this._tokenRepository);

  Future<void> execute(String userId, String token) {
    return _tokenRepository.saveToken(userId, token);
  }
}
