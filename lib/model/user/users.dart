import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final double points ;
  final String? isSelectgender;
  final bool isGenderSelected ;



  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.points = 0 ,
    this.isSelectgender,
    this.isGenderSelected = false
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      points: json['points'] ?? '0',
      isSelectgender: json['isSelectgender'],
      isGenderSelected: json['isGenderSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'points': points,
      'isSelectgender': isSelectgender,
      'isGenderSelected': isGenderSelected,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}