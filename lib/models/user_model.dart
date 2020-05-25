import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String faceId;
  final String email;
  final String role;
  User({
    this.id,
    this.name,
    this.role,
    this.email,
    this.faceId,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      name: doc['name'],
      faceId: doc['faceId'],
      email: doc['email'],
      role: doc['role'],
    );
  }
}
