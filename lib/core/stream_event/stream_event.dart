import 'package:photopin/core/enums/action_type.dart';
import 'package:photopin/core/enums/error_type.dart';

sealed class StreamEvent {
  const factory StreamEvent.success(ActionType success) = Success;

  const factory StreamEvent.error(ErrorType error) = Error;
}

class Success implements StreamEvent {
  final ActionType success;

  const Success(this.success);
}

class Error implements StreamEvent {
  final ErrorType error;

  const Error(this.error);
}
