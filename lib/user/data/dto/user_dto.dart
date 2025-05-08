class UserDto {
  final String? id;
  final String? email;
  final String? profileImg;
  final String? displayName;

  const UserDto({this.id, this.email, this.profileImg, this.displayName});

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'],
    email: json['email'],
    profileImg: json['profileImg'],
    displayName: json['displayName'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'profileImg': profileImg,
    'displayName': displayName,
  };

  @override
  String toString() =>
      'UserDto(id: $id, email: $email, profileImg: $profileImg, displayName: $displayName)';
}
