import 'package:photopin/core/data/repository.dart';
import 'package:photopin/user/data/dto/user_dto.dart';
import 'package:photopin/user/domain/model/user_model.dart';

abstract interface class UserRepository
    implements Repository<UserModel, String, UserDto> {}
