import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_library/books/books.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_library/login/cubit/login_cubit.dart';
import 'package:news_library/books/utils/utils.dart';


class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key, required this.isSaved,}) : super(key: key);
  bool isSaved;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, BooksState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Book details'),
        ),
        body: Row(children: [
          Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeInImage(
                      image: NetworkImage((state.selectedBook['cover'] == null)
                          ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png'
                          : state.selectedBook['cover']['medium']),
                      placeholder:
                          const AssetImage('assets/placeholder.svg.png'),
                      height: 250,
                      width: 150,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        state.selectedBook['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      state.selectedBook['subtitle'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Author:  ${state.selectedBook['authors'][0]['name'] ?? 'unknown'}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Pages:  ${state.selectedBook['number_of_pages'] ?? 'unknown'}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ))
        ]),
        floatingActionButton: !isSaved
            ? FloatingActionButton(
                child: const Icon(Icons.save),
                onPressed: () {
                  FirebaseAuth.instance.authStateChanges().listen((user) {
                    if (user != null) {
                      BlocProvider.of<BooksCubit>(context).saveBook(
                          BlocProvider.of<LoginCubit>(context).getUserId(),
                          context);
                    } else {
                      Utils(context).showMessage('You nead to log in!');
                    }
                  });
                },
              )
            : FloatingActionButton(
                child: const Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<BooksCubit>(context).deleteBook(state.selectedBook['isbn'], context);
                },
              ),
      );
    });
  }
}
