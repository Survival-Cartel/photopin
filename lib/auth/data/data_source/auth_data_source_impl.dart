import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photopin/auth/data/data_source/auth_data_source.dart';
import 'package:photopin/core/errors/firestore_error.dart';
import 'package:photopin/user/data/dto/user_dto.dart';
import 'package:photopin/user/data/mapper/user_mapper.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth auth;

  const AuthDataSourceImpl({required this.auth});

  @override
  Future<UserDto> findCurrentUser() async {
    User? user = auth.currentUser;

    if (user != null) {
      return user.toDto();
    }

    throw FirestoreError.notFoundError;
  }

  @override
  Future<String> findCurrentUserId() async {
    User? user = auth.currentUser;

    if (user != null) {
      return user.uid;
    }

    throw FirestoreError.notFoundError;
  }

  @override
  Future<UserDto?> login() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw FirestoreError.notFoundError;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return (await auth.signInWithCredential(credential)).user?.toDto();
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }
}
