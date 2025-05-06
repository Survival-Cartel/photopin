import '../../domain/model/user_model.dart';
import '../dto/user_dto.dart';

extension UserMapper on UserDto {
  UserModel toModel() {
    return UserModel(
      id: id ?? 'N/A',
      email: email ?? 'N/A',
      profile_img: profile_img ?? 'N/A',
      displayName: displayName ?? 'N/A',
    );
  }
}
