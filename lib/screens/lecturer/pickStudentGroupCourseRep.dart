import 'package:attend_classv2/screens/lecturer/course_rep_screen.dart';
import 'package:attend_classv2/services/database_services.dart';
import 'package:flutter/material.dart';

class PickStudentGroupCourseRep extends StatefulWidget {
  final String userId, courseId;
  PickStudentGroupCourseRep({
    this.userId,
    this.courseId,
  });
  @override
  _PickStudentGroupCourseRepState createState() =>
      _PickStudentGroupCourseRepState();
}

class _PickStudentGroupCourseRepState extends State<PickStudentGroupCourseRep> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataBaseServices.getStudentGroups(widget.userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var studentGroups = snapshot.data.documents;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  'Select Student Group',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.black,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: studentGroups.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          studentGroups[index].data['group'],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => CourseRepScreen(
                              courseId: widget.courseId,
                              studentGroup: studentGroups[index].data['group'],
                              userId: widget.userId,
                            ),
                          ));
                          // Navigator.pop(context);
                        },
                      ),
                    );
                    // ListTile(
                    //   title: Text(courses[index].data['name']),
                    // );
                  }),
            ],
          ),
        );
      },
    );
  }
}
