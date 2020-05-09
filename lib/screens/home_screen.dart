import 'package:attend_classv2/screens/lecturer/lecturer_courses_screen.dart';
import 'package:attend_classv2/screens/student/student_courses_Screen.dart';
import 'package:attend_classv2/utilities/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  HomeScreen({this.userId});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // DataBaseServices().goToUserCoursePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: usersRef.document(widget.userId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            String userRole = snapshot.data["role"];
            // print(userRole);
            return userRole == 'lecturer'
                ? LecturerCourseScreen(
                    userId: widget.userId,
                  )
                : StudentCoursesScreen(
                    userId: widget.userId,
                  );
          },
        ),
        // StudentCoursesScreen(),
      ),
    );
  }
}
