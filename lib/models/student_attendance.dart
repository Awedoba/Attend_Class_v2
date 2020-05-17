import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAttendaceDetail {
  String name;
  String indexNumber;
  int attended;
  int missed;
  StudentAttendaceDetail({
    this.name,
    this.indexNumber,
    this.attended,
    this.missed,
  });
  factory StudentAttendaceDetail.fromdoc(DocumentSnapshot doc) {
    return StudentAttendaceDetail(
      name: doc['name'],
      indexNumber: doc['indexNumber'],
      attended: doc['attended'],
      missed: doc['missed'],
    );
  }
}
