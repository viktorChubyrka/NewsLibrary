import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Book extends Equatable {

  const Book({required this.id, required this.title, required this.authorName, required this.isbn, this.item});

  final String id;
  final String title;
  final List<String> authorName;
  final String isbn;
  final QueryDocumentSnapshot? item;


  factory Book.fromJson(Map<String, dynamic> json) =>
      _fromJson(json);
  // 4
  Map<String, dynamic> toJson() => _toJson(this);
  @override
  List<Object> get props => [id, title, authorName, isbn];
}

Book _fromJson(Map<String, dynamic> json) {
  return Book(
    id: json['id'] as String,
    title: json['title'] as String,
    authorName: json['authorName'] as List<String>,
    isbn: json['isbn'] as String,
  );
}
// 2
Map<String, dynamic> _toJson(Book instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authorName': instance.authorName,
      'isbn': instance.isbn,
    };