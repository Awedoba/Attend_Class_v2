import 'package:attend_classv2/services/database_services.dart';
import 'package:attend_classv2/utilities/constants.dart';
import 'package:flutter/material.dart';

class StartClass extends StatefulWidget {
  final String userId, courseId;
  final int totalClasses;
  StartClass({this.userId, this.courseId, this.totalClasses});
  @override
  _StartClassState createState() => _StartClassState();
}

class _StartClassState extends State<StartClass> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: usersRef
          .document(widget.userId)
          .collection('StudentGroup')
          .getDocuments(),
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
                          setState(() {
                            print(widget.totalClasses);
                            DataBaseServices.startClass(
                              userId: widget.userId,
                              courseId: widget.courseId,
                              totalClasses: widget.totalClasses,
                              studentGroup: studentGroups[index].data['group'],
                            );
                            Navigator.pop(context);
                          });
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
