import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_library/login/cubit/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class UserPage extends StatelessWidget {
  String image;
  String name;

  UserPage({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image(
                image: NetworkImage(image),
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: OutlinedButton(
                child: Text('Log Out'),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  BlocProvider.of<LoginCubit>(context).clearLoginInfo();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
