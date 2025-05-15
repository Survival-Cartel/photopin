import 'package:photopin/core/service/push_service.dart';
import 'package:photopin/fcm/data/repository/token_repository.dart';

class LinkAccessNotificationUseCase {
  final TokenRepository _tokenRepository;
  final PushService _pushService;

  const LinkAccessNotificationUseCase({
    required TokenRepository tokenRepository,
    required PushService pushService,
  })
      : _tokenRepository = tokenRepository,
        _pushService = pushService;

  Future<bool> call({required String userId, required String journalId}) async {
    final token = await _tokenRepository.fetchToken(userId);
    if (token == null) return false;

    final success = await _pushService.sendPush(
        token: token,
        title: '딥링크 접근 알림',
        body: '누군가 당신의 저널에 접근했습니다.'
    );

    return success;
  }
}
