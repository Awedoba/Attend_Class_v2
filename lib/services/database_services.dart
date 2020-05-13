import 'package:attend_classv2/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseServices {
  static void startClass({
    userId,
    courseId,
    studentGroup,
  }) {
    usersRef
        .document(userId)
        .collection('courses')
        .document(courseId)
        .updateData({
      'isActive': true,
      'for': studentGroup,
      // '$studentGroup' + 'Total': totalClasses + 1,
      '$studentGroup' + 'Total': FieldValue.increment(1),
    });
  }

  static void endClass(userId, courseId, studentGroup, total) {
    usersRef
        .document(userId)
        .collection('courses')
        .document(courseId)
        .updateData({
      'isActive': false,
      'for': '',
      // 'totalClasses':
    });
    updateStudentAtendance(studentGroup, userId, courseId, total);
  }

  static void updateStudentAtendance(String studentGroup, String lecturerId,
      String courseId, int total) async {
    String attendanceLogId =
        lecturerId.trim() + '_' + courseId.trim() + '_' + studentGroup;
    // List<DocumentSnapshot> studentAttendance =
    final QuerySnapshot result = await attendanceLog
        .document(attendanceLogId)
        .collection('students')
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    for (DocumentSnapshot doc in documents) {
      int missed = doc.data['missed'];
      int attended = doc.data['attended'];
      print('missed:: $missed');

      print('attended:: $attended');

      int difference = total - (missed + attended);
      Firestore.instance.runTransaction((transactionHandler) async {
        DocumentSnapshot snapshot = await transactionHandler.get(doc.reference);
        await transactionHandler.update(
            snapshot.reference, {'missed': FieldValue.increment(difference)});
      });
    }
  }

  // get list of students who did not
  // attend the lastest class.(that
  // is add number of classes attended
  //  to number of classes missed and see
  //  if it is equal to the total number of classes.)
// then increase the classes missed by the difference of
// classes attended + missed to the total classes
  static void attendClass(
      {int currentTotal,
      studentName,
      indexnumber,
      lecturerId,
      courseId,
      studentGroup}) {
    String attendanceLogId =
        lecturerId.trim() + '_' + courseId.trim() + '_' + studentGroup;

    // print('currentTotal:: $currentTotal');
    // print('studentGroup:: $studentGroup');
    // print('studentName:: $studentName');
    // print('lecturerId:: $lecturerId');
    // print('courseId:: $courseId');
    // print('indexnumber:: $indexnumber');

    //studentname, indexnumber,lecID+courseID+studentGroup
    int currenttotal = currentTotal;
    int oldtotal = currenttotal - 1;
    attendanceLog
        .document(attendanceLogId)
        .collection('students')
        .document(indexnumber)
        .get()
        .then((doc) {
      if (doc.exists) {
        // check if user has not attended the current class

        if (((doc.data['missed'] + doc.data['attended']) == oldtotal)) {
          attendanceLog
              .document(attendanceLogId)
              .collection('students')
              .document(indexnumber)
              .updateData({
            'attended': doc.data['attended'] + 1,
          });
        }
        //if user has attended the class do nothing
      }
      // if user has never attended class add user to the attendance log
      else if (!doc.exists) {
        attendanceLog
            .document(attendanceLogId)
            .collection('students')
            .document(indexnumber)
            .setData({
          'name': studentName,
          'indexNumber': indexnumber,
          'attended': 1,
          'missed': currentTotal - 1,
        });
      }
    });
  }

  static void getCourse() {}
}
