import 'package:news_library/books/models/book.dart';
class UserModel {
  final String id;
  final String image;
  final String name;

  UserModel({required this.id, required this.name, required this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _userFromJson(json);

  Map<String, dynamic> toJson() => _userToJson(this);

  @override
  String toString() => 'User: $name ';

}

UserModel _userFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as String,
    name: json['name']as String,
    image: json['image']as String,
  );
}
// 2
Map<String, dynamic> _userToJson(UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };

