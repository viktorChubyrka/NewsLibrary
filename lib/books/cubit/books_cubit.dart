import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_library/books/models/book.dart';
import 'package:news_library/books/utils/utils.dart';
import 'package:news_library/books/view/details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  BooksCubit()
      : super(BooksState(
          search: '',
          books: [],
          hasReachedMax: false,
          status: BooksStatus.initial,
          savedBooks: [],
          hasMoreSaved: true,
          isLoading: false,
          isLoadingSaved: false,
          lastDocument: null,
        ));

  final http.Client httpClient = http.Client();

  Future<void> _searchBooks(BuildContext context) async {
    List<Book> books = await _fetchBooks(context);
    emit(state.copyWith(books: books, status: BooksStatus.loaded));
    Utils(context).stopLoading();
  }

  void clearBooksList() {
    emit(state.copyWith(books: [], status: BooksStatus.initial));
  }

  Future<void> loadMoreBooks(BuildContext context) async {
    if (state.hasReachedMax) {
      Utils(context).showMessage('No More Books');
      return;
    }
    if(state.isLoading) {
      return;
    }
    Utils(context).startLoading();
    List<Book> books = await _fetchBooks(context);
    emit(state.copyWith(books: List.from(state.books)..addAll(books), isLoading: false));
    Utils(context).stopLoading();
  }

  void setSearch(String value, BuildContext context) {
    Utils(context).startLoading();
    emit(state.copyWith(search: value, hasReachedMax: false, books: []));
    _searchBooks(context);
  }

  Future<void> fetchSelectedBook(
    String isbn,
    BuildContext context,
    bool isSaved,
  ) async {
    final response = await httpClient.get(Uri.parse(
        'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&jscmd=data&format=json'));
    var book = json.decode(response.body)['ISBN:$isbn'];
    book['isbn'] = isbn;
    emit(state.copyWith(selectedBook: book));
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DetailsPage(
              isSaved: isSaved,
            )));
  }

  Future<void> saveBook(String userId, BuildContext context) async {
    List isAlreadySaved = state.savedBooks.where((el) => el.isbn == state.selectedBook['isbn']).toList();
    if(isAlreadySaved.length != 0) {
      Utils(context).showMessage("Book is already saved!");
      return;
    }
    CollectionReference savedBooks =
        FirebaseFirestore.instance.collection('saved_books');
    savedBooks
        .add({
          'userId': userId,
          'title': state.selectedBook['title'],
          'authors': state.selectedBook['authors'],
          'cover': state.selectedBook['cover'],
          'subtitle': state.selectedBook['subtitle'] ?? 'unknown',
          'number_of_pages': state.selectedBook['number_of_pages'] ?? 'unknown',
          'isbn': state.selectedBook['isbn'],
        })
        .then((value) => {Utils(context).showMessage('Book saved!')})
        .catchError((error) =>
            Utils(context).showMessage("Failed to add book: $error"));
  }

  Future<void> deleteBook(isbn, BuildContext context) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('saved_books')
        .orderBy("title")
        .where('isbn', isEqualTo: isbn)
        .startAt([0]).get();
    var docs = querySnapshot.docs;
    await FirebaseFirestore.instance.runTransaction(
        (Transaction myTransaction) async {
      await myTransaction.delete(docs[0].reference);
    }).then((value) {
      List<Book> books = state.savedBooks;
      books.removeWhere((el) => el.isbn == isbn);
      emit(state.copyWith(savedBooks: books));
      Utils(context).showMessage('Book deleted!');
      Navigator.pop(context);
    }).catchError(
        (error) => Utils(context).showMessage("Failed to add book: $error"));
    ;
  }

  Future<List<Book>> _fetchBooks(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    String searchQuery = state.search.split(' ').join('+');
    int offset = state.books.length;
    final response = await httpClient.get(
      Uri.parse(
          'http://openlibrary.org/search.json?q=$searchQuery&limit=10&offset=$offset&fields=key,title,author_name,isbn'),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body)['docs'] as List;
      var books = body.map((dynamic array) {
        if (array['author_name'] is List) {
          return Book(
            id: array['key'],
            title: array['title'],
            authorName: [...array['author_name']],
            isbn: array['isbn']?[0] ?? '',
          );
        } else {
          return Book(
              id: array['key'],
              title: array['title'],
              authorName: const [],
              isbn: array['isbn']?[0] ?? '');
        }
      }).toList();
      if (books.isEmpty) emit(state.copyWith(hasReachedMax: true));
      emit(state.copyWith(isLoading: false));
      return books;
    }
    emit(state.copyWith(status: BooksStatus.failure));
    throw Exception('error fetching posts');

  }

  Future<void> fetchSavedBooks(
      String userId, bool loadMore, BuildContext context) async {
    final lastDocument = state.lastDocument;
    QuerySnapshot querySnapshot;
    if (!state.hasMoreSaved) {
      Utils(context).showMessage('No More Books');
      return;
    }
    if (state.isLoadingSaved) {
      return;
    }
    emit(state.copyWith(isLoadingSaved: true));
    Utils(context).startLoading();
    if (!loadMore) {
      emit(state.copyWith(savedBooks: []));
    }
    int offset = state.savedBooks.length;
    if (lastDocument == null) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('saved_books')
          .limit(10)
          .orderBy("title")
          .where('userId', isEqualTo: userId)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('saved_books')
          .limit(10)
          .orderBy("title")
          .startAfterDocument(lastDocument)
          .where('userId', isEqualTo: userId)
          .get();
    }
    if (querySnapshot.docs.length < offset) {
      emit(state.copyWith(hasMoreSaved: false));
    }
    emit(state.copyWith(
        lastDocument: querySnapshot.docs[querySnapshot.docs.length - 1]));
    var docs = querySnapshot.docs;
    List<Book> books = [];
    for (var item in docs) {
      var book = Map<String, dynamic>.from(item.data() as Map);
      books.add(Book(
        id: book['title'],
        title: book['title'],
        authorName: book['author_name'] ?? [],
        isbn: book['isbn'] ?? '',
        item: item,
      ));
    }
    emit(state.copyWith(savedBooks: [...state.savedBooks, ...books]));
    Utils(context).stopLoading();
    emit(state.copyWith(isLoadingSaved: false));
  }

  void clearSavedBooksList() {
    emit(state.copyWith(savedBooks: []));
  }
}
