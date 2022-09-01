part of 'login_cubit.dart';

class LoginState {
  bool isLoggetIn;
  UserModel? user;

  LoginState({required this.isLoggetIn, this.user});

  LoginState copyWith({
    bool? isLoggetIn,
    UserModel? user,
  }) {
    return LoginState(
      isLoggetIn: isLoggetIn ?? this.isLoggetIn,
      user: user ?? this.user,
    );
  }
}
