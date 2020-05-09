import 'package:attend_classv2/screens/home_screen.dart';
import 'package:attend_classv2/screens/lecturer/course_details.dart';
import 'package:attend_classv2/screens/lecturer/lecturer_courses_screen.dart';
import 'package:attend_classv2/screens/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // if there is a loged in user take me to app else go to login
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          // return LecturerCourseScreen(
          //   userId: snapshot.data.uid,
          // );
          return HomeScreen(
            userId: snapshot.data.uid,
          );
          // print('sda');
          // return DataBaseServices().goToUserCoursePage(snapshot.data.uid);
        } else {
          return LoginScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attend class',
      debugShowCheckedModeBanner: false,
      home: _getScreenId(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        LecturerCourseScreen.id: (context) => LecturerCourseScreen(),
        CourseDetails.id: (context) => CourseDetails(),
      },
    );
  }
}
