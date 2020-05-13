import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _fireStore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _fireStore.collection('users');
final attendanceLog = _fireStore.collection('attendaceLog');
final currentUser = FirebaseAuth.instance.currentUser();
