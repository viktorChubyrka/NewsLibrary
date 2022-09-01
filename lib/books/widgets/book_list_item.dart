import 'package:flutter/material.dart';
import 'package:news_library/books/books.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_library/books/view/details_page.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({Key? key, required this.book, required this.isSaved}) : super(key: key);

  final Book book;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.book),
              title: Text(book.title),
              isThreeLine: true,
              subtitle: Text(book.authorName.isNotEmpty ? book.authorName[0] : 'No author'),
              dense: true,
              onTap: () {
                BlocProvider.of<BooksCubit>(context).fetchSelectedBook(book.isbn, context, isSaved);
              },
            ),
          ],
        )
      ),
    );
  }
}