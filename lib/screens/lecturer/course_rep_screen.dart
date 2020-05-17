import 'package:attend_classv2/screens/widgets/comfirmation.dart';
import 'package:attend_classv2/services/database_services.dart';
import 'package:attend_classv2/utilities/constants.dart';
import 'package:flutter/material.dart';

class CourseRepScreen extends StatefulWidget {
  final String courseId, studentGroup, userId;
  CourseRepScreen({
    this.courseId,
    this.studentGroup,
    this.userId,
  });
  @override
  _CourseRepScreenState createState() => _CourseRepScreenState();
}

class _CourseRepScreenState extends State<CourseRepScreen> {
  final _formKey = GlobalKey<FormState>();
  String _indexNumber;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // String indexNumber, String courseId,
      // String studentGroup, String lecturerId
      DataBaseServices.addCourseRep(
        _indexNumber,
        widget.courseId,
        widget.studentGroup,
        widget.userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course name'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Color(0x20000000),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]),
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  'Student Group',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Index number'),
                        validator: (input) => input.length != 9
                            ? 'Enter a valid Index Number'
                            : null,
                        onSaved: (input) => _indexNumber = input,
                      ),
                    ),
                    Container(
                      width: 250.0,
                      child: FlatButton(
                        color: Colors.blue,
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            _submit();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Color(0x20000000),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]),
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  'Course Representatives',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: usersRef
                  .document(widget.userId)
                  .collection('courses')
                  .document(widget.courseId)
                  .collection('courseReps')
                  .getDocuments(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var classReps = snapshot.data.documents;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: classReps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: ListTile(
                          title: Text(classReps[index]['name']),
                          subtitle: Text(classReps[index].documentID),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: ConfirmationWedget(
                                      title: 'Delete',
                                      subText:
                                          'Do you want to remove the Course Representatives',
                                      onPressed: () {
                                        DataBaseServices.makeStudentNotClassRep(
                                          classReps[index]['studentId'],
                                          widget.courseId,
                                        );
                                        DataBaseServices
                                            .removeFromLecturerCouseRepList(
                                          widget.userId,
                                          widget.courseId,
                                          classReps[index].documentID,
                                        );
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                    ),
                                  );
                                });
                          },
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () => {},
      // ),
    );
  }
}
