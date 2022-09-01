import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_library/books/books.dart';
import 'package:news_library/login/cubit/login_cubit.dart';

class SavedBooks extends StatefulWidget {
  const SavedBooks({Key? key}) : super(key: key);

  @override
  _SavedBooksState createState() => _SavedBooksState();
}

class _SavedBooksState extends State<SavedBooks> {
  final _scrollController = ScrollController();
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        BlocProvider.of<BooksCubit>(context).fetchSavedBooks(
            BlocProvider.of<LoginCubit>(context).getUserId(), false, context);
        isLoggedIn = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(builder: (context, loginState) {
      if (loginState.isLoggetIn) {
        return BlocBuilder<BooksCubit, BooksState>(builder: (context, state) {
          if (state.savedBooks.length == 0) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No books found'),
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return BookListItem(book: state.savedBooks[index], isSaved: true);
            },
            itemCount: state.savedBooks.length,
            controller: _scrollController,
          );
        });
      } else {
        return Text('Please log in');
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      BlocProvider.of<BooksCubit>(context).fetchSavedBooks(
          BlocProvider.of<LoginCubit>(context).getUserId(), true, context);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
