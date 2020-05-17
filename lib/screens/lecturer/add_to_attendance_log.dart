import 'package:attend_classv2/services/database_services.dart';
import 'package:flutter/material.dart';

class AddToAttendanceList extends StatefulWidget {
  final int currentTotal;
  final String courseId, studentGroup;
  AddToAttendanceList({this.courseId, this.studentGroup, this.currentTotal});
  @override
  _AddToAttendanceListState createState() => _AddToAttendanceListState();
}

class _AddToAttendanceListState extends State<AddToAttendanceList> {
  final _formkey = GlobalKey<FormState>();
  String _indexNumber;

  _submit() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      DataBaseServices.addToAttendanceList(_indexNumber, widget.courseId,
          widget.studentGroup, widget.currentTotal);
      Navigator.pop(context);
      // print(_indexNumber);
      // print(widget.courseId);
      // print(widget.studentGroup);
      // print(widget.currentTotal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  'Add Student to Attendance',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.black,
              ),
              Form(
                key: _formkey,
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
                          _submit();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
