import 'dart:convert';

class UserModel {
  final String imgUrl;
  final String name;
  final String id;
  final String email;
  
  UserModel({
    required this.imgUrl,
    required this.name,
    required this.id,
    required this.email,
    
  });

  Map<String, dynamic> toMap() {
    return {
      'imgUrl': imgUrl,
      'name': name,
      'id': id,
      'email': email,
      
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      imgUrl: map['imgUrl'] ?? '',
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      email: map['_id'] ?? '',
      
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? imgUrl,
    String? name,
    String? id,
    String? email,
    
  }) {
    return UserModel(
      imgUrl: imgUrl ?? this.imgUrl,
      name: name ?? this.name,
      id: id ?? this.id,
      email: email ?? this.email,
      
    );
  }
}
