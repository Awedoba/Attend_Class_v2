import 'package:attend_classv2/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class StartClass extends StatefulWidget {
  final String userId, courseId;
  StartClass({this.userId, this.courseId});
  @override
  _StartClassState createState() => _StartClassState();
}

class _StartClassState extends State<StartClass> {
  Position _position;
  _getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    _position = position;
  }

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
                          _getCurrentLocation();
                          if (_position != null) {
                            setState(() {
                              DataBaseServices.startClass(
                                userId: widget.userId,
                                courseId: widget.courseId,
                                studentGroup:
                                    studentGroups[index].data['group'],
                                position: _position,
                              );
                              Navigator.pop(context);
                            });
                          }
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
