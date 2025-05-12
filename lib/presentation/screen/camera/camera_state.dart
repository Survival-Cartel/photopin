class CameraState {
  final bool isLoading;

  CameraState({this.isLoading = false});

  CameraState copyWith({bool? isLoading}) {
    return CameraState(isLoading: isLoading ?? this.isLoading);
  }
}
