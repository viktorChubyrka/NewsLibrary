part of 'books_cubit.dart';

enum BooksStatus {initial, loaded, failure}

class BooksState {
  String search;
  List<Book> books;
  var selectedBook;
  bool hasReachedMax;
  BooksStatus status;
  List<Book> savedBooks;
  bool hasMoreSaved;
  bool isLoading;
  bool isLoadingSaved;
  DocumentSnapshot? lastDocument;

  BooksState({required this.search,required this.books, required this.hasReachedMax,required this.status, this.selectedBook, required this.savedBooks, required this.hasMoreSaved, required this.isLoading, required this.isLoadingSaved, required this.lastDocument});

  BooksState copyWith({
    String? search,
    List<Book>? books,
    bool? hasReachedMax,
    BooksStatus? status,
    var selectedBook,
    List<Book>? savedBooks,
    bool? hasMoreSaved,
    bool? isLoading,
    bool? isLoadingSaved,
    DocumentSnapshot? lastDocument

  }) {
    return BooksState(
        search: search ?? this.search,
        books: books ?? this.books,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        status: status ?? this.status,
        selectedBook:  selectedBook ?? this.selectedBook,
        savedBooks:  savedBooks ?? this.savedBooks,
        hasMoreSaved: hasMoreSaved ?? this.hasMoreSaved,
        isLoading: isLoading ?? this.isLoading,
        isLoadingSaved: isLoadingSaved ?? this.isLoadingSaved,
        lastDocument: lastDocument ?? this.lastDocument
    );
  }
}
