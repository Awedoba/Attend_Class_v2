import 'package:attend_classv2/utilities/constants.dart';
import 'package:flutter/material.dart';

class StudentCourseDetail extends StatefulWidget {
  final String courseId, lecturerId, courseName, studentId;
  StudentCourseDetail(
      {this.courseId, this.lecturerId, this.courseName, this.studentId});
  @override
  _StudentCourseDetailState createState() => _StudentCourseDetailState();
}

class _StudentCourseDetailState extends State<StudentCourseDetail> {
  @override
  Widget build(BuildContext context) {
    print(widget.courseId);
    if (widget.courseId == 'IT 402') {
      print('true');
    } else {
      print('IT 402false');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: usersRef
            .document(widget.studentId)
            .collection('courses')
            .document(widget.courseId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // var studentCourse = snapshot.data;
          return StreamBuilder(
            stream: usersRef
                .document(widget.lecturerId)
                .collection('courses')
                .document(widget.courseId.trim())
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var lecCourse = snapshot.data;
              if (lecCourse['isActive'] == true) {
                return Container(
                  child: Center(
                    child: Text('true'),
                  ),
                );
              }
              return Container(
                child: Center(
                  child: Text('false'),
                ),
              );
            },
          );
          // return Container(
          //   child: Text(snapshot.data['name']),
          // );
        },
      ),
    );
  }
}
