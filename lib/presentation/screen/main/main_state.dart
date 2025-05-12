// lib/presentation/main/main_screen_state.dart
class MainScreenState {
  final int selectedIndex;
  final String? profileImageUrl;

  const MainScreenState({this.selectedIndex = 0, this.profileImageUrl});

  MainScreenState copyWith({int? selectedIndex, String? profileImageUrl}) {
    return MainScreenState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
