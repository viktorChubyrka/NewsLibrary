import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_library/books/books.dart';


class MyAppBar extends StatefulWidget {
  int index;
  MyAppBar({required this.index});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {

  final _myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    switch (widget.index) {
      case 0: return Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            controller: _myController,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _myController.text = '';
                    BlocProvider.of<BooksCubit>(context).clearBooksList();
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
            onSubmitted: (value) {
              BlocProvider.of<BooksCubit>(context).setSearch(value, context);
            },
          ),
        ),
      );
      case 1:  return Text('Saved books');
      default: return Text('Profile');
    }

  }
}
