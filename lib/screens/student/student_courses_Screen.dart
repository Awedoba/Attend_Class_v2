import 'dart:io';
import 'package:attend_classv2/screens/lecturer/add_to_attendance_log.dart';
import 'package:attend_classv2/screens/student/Student_course_details_screen.dart';
import 'package:attend_classv2/screens/user/profile.dart';
import 'package:attend_classv2/services/auth_services.dart';
import 'package:attend_classv2/services/compare_faces.dart';
import 'package:attend_classv2/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class StudentCoursesScreen extends StatefulWidget {
  final String userId;
  StudentCoursesScreen({this.userId});

  @override
  _StudentCoursesScreenState createState() => _StudentCoursesScreenState();
}

class _StudentCoursesScreenState extends State<StudentCoursesScreen> {
  final double confidenceStore = 80;
  GeoPoint _classLocation;
  File _image;
  // File _verifingImage;
  String _verifingImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _showSnackBar(
    String content,
    Color color,
  ) {
    final snackbar = SnackBar(
      content: Text(content),
      duration: Duration(seconds: 3),
      backgroundColor: color,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _image = image;
  }

  @override
  void initState() {
    super.initState();
  }

  // verifyFaces() async {
  //   // File first = _verifingImage;
  //   String first = _verifingImage;
  //   File second = _image;
  //   print('first $first');
  //   print('second $second');
  //   Uri uri = Uri.parse('https://api-us.faceplusplus.com/facepp/v3/compare');

  //   http.MultipartRequest request = new http.MultipartRequest('POST', uri);
  //   request.fields['api_key'] = apiKey;
  //   request.fields['api_secret'] = apiSecret;
  //   request.fields['image_url1'] = first;
  //   // request.files.add(await http.MultipartFile.fromPath(
  //   //     // 'image_file1',
  //   //     'image_url1',
  //   //     first
  //   //     // .path
  //   //     ,
  //   //     contentType: new MediaType('application', 'x-tar')));
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'image_file2', second.path,
  //       contentType: new MediaType('application', 'x-tar')));
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     var result = await http.Response.fromStream(response);
  //     // var response = await http.get(request);
  //     var resultToJson = jsonDecode(result.body);
  //     // var result = jsonDecode(response.body);
  //     return resultToJson;
  //   } else {
  //     return 'Error';
  //   }
  // }

  _getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // print("position $position");
    GeoPoint location = new GeoPoint(position.latitude, position.longitude);
    print("location: $location");
    return location;
  }

  //get the distance between the student location and the class location
  _getDistance(GeoPoint classLocation) async {
    GeoPoint studentLocation = await _getCurrentLocation();
    double distanceInMeters = await Geolocator().distanceBetween(
        studentLocation.latitude,
        studentLocation.longitude,
        classLocation.latitude,
        classLocation.longitude);
    print(distanceInMeters);
    return distanceInMeters;
  }

  //check if the distance is less that ten meters
  isInRange(GeoPoint classLocation) async {
    double distance = await _getDistance(classLocation);
    print("distance: $distance");
    if (distance <= 10) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog verifyStudentProgress = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    verifyStudentProgress.style(message: 'Verifying student ...');
    // print(studentgroup['studentGroup']);

// ///////////////////////////////////////////////////////////////////////////////////////////////////////

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
// pass image in
    Widget displayActiveCourse({
      course,
      studentName,
      indexnumber,
      currentTotal,
      studentGroup,
      lecturerId,
      GeoPoint classLocation,
    }) {
      return InkWell(
        onDoubleTap: () {
          // student is in class allow  face verification
          // print(classLocation.latitude);
          isInRange(classLocation).then((inRange) {
            if (inRange) {
              print(inRange);
              getImage().then((pic) {
                // print('take pic: $_image');
                // print('pic database: $_verifingImage');
                if (_image != null) {
                  if (_verifingImage != null) {
                    verifyStudentProgress.show();
                    // verify face

                    CompareFaces.verifyFaces(_verifingImage, _image)
                        .then((result) {
                      print(result);

                      if (result.containsKey('confidence')) {
                        print('confidence');
                        if (result['confidence'] >= confidenceStore) {
                          DataBaseServices.attendClass(
                            courseId: course.documentID,
                            studentName: studentName,
                            indexnumber: indexnumber,
                            currentTotal: currentTotal,
                            studentGroup: studentGroup,
                            lecturerId: lecturerId,
                          );
                          // verifyStudentProgress.hide();
                          _showSnackBar('Success', Colors.green);
                          print('you have attended class');
                        } else {
                          _showSnackBar(
                              'Failed: faces similarity too low', Colors.green);
                        }
                      } else if ((result['faces1'].isEmpty) |
                          (result['faces2'].isEmpty)) {
                        print('no faces');
                        // verifyStudentProgress.hide();
                        _showSnackBar('Failed: No faces found', Colors.red);
                        // cant find face
                      } else {
                        // verifyStudentProgress.hide();
                        _showSnackBar('Failed: No matching faces', Colors.red);
                      }
                      verifyStudentProgress.hide();
                    });
                  }
                }
              });
            } else {
              // not in range od the lecturer
              print(inRange);
            }
          });
          //

          // DataBaseServices.attendClass(
          //   courseId: course.documentID,
          //   studentName: studentName,
          //   indexnumber: indexnumber,
          //   currentTotal: currentTotal,
          //   studentGroup: studentGroup,
          //   lecturerId: lecturerId,
          // );
          // print('you have attended class');
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

    // ///////////////////////////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Courses'),
        centerTitle: true,
        leading: FlatButton(
            // color: Colors.black,
            // child: Text('home'),
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
            onPressed: () {
              print('object');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ProfileScreen(
                    userId: widget.userId,
                  ),
                ),
              );
            }),
        actions: <Widget>[
          FlatButton(
            // color: Colors.black,
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
          stream: DataBaseServices.getCoursesStream(widget.userId),
          // usersRef
          //     .document(widget.userId)
          //     .collection('courses')
          //     .snapshots(),
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
                    String courseId = courses[index].documentID.trim();
                    // is the course active
                    return StreamBuilder(
                      stream: DataBaseServices.getCourseStream(
                          lecturerId, courseId),
                      // usersRef
                      //     .document(lecturerId)
                      //     .collection('courses')
                      //     .document(coursesId)
                      //     .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        bool isActive = snapshot.data['isActive'];
                        String classActiveFor = snapshot.data['for'];
                        int currentTotal =
                            snapshot.data['$classActiveFor' + 'Total'];
                        var location = snapshot.data['classLocation'];
                        // GeoPoint classLocation = new snapshot.data['classLocation'];
                        // print('location lat of class: $location');
                        // print(location.longitude);

                        //  is the student a moring evening etc.
                        return FutureBuilder(
                          future: DataBaseServices.getUser(widget.userId),
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
                              _verifingImage = snapshot.data['faceId'];
                              _classLocation = new GeoPoint(
                                location.latitude,
                                location.longitude,
                              );
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: displayActiveCourse(
                                  course: courses[index],
                                  studentName: name,
                                  studentGroup: classActiveFor,
                                  lecturerId: lecturerId,
                                  indexnumber: indexNumber,
                                  currentTotal: currentTotal,
                                  classLocation: _classLocation,
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

//   Widget displayCourse(
//     course,
//   ) {
//     return InkWell(
//       onTap: () => Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (BuildContext context) => StudentCourseDetail(
//             courseId: course.documentID,
//             lecturerId: course.data['lecturerId'],
//             courseName: course.data['name'],
//             studentId: widget.userId,
//           ),
//         ),
//       ),
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         child: ListTile(
//           title: Text(
//             course.data['name'],
//             style: TextStyle(fontSize: 16),
//           ),
//           subtitle: Text(course.data['lecturerName']),
//           trailing: Text(
//             course.documentID,
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x20000000),
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// // ///////////////////////////////////////////
// // pass image in
//   Widget displayActiveCourse({
//     course,
//     studentName,
//     indexnumber,
//     currentTotal,
//     studentGroup,
//     lecturerId,
//     GeoPoint classLocation,
//   }) {
//     return InkWell(
//       onDoubleTap: () {
//         // student is in class allow  face verification
//         // print(classLocation.latitude);
//         isInRange(classLocation).then((inRange) {
//           if (inRange) {
//             print(inRange);
//             getImage().then((pic) {
//               // print('take pic: $_image');
//               // print('pic database: $_verifingImage');
//               if (_image != null) {
//                 if (_verifingImage != null) {
//                   // verify face
//                   verifyFaces().then((result) {
//                     print(result);

//                     if (result.containsKey('confidence')) {
//                       print('confidence');
//                       if (result['confidence'] >= confidenceStore) {
//                         DataBaseServices.attendClass(
//                           courseId: course.documentID,
//                           studentName: studentName,
//                           indexnumber: indexnumber,
//                           currentTotal: currentTotal,
//                           studentGroup: studentGroup,
//                           lecturerId: lecturerId,
//                         );
//                         print('you have attended class');
//                       }
//                     } else if ((result['faces1'].isEmpty) |
//                         (result['faces2'].isEmpty)) {
//                       print('no faces');
//                       // cant find face
//                     } else {
//                       print('${result['faces1']}');
//                     }
//                   });
//                 }
//               }
//             });
//           } else {
//             // not in range od the lecturer
//             print(inRange);
//           }
//         });
//         //

//         // DataBaseServices.attendClass(
//         //   courseId: course.documentID,
//         //   studentName: studentName,
//         //   indexnumber: indexnumber,
//         //   currentTotal: currentTotal,
//         //   studentGroup: studentGroup,
//         //   lecturerId: lecturerId,
//         // );
//         // print('you have attended class');
//       },
//       onLongPress: () {
//         setState(() {
//           showDialog(
//               barrierDismissible: true,
//               context: context,
//               builder: (BuildContext context) {
//                 return Dialog(
//                   child: AddToAttendanceList(
//                     courseId: course.documentID,
//                     studentGroup: studentGroup,
//                     currentTotal: currentTotal,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                   ),
//                 );
//               });
//           // checkIfClassStart();
//         });
//       },
//       onTap: () => Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (BuildContext context) => StudentCourseDetail(
//             courseId: course.documentID,
//             lecturerId: course.data['lecturerId'],
//             courseName: course.data['name'],
//             studentId: widget.userId,
//           ),
//         ),
//       ),
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         child: ListTile(
//           title: Text(
//             course.data['name'],
//             style: TextStyle(fontSize: 16),
//           ),
//           subtitle: Text(course.data['lecturerName']),
//           trailing: Text(
//             course.documentID,
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         decoration: BoxDecoration(
//           color: Colors.green,
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x20000000),
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
}
