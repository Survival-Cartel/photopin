import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/model/user_model.dart';
import '../dto/user_dto.dart';

extension UserMapper on UserDto {
  UserModel toModel() {
    return UserModel(
      id: id ?? 'N/A',
      email: email ?? 'N/A',
      profileImg: profileImg ?? 'N/A',
      displayName: displayName ?? 'N/A',
    );
  }
}

extension AuthMapper on User {
  UserDto toDto() {
    return UserDto(
      id: uid,
      email: email,
      profileImg: photoURL,
      displayName: displayName,
    );
  }

  UserModel toModel() {
    return UserModel(
      id: uid,
      email: email ?? 'N/A',
      profileImg: photoURL ?? 'N/A',
      displayName: displayName ?? 'N/A',
    );
  }
}

extension UserModelMapper on UserModel {
  UserDto toDto() {
    return UserDto(
      id: id,
      email: email,
      profileImg: profileImg,
      displayName: displayName,
    );
  }
}
