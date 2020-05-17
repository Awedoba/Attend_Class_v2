import 'package:attend_classv2/screens/lecturer/add_to_attendance_log.dart';
import 'package:attend_classv2/screens/student/Student_course_details_screen.dart';
import 'package:attend_classv2/services/auth_services.dart';
import 'package:attend_classv2/services/database_services.dart';
import 'package:attend_classv2/utilities/constants.dart';
import 'package:flutter/material.dart';

class StudentCoursesScreen extends StatefulWidget {
  final String userId;
  StudentCoursesScreen({this.userId});
  @override
  _StudentCoursesScreenState createState() => _StudentCoursesScreenState();
}

class _StudentCoursesScreenState extends State<StudentCoursesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(studentgroup['studentGroup']);
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            color: Colors.black,
            child: Text(
              'logout',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => AuthServives.logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: usersRef
              .document(widget.userId)
              .collection('courses')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var courses = snapshot.data.documents;
            // print(courses[0]['name']);
            return Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    String lecturerId = courses[index].data['lecturerId'];
                    String coursesId = courses[index].documentID.trim();
                    // is the course active
                    return StreamBuilder(
                      stream: usersRef
                          .document(lecturerId)
                          .collection('courses')
                          .document(coursesId)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        bool isActive = snapshot.data['isActive'];
                        String classActiveFor = snapshot.data['for'];
                        int currentTotal = snapshot.data['totalClasses'];

                        //  is the student a moring evening etc.
                        return FutureBuilder(
                          future: usersRef.document(widget.userId).get(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            String studentGroup = snapshot.data['studentGroup'];
                            String indexNumber = snapshot.data['indexNumber'];
                            String name = snapshot.data['name'];

                            if (isActive && classActiveFor == studentGroup) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: displayActiveCourse(
                                  course: courses[index],
                                  studentName: name,
                                  studentGroup: classActiveFor,
                                  lecturerId: lecturerId,
                                  indexnumber: indexNumber,
                                  currentTotal: currentTotal,
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: displayCourse(courses[index]),
                            );
                          },
                        );
                      },
                    );
                    // return Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: displayCourse(courses[index]),
                    // );
                  }),
            );
          },
        ),
      ),
    );
  }

  //////////////////////////////////

  //////////////////////////////////

  Widget displayCourse(
    course,
  ) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => StudentCourseDetail(
            courseId: course.documentID,
            lecturerId: course.data['lecturerId'],
            courseName: course.data['name'],
            studentId: widget.userId,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListTile(
          title: Text(
            course.data['name'],
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text(course.data['lecturerName']),
          trailing: Text(
            course.documentID,
            style: TextStyle(fontSize: 16),
          ),
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

// ///////////////////////////////////////////
  Widget displayActiveCourse(
      {course,
      studentName,
      indexnumber,
      currentTotal,
      studentGroup,
      lecturerId}) {
    return InkWell(
      onDoubleTap: () {
        DataBaseServices.attendClass(
          courseId: course.documentID,
          studentName: studentName,
          indexnumber: indexnumber,
          currentTotal: currentTotal,
          studentGroup: studentGroup,
          lecturerId: lecturerId,
        );
        print('you have attended class');
      },
      onLongPress: () {
        setState(() {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: AddToAttendanceList(
                    courseId: course.documentID,
                    studentGroup: studentGroup,
                    currentTotal: currentTotal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                );
              });
          // checkIfClassStart();
        });
      },
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => StudentCourseDetail(
            courseId: course.documentID,
            lecturerId: course.data['lecturerId'],
            courseName: course.data['name'],
            studentId: widget.userId,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListTile(
          title: Text(
            course.data['name'],
            style: TextStyle(fontSize: 16),
          ),
          subtitle: Text(course.data['lecturerName']),
          trailing: Text(
            course.documentID,
            style: TextStyle(fontSize: 16),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.green,
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
