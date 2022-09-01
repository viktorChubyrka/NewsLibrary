import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_library/books/books.dart';
import 'package:news_library/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedIndex = 0;

  void initState()  {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        BlocProvider.of<LoginCubit>(context).setLoginInfo(user);
      }
    });
  }


  static List<Widget> _widgetOptions = <Widget>[
    SearchPage(),
    SavedBooks(),
    LoginPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: MyAppBar(index: _selectedIndex),
        ) ,
        body:  Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.save),
                label: 'Saved'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle),
                label: 'Profile'
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      );
  }
}

