import 'package:attend_classv2/models/student_attendance.dart';
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

  // get list of students who did not
  // attend the lastest class.(that
  // is add number of classes attended
  //  to number of classes missed and see
  //  if it is equal to the total number of classes.)
// then increase the classes missed by the difference of
// classes attended + missed to the total classes
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

  static void attendClass(
      {int currentTotal,
      studentName,
      indexnumber,
      lecturerId,
      courseId,
      studentGroup}) {
    String attendanceLogId =
        lecturerId.trim() + '_' + courseId.trim() + '_' + studentGroup;
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

  static Future<List<StudentAttendaceDetail>> getAttendanceList(
      String studentGroup, String lecturerId, String courseId) async {
    String attendanceLogId =
        lecturerId.trim() + '_' + courseId.trim() + '_' + studentGroup;
    QuerySnapshot listOfStudentSnapshot = await attendanceLog
        .document(attendanceLogId)
        .collection('students')
        .getDocuments();
    List<StudentAttendaceDetail> listOfStudent = listOfStudentSnapshot.documents
        .map((doc) => StudentAttendaceDetail.fromdoc(doc))
        .toList();
    return listOfStudent;
  }

  static void addToAttendanceList(String indexNumber, String courseId,
      String studentGroup, int currentTotal) {
    // check the index number belongs to a student who is in the student group the course is active for
    usersRef
        .where('indexNumber', isEqualTo: indexNumber)
        .where('studentGroup', isEqualTo: studentGroup)
        .limit(1)
        .getDocuments()
        .then((studentDocs) {
      if (studentDocs != null) {
        var studentDoc = studentDocs.documents;
        // if there is such a student check if he takes the course
        if (studentDoc[0].exists) {
          print('student');
          usersRef
              .document(studentDoc[0].documentID)
              .collection('courses')
              .document(courseId.trim())
              .get()
              .then((course) {
            print('cascasc');
            // if the student has the course then add to the attendance list
            if (course.exists) {
              print('object');
              attendClass(
                  currentTotal: currentTotal,
                  studentName: studentDoc[0].data['name'],
                  indexnumber: indexNumber,
                  lecturerId: course.data['lecturerId'],
                  courseId: courseId.trim(),
                  studentGroup: studentGroup);
            }
          });
        } else {
          print('no student');
        }
      }
    });
  }

  static void addCourseRep(String indexNumber, String courseId,
      String studentGroup, String lecturerId) {
    //get studgroup, studentindex,courseid,
    // check if stdent exits and is part of student group,
    usersRef
        .where('indexNumber', isEqualTo: indexNumber)
        .where('studentGroup', isEqualTo: studentGroup)
        .limit(1)
        .getDocuments()
        .then((studentDocs) {
      if (studentDocs != null) {
        var studentDoc = studentDocs.documents;
        // cheack is student has course
        if (studentDoc[0].exists) {
          // print('student');
          usersRef
              .document(studentDoc[0].documentID)
              .collection('courses')
              .document(courseId.trim())
              .get()
              .then((course) {
            if (course.exists) {
              // print('object');
              // check if course is thought be lecturer
              if (course.data['lecturerId'] == lecturerId) {
                print(studentDoc[0].documentID);
                print(courseId.trim());
                makeStudentClassRep(studentDoc[0].documentID, courseId.trim());
                addtoLecturerCouseRepList(
                  lecturerId: lecturerId,
                  courseId: courseId.trim(),
                  studentName: studentDoc[0].data['name'],
                  indexNumber: studentDoc[0].data['indexNumber'],
                  studentId: studentDoc[0].documentID,
                );
              }
            }
          });
        }
      }
    });

    // check if stdent has course
    // add stud to lecturer cousrse rep list
    // set stud as course rep
  }

  static void makeStudentClassRep(String studentId, String courseId) {
    // get the students course and set course rep true
    usersRef
        .document(studentId)
        .collection('courses')
        .document(courseId)
        .updateData({'courseRep': true});
  }

  static void addtoLecturerCouseRepList(
      {String lecturerId,
      String courseId,
      String studentName,
      String indexNumber,
      String studentId}) {
    // add student to the lecturer course rep list

    usersRef
        .document(lecturerId)
        .collection('courses')
        .document(courseId)
        .collection('courseReps')
        .document(indexNumber)
        .setData({
      'name': studentName,
      'studentId': studentId,
    });
  }

  static void makeStudentNotClassRep(String studentId, String courseId) {
    // print('start');
    // get the students course and set course rep false
    usersRef
        .document(studentId)
        .collection('courses')
        .document(courseId)
        .updateData({'courseRep': false});
    // print('end');
  }

  static void removeFromLecturerCouseRepList(
    String lecturerId,
    String courseId,
    String indexNumber,
  ) {
    print('start');
    // remove the student from the lecturer list of course reps
    usersRef
        .document(lecturerId)
        .collection('courses')
        .document(courseId)
        .collection('courseReps')
        .document(indexNumber)
        .delete();
    // .updateData({'asdasd': 'asdaa1'});
    print(indexNumber);
  }
}
