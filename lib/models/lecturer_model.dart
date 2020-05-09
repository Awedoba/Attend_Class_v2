import 'package:attend_classv2/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Lecturer {
  final String id;
  final String name;
  final String role;
  final String email;
  var courses;
  Lecturer({this.id, this.name, this.email, this.role, this.courses});
  factory Lecturer.fromDoc(DocumentSnapshot doc) {
    return Lecturer(
        id: doc.documentID,
        name: doc['name'],
        email: doc['email'],
        role: doc['role']);
  }

  getCourses() async {
    courses = await usersRef.document(id).collection('courses').getDocuments();
    return courses;
  }
}
