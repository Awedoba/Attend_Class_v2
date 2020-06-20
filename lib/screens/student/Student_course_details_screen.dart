import 'package:attend_classv2/services/database_services.dart';
import 'package:flutter/material.dart';

class StudentCourseDetail extends StatefulWidget {
  final String courseId, lecturerId, courseName, indexNumber, studentGroup;
  final int total;
  StudentCourseDetail(
      {this.courseId,
      this.lecturerId,
      this.courseName,
      this.indexNumber,
      this.studentGroup,
      this.total});
  // lecturerId.trim() + '_' + courseId.trim() + '_' + studentGroup
  @override
  _StudentCourseDetailState createState() => _StudentCourseDetailState();
}

class _StudentCourseDetailState extends State<StudentCourseDetail> {
  int _attended = 0, _missed = 0;

  @override
  void initState() {
    super.initState();
    setData().then((doc) {
      // print('hmm');
      if (doc.exists) {
        // print('object');
        setState(() {
          _attended = doc['attended'];
          _missed = doc['missed'];
        });
        print(_attended);
      }
    });
    // print("attend: $_attended");
  }

  setData() async {
    return await DataBaseServices.getAttendanceOfStudent(
      studentGroup: widget.studentGroup,
      lecturerId: widget.lecturerId,
      courseId: widget.courseId,
      indexNumber: widget.indexNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('Sg: ${widget.studentGroup}');
    // print('LID: ${widget.lecturerId}');
    // print('coursecode: ${widget.courseId}');
    // print('IN: ${widget.indexNumber}');
    print('total: ${widget.total}');
    // print('CN: ${widget.courseName}');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Attended',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$_attended',
                        // studentAttendance['attended'] != null
                        //     ? '${studentAttendance['attended']}'
                        //     : '0',
                        style: TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Missed',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$_missed',
                        // studentAttendance['missed'] != null
                        //     ? '${studentAttendance['missed']}'
                        //     : '0',
                        // studentAttendance.data['attended'] ?? 1,
                        style: TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                // Text('Missed'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Total Classes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.total != null ? '${widget.total}' : '0',
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
              // Text('Total'),
            ],
          ),
        ],
      ),
      // FutureBuilder(
      //     future: DataBaseServices.getAttendanceOfStudent(
      //       studentGroup: widget.studentGroup,
      //       lecturerId: widget.lecturerId,
      //       courseId: widget.courseId,
      //       indexNumber: widget.indexNumber,
      //     ),
      //     builder: (context, snapshot) {
      //       if (!snapshot.hasData) {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       // print(snapshot);

      //       // if (snapshot == null) {
      //       //   print('object');
      //       // }
      //       // var studentAttendance = snapshot.data;
      //       // print(studentAttendance);

      //       return Column(
      //         children: <Widget>[
      //           Padding(
      //             padding: const EdgeInsets.symmetric(
      //               vertical: 30,
      //             ),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: <Widget>[
      //                 Container(
      //                   padding:
      //                       EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      //                   child: Column(
      //                     children: <Widget>[
      //                       Text(
      //                         'Attended',
      //                         style: TextStyle(
      //                           fontSize: 20,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: 10,
      //                       ),
      //                       Text(
      //                         '$_attended',
      //                         // studentAttendance['attended'] != null
      //                         //     ? '${studentAttendance['attended']}'
      //                         //     : '0',
      //                         style: TextStyle(
      //                           fontSize: 20,
      //                           // fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Color(0x20000000),
      //                         blurRadius: 5,
      //                         offset: Offset(0, 3),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 Container(
      //                   padding:
      //                       EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      //                   child: Column(
      //                     children: <Widget>[
      //                       Text(
      //                         'Missed',
      //                         style: TextStyle(
      //                           fontSize: 20,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: 10,
      //                       ),
      //                       Text(
      //                         '$_missed',
      //                         // studentAttendance['missed'] != null
      //                         //     ? '${studentAttendance['missed']}'
      //                         //     : '0',
      //                         // studentAttendance.data['attended'] ?? 1,
      //                         style: TextStyle(
      //                           fontSize: 20,
      //                           // fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     boxShadow: [
      //                       BoxShadow(
      //                         color: Color(0x20000000),
      //                         blurRadius: 5,
      //                         offset: Offset(0, 3),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //                 // Text('Missed'),
      //               ],
      //             ),
      //           ),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: <Widget>[
      //               Container(
      //                 padding:
      //                     EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      //                 child: Column(
      //                   children: <Widget>[
      //                     Text(
      //                       'Total Classes',
      //                       style: TextStyle(
      //                         fontSize: 20,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                     SizedBox(
      //                       height: 10,
      //                     ),
      //                     Text(
      //                       widget.total != null ? '${widget.total}' : '0',
      //                       style: TextStyle(
      //                         fontSize: 20,
      //                         // fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   boxShadow: [
      //                     BoxShadow(
      //                       color: Color(0x20000000),
      //                       blurRadius: 5,
      //                       offset: Offset(0, 3),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               // Text('Total'),
      //             ],
      //           ),
      //         ],
      //       );
      //     }),
    );
  }
}
