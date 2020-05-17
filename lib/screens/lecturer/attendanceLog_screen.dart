import 'dart:io';
import 'package:attend_classv2/models/student_attendance.dart';
import 'package:attend_classv2/services/database_services.dart';
import 'package:csv/csv.dart';
// import 'package:attend_classv2/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';

class AttendanceLogScreen extends StatefulWidget {
  //lecturerid course and studentgrup
  final String userId, courseId, studentGroup;
  AttendanceLogScreen({this.userId, this.courseId, this.studentGroup});
  @override
  _AttendanceLogScreenState createState() => _AttendanceLogScreenState();
}

class _AttendanceLogScreenState extends State<AttendanceLogScreen> {
  List<StudentAttendaceDetail> _studentList = [];
  String filePath;
  bool sort;
  @override
  void initState() {
    sort = false;
    super.initState();
    _setupStudentList();
  }

  _setupStudentList() async {
    List<StudentAttendaceDetail> studentsList =
        await DataBaseServices.getAttendanceList(
            widget.studentGroup, widget.userId, widget.courseId);
    if (mounted) {
      setState(() {
        _studentList = studentsList;
      });
    }
  }

// get the path to the app
  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

// make  a file
  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    filePath = '$path/data.csv';
    return File('$path/data.csv').create();
  }

// convert the list of students to csv
  makecsv() async {
    List<List<dynamic>> rows = List<List<dynamic>>();
    rows.add([
      'Name',
      'Index No.',
      'Attended',
      'Missed',
    ]);

    if (_studentList != null) {
      for (int i = 0; i < _studentList.length; i++) {
        List<dynamic> row = List<dynamic>();
        row.add(_studentList[i].name);
        row.add(_studentList[i].indexNumber);
        row.add(_studentList[i].attended);
        row.add(_studentList[i].missed);
        rows.add(row);
      }

      File f = await _localFile;

      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
      sendMailAndAttachment();
    }
  }

  sendMailAndAttachment() async {
    final Email email = Email(
      body: 'Hey, the CSV made it!',
      subject: 'Datum Entry for ${DateTime.now().toString()}',
      recipients: ['attendclasz@gmail.com'],
      isHTML: true,
      attachmentPaths: [filePath],
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              print("share");
              makecsv();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.only(top: 475),
          // color: Colors.green,
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
                    widget.studentGroup.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  // padding: EdgeInsets.only(top: 475),
                  child: DataTable(
                    // sortAscending: true,
                    // sortColumnIndex: 0,
                    columnSpacing: 15,
                    columns: [
                      DataColumn(
                          label: Text('Name'),
                          numeric: false,
                          tooltip: 'This is the name of the student'),
                      DataColumn(
                          label: Text('Index No.'),
                          numeric: false,
                          tooltip: 'This is the index number of the student'),
                      DataColumn(
                        label: Text('Attended'),
                        numeric: true,
                        tooltip:
                            'This is the total amount of times the student has attended the class',
                      ),
                      DataColumn(
                          label: Text('Missed'),
                          numeric: true,
                          tooltip:
                              'This is the total amount of times the student has missed class')
                    ],
                    rows: _studentList
                        .map(
                          (student) => DataRow(cells: [
                            DataCell(
                              Text(student.name.toUpperCase()),
                              //
                            ),
                            DataCell(
                              Text(student.indexNumber),
                            ),
                            DataCell(
                              Text(student.attended.toString()),
                            ),
                            DataCell(
                              Text(student.missed.toString()),
                            ),
                          ]),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
