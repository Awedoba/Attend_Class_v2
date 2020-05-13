import 'package:attend_classv2/utilities/constants.dart';
import 'package:flutter/material.dart';

class AttendanceLogScreen extends StatefulWidget {
  //lecturerid course and studentgrup
  final String userId, courseId, studentGroup;
  AttendanceLogScreen({this.userId, this.courseId, this.studentGroup});
  @override
  _AttendanceLogScreenState createState() => _AttendanceLogScreenState();
}

class _AttendanceLogScreenState extends State<AttendanceLogScreen> {
  // List studentList;
  bool sort;
  @override
  void initState() {
    sort = false;
    super.initState();
    // studentList = getStudentList();
    // getStudentList();
  }

  // Future getStudentList() async {
  //   String attendanceLogId = widget.userId.trim() +
  //       '_' +
  //       widget.courseId.trim() +
  //       '_' +
  //       widget.studentGroup;
  //   QuerySnapshot qShot =
  //       await Firestore.instance.collection(attendanceLogId).getDocuments();
  //   studentList = qShot.documents;
  //   // return qShot.documents;
  // }

  @override
  Widget build(BuildContext context) {
    String attendanceLogId = widget.userId.trim() +
        '_' +
        widget.courseId.trim() +
        '_' +
        widget.studentGroup;
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    "Morning Group A",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
              // DataTable(
              //   columns: [
              //     DataColumn(
              //         label: Text('Name'),
              //         numeric: false,
              //         tooltip: 'This is the name of the student'),
              //     DataColumn(
              //         label: Text('Index No.'),
              //         numeric: false,
              //         tooltip: 'This is the index number of the student'),
              //     DataColumn(
              //         label: Text('Attended'),
              //         numeric: false,
              //         tooltip:
              //             'This is the total amount of times the student has attended the class'),
              //     DataColumn(
              //         label: Text('Missed'),
              //         numeric: false,
              //         tooltip:
              //             'This is the total amount oftimes the student has missed class')
              //   ],
              //   rows: studentList
              //       .map(
              //         (student) => DataRow(cells: [
              //           DataCell(
              //             Text(student.data['name']),
              //           ),
              //           DataCell(
              //             Text(student.data['indexNumber']),
              //           ),
              //           DataCell(
              //             Text(student.data['attended']),
              //           ),
              //           DataCell(
              //             Text(student.data['missed']),
              //           ),
              //         ]),
              //       )
              //       .toList(),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(left: 7, right: 7),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: <Widget>[
              //       // student name
              //       Expanded(
              //         flex: 3,
              //         child: Text("Name"),
              //       ),
              //       // index number
              //       Expanded(
              //         flex: 2,
              //         child: Text("Index NUmber"),
              //       ),
              //       // days present
              //       Expanded(
              //         flex: 1,
              //         child: Text("Attended"),
              //       ),
              //       // days absent
              //       Expanded(
              //         flex: 1,
              //         child: Text("Missed"),
              //       ),
              //       SizedBox(
              //         height: 25,
              //       ),
              //     ],
              //   ),
              // ),
              // Flexible(
              //   child: ListView.builder(
              //     itemCount: _students.length,
              //     itemBuilder: (context, index) {
              //       // if (!(_courseList[index].active)) {}
              //       return _studentList(_students[index]);
              //     },
              //   ),
              // ),
              FutureBuilder(
                future: attendanceLog
                    .document(attendanceLogId)
                    .collection('students')
                    .getDocuments(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List studentList = snapshot.data.documents;
                  return DataTable(
                    // sortAscending: false,
                    // sortColumnIndex: 0,
                    columnSpacing: 18,
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
                        // onSort: (columnIndex, ascending) {
                        //   setState(() {
                        //     sort = !sort;
                        //     print(sort);
                        //   });
                        //   if (columnIndex == 2) {
                        //     // print('object');
                        //     if (ascending) {
                        //       studentList.sort((a, b) => a.data['attended']
                        //           .compareTo(b.data['attended']));
                        //     } else {
                        //       studentList.sort((a, b) => b.data['attended']
                        //           .compareTo(a.data['attended']));
                        //     }
                        //   }
                        // },
                      ),
                      DataColumn(
                          label: Text('Missed'),
                          numeric: true,
                          tooltip:
                              'This is the total amount of times the student has missed class')
                    ],
                    rows: studentList
                        .map(
                          (student) => DataRow(cells: [
                            DataCell(
                              Text(student.data['name']),
                            ),
                            DataCell(
                              Text(student.data['indexNumber']),
                            ),
                            DataCell(
                              Text(student.data['attended'].toString()),
                            ),
                            DataCell(
                              Text(student.data['missed'].toString()),
                            ),
                          ]),
                        )
                        .toList(),
                  );
                  // Container(
                  //   padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  //   child: ListView.builder(
                  //       itemCount: students.length,
                  //       itemBuilder: (context, index) {
                  //         return Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: _studentList(students[index]),
                  //         );
                  //         // ListTile(
                  //         //   title: Text(courses[index].data['name']),
                  //         // );
                  //       }),
                  // );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _studentList(student) {
  //   String indexNumber = student.data['indexNumber'].toString();
  //   String attended = student.data['attended'].toString();
  //   String missed = student.data['missed'].toString();
  //   String name = student.data['name'];
  //   return Column(
  //     children: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
  //         child: Container(
  //           padding: EdgeInsets.all(5.0),
  //           decoration: BoxDecoration(color: Colors.white, boxShadow: [
  //             BoxShadow(
  //               color: Color(0x20000000),
  //               blurRadius: 5,
  //               offset: Offset(0, 3),
  //             ),
  //           ]),
  //           // padding: EdgeInsets.only(
  //           //   top: 10,
  //           //   bottom: 10,
  //           // ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: <Widget>[
  //               // student name
  //               Expanded(
  //                 flex: 3,
  //                 child: Text(name),
  //               ),
  //               // index number
  //               Expanded(
  //                 flex: 2,
  //                 child: Text("$indexNumber"),
  //               ),
  //               // days present
  //               Expanded(
  //                 flex: 1,
  //                 child: Text("$attended"),
  //               ),
  //               // days absent
  //               Expanded(
  //                 flex: 1,
  //                 child: Text("$missed"),
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       // Divider(
  //       //   height: 1,
  //       //   color: Colors.black,
  //       // ),
  //     ],
  //   );
  // }
}
