import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:news_library/login/models/user.dart';


part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(isLoggetIn: false,));

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
    setLoginInfo(user.user);
  }

  Future<void> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    var user = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    setLoginInfo(user.user);
  }

  void setLoginInfo(user) {
    emit(state.copyWith(isLoggetIn: true, user: UserModel(name: user!.displayName as String, id: user!.uid, image: user!.photoURL as String)));
  }

  String getUserId() {
    return state.user!.id;
  }

  void clearLoginInfo()  {
    emit(state.copyWith(isLoggetIn: false, user: UserModel(name: '', id: '', image: '')));
  }

}