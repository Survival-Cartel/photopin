import 'package:photopin/core/enums/stream_event_error.dart';
import 'package:photopin/core/enums/stream_event_success.dart';

sealed class StreamEvent {
  const factory StreamEvent.success(StreamEventSuccess success) = Success;

  const factory StreamEvent.error(StreamEventError error) = Error;
}

class Success implements StreamEvent {
  final StreamEventSuccess success;

  const Success(this.success);
}

class Error implements StreamEvent {
  final StreamEventError error;

  const Error(this.error);
}
