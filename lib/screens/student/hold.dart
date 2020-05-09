// import 'package:attend_classv2/services/auth_services.dart';
// import 'package:attend_classv2/utilities/constants.dart';
// import 'package:flutter/material.dart';

// class StudentCoursesScreen extends StatefulWidget {
//   final String userId;
//   StudentCoursesScreen({this.userId});
//   @override
//   _StudentCoursesScreenState createState() => _StudentCoursesScreenState();
// }

// class _StudentCoursesScreenState extends State<StudentCoursesScreen> {
//   var courseID;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Courses'),
//         centerTitle: true,
//         actions: <Widget>[
//           FlatButton(
//             color: Colors.black,
//             child: Text(
//               'logout',
//               style: TextStyle(color: Colors.white),
//             ),
//             onPressed: () => AuthServives.logout(),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: StreamBuilder(
//           stream: usersRef
//               .document(widget.userId)
//               .collection('courses')
//               .snapshots(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             var courses = snapshot.data.documents;
//             // print(courses[0]['name']);
//             return Container(
//               padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
//               child: ListView.builder(
//                   itemCount: courses.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: displayCourse(courses[index]),
//                     );
//                     // ListTile(
//                     //   title: Text(courses[index].data['name']),
//                     // );
//                   }),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   //////////////////////////////////

//   //////////////////////////////////

//   Widget displayCourse(course, {Color color = Colors.white}) {
//     // ListTile(
//     //   title: Text(course),
//     // );
//     // print(course.data['lecturerId']);
//     //////////////////////////////////

//     /////////////////////////////////

//     return InkWell(
//       onTap: () => print('go course details'),
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         child: ListTile(
//           title: Text(
//             course.data['name'],
//             style: TextStyle(fontSize: 16),
//           ),
//           subtitle: Text(course.data['lecturerName']),
//           trailing: Text(
//             course.documentID,
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x20000000),
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
