import 'package:flutter/material.dart';

class ConfirmationWedget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String subText;
  ConfirmationWedget({this.title, this.subText, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              this.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.black,
          ),
          Text(
            this.subText,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                onPressed: onPressed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                padding: const EdgeInsets.all(14.0),
                child: Text('Yes'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.red,
                textColor: Colors.white,
                padding: const EdgeInsets.all(14.0),
                child: Text('No'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
