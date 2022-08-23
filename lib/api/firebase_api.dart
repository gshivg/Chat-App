// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class FirebaseApi {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  static UploadTask? UploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException {
      return null;
    }
  }

  static UploadTask? UploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    } on FirebaseException {
      return null;
    }
  }

}
