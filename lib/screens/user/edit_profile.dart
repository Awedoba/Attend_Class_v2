import 'dart:io';
import 'package:attend_classv2/models/user_model.dart';
import 'package:attend_classv2/services/database_services.dart';
import 'package:attend_classv2/services/storage_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  EditProfileScreen({this.user});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  // String _name, _bio='';
  String _faceImageUrl = '';
  File _faceImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // _name = widget.user.name;
    // _bio = widget.user.bio;
  }

  // gets am image form the gallary and puts it in the _faceImage variable
  _handleImageFromGallary() async {
    File imagePicker = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      setState(() {
        _faceImage = imagePicker;
      });
    }
  }

  //checks all all cases
  _displayProfileImage() {
    //no new image
    if (_faceImage == null) {
      //user has no exiting  profile image
      if (widget.user.faceId.isEmpty) {
        return AssetImage('assets/images/user_placeholder.jpg');
      }
      // user has profile image
      else {
        return CachedNetworkImageProvider(
          widget.user.faceId,
        );
        // return widget.user.faceId;
      }
    }
    //new image
    else {
      return FileImage(_faceImage);
    }
  }

  _sumbit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      if (_faceImage == null) {
        _faceImageUrl = widget.user.faceId;
      } else {
        _faceImageUrl = await StorageService.uploadUserProfileImage(
          widget.user.faceId,
          _faceImage,
        );
      }
      //update user in database
      User user = User(id: widget.user.id, faceId: _faceImageUrl);
      DataBaseServices.updateUser(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add FaceId Picture',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Container(
              padding: EdgeInsets.all(30.0),
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _displayProfileImage(),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                    // CircleAvatar(
                    //   backgroundImage: _displayProfileImage(),
                    //   radius: 60,
                    // ),
                    FlatButton(
                      child: Text(
                        'Add Faceid picture',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: _handleImageFromGallary,
                    ),
                    Container(
                      height: 40.0,
                      width: 250.0,
                      margin: EdgeInsets.all(40.0),
                      color: Colors.blue,
                      child: FlatButton(
                        child: Text(
                          'save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _sumbit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
