import 'package:attend_classv2/screens/lecturer/course_details.dart';
import 'package:attend_classv2/screens/user/profile.dart';
import 'package:attend_classv2/services/auth_services.dart';
import 'package:attend_classv2/services/database_services.dart';
import 'package:flutter/material.dart';

class LecturerCourseScreen extends StatefulWidget {
  static final String id = 'lecturer_courses_screen';
  final String userId;
  LecturerCourseScreen({this.userId});
  @override
  _LecturerCourseScreenState createState() => _LecturerCourseScreenState();
}

class _LecturerCourseScreenState extends State<LecturerCourseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        centerTitle: true,
        leading: FlatButton(
            // color: Colors.black,
            // child: Text('home'),
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              print('object');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ProfileScreen(
                    userId: widget.userId,
                  ),
                ),
              );
            }),
        actions: <Widget>[
          FlatButton(
            // color: Colors.black,
            child: Text(
              'logout',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => AuthServives.logout(),
          ),
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
        future: DataBaseServices.getCoursesFuture(widget.userId),
        // usersRef
        //     .document(widget.userId)
        //     .collection('courses')
        //     .getDocuments(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var courses = snapshot.data.documents;
          return Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: displayCourses(courses[index]),
                  );
                  // ListTile(
                  //   title: Text(courses[index].data['name']),
                  // );
                }),
          );
        },
      )),

      // Center(
      //   child: FlatButton(
      //     color: Colors.black,
      //     child: Text(
      //       'logout',
      //       style: TextStyle(color: Colors.white),
      //     ),
      //     onPressed: () => AuthServives.logout(),
      //   ),
      // ),
    );
  }

  Widget displayCourses(course) {
    // ListTile(
    //   title: Text(course),
    // );
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => CourseDetails(
            courseId: course.documentID,
            userId: widget.userId,
            courseName: course.data['name'],
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListTile(
          title: Text(course.data['name']),
          trailing: Text(course.documentID),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x20000000),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }
}
