import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_library/login/cubit/login_cubit.dart';
import 'package:news_library/login/widgets/login_button.dart';
import 'package:news_library/login/login.dart';
import 'package:news_library/login/widgets/user_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {

  void initState()  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
      if (state.isLoggetIn) {
        return UserPage(image: state.user!.image, name: state.user!.name);
      } else {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontSize: 30),
                ),
                LoginButton(color: Colors.blue, image: AssetImage('assets/facebook.png'), text: 'Log in with Facebook', onPressed: () {
                  BlocProvider.of<LoginCubit>(context).signInWithFacebook();
                }),
                LoginButton(color: Colors.lightGreen, image: AssetImage('assets/google.png'), text: 'Log in with Google', onPressed: () {
                  BlocProvider.of<LoginCubit>(context).signInWithGoogle();
                }),
              ],
            ),
          ),
        );
      }
    });
  }
}
