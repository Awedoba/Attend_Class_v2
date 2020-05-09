import 'package:attend_classv2/screens/lecturer/start_class.dart';
import 'package:attend_classv2/services/database_services.dart';
import 'package:attend_classv2/utilities/constants.dart';
import 'package:flutter/material.dart';

class CourseDetails extends StatefulWidget {
  static final String id = 'course_details.dart';
  final String userId, courseId, courseName;
  final int totalClasses;
  CourseDetails(
      {this.userId, this.courseId, this.totalClasses, this.courseName});
  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  // bool isActive = true;
  @override
  void initState() {
    // checkIfClassStart();
    super.initState();
    // print(isActive);
  }

  // checkIfClassStart() async {
  //   isActive = await usersRef
  //       .document(widget.userId)
  //       .collection('courses')
  //       .document(widget.courseId)
  //       .get()
  //       .then((doc) {
  //     return doc['isActive'];
  //   });
  //   // print('$isActive 2');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('courseName'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: usersRef
                .document(widget.userId)
                .collection('courses')
                .document(widget.courseId)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              bool isActive = snapshot.data['isActive'];
              // print(snapshot.data['isActive']);
              // print('$isActive not');
              return isActive
                  ? buildCourseDetailBtn(
                      'End class',
                      () {
                        setState(() {
                          DataBaseServices.endClass(
                            widget.userId,
                            widget.courseId,
                          );
                          // checkIfClassStart();
                        });
                      },
                    )
                  : buildCourseDetailBtn(
                      'Start class',
                      () {
                        setState(() {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: StartClass(
                                    courseId: widget.courseId,
                                    userId: widget.userId,
                                    totalClasses: widget.totalClasses,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                );
                              });
                          // checkIfClassStart();
                        });
                      },
                    );
            },
          ),
          // !isActive

          buildCourseDetailBtn(
            'Add course Representative',
            () => print('add rep'),
          ),
          buildCourseDetailBtn(
            'Course Representative',
            () => print('rep'),
          ),
          buildCourseDetailBtn(
            'Add student to Attendance Log',
            () => print('log'),
          ),
          buildCourseDetailBtn(
            'Addentace History',
            () => print('history'),
          ),
        ],
      ),
    );
  }

  Padding buildCourseDetailBtn(String title, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListTile(
            title: Text(title),
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
      ),
    );
  }
}
