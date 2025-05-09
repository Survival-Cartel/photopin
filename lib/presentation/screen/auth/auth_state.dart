class AuthState {
  final bool isLoading;
  final String email;

  const AuthState({this.isLoading = false, this.email = ''});

  AuthState copyWith({bool? isLoading, String? email}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
    );
  }
}
