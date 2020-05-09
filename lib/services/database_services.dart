import 'package:attend_classv2/utilities/constants.dart';

class DataBaseServices {
  static void startClass({userId, courseId, studentGroup, int totalClasses}) {
    usersRef
        .document(userId)
        .collection('courses')
        .document(courseId)
        .updateData({
      'isActive': true,
      'for': studentGroup,
      'totalClasses': totalClasses + 1,
    });
  }

  static void endClass(userId, courseId) {
    usersRef
        .document(userId)
        .collection('courses')
        .document(courseId)
        .updateData({
      'isActive': false,
      'for': '',
      // 'totalClasses':
    });
  }

  // userIds() {
  //   var userss = usersRef
  //       .where('role', isEqualTo: 'student')
  //       .where('morning', isEqualTo: 'studentGroup')
  //       .getDocuments();
  //   userss.
  // }
  // goToUserCoursePage(userId) {
  //   StreamBuilder(
  //       stream: usersRef.document(userId).snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot snapshot) {
  //         String userRole = snapshot.data['name'];
  //         print(userRole);
  //         return true
  //             ? LecturerCourseScreen(
  //                 userId: userId,
  //               )
  //             : StudentCoursesScreen();
  //       });

  // currentUser.then((user) {
  //   return usersRef.document(user.uid).get().then((doc) {
  //     if (doc.exists) {
  //       if (doc.data['role'] == 'lecturer') {
  //         LecturerCourseScreen(
  //           userId: doc.documentID,
  //         );
  //       }
  //       StudentCoursesScreen();
  //     }
  //   });
  // });
  // }

  // static getUserRole(userEmail) {
  //   var user = usersRef
  //       .where('email', isEqualTo: userEmail)
  //       .where('role', isEqualTo: 'lecturer')
  //       .getDocuments();
  // }

  static void getCourse() {}
}
