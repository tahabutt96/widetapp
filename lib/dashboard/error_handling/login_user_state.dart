import 'package:firebase_auth/firebase_auth.dart';
class LoginUserState {
  final UserCredential? userCredential;
  final String? message;
  LoginUserState({this.userCredential,this.message});
}