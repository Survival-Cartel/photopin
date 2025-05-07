class UserModel {
  final String id;
  final String email;
  final String profileImg;
  final String displayName;

  const UserModel({
    required this.id,
    required this.email,
    required this.profileImg,
    required this.displayName,
  });

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, profileImg: $profileImg, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
