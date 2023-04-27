import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FileUploadService{
  static final storageRef = FirebaseStorage.instance.ref();
  static final userEmail = FirebaseAuth.instance.currentUser!.email;

  static final fileRef = storageRef.child("$userEmail.mp3");

  static Future<String> uploadAudioFile(File audioFile) async {
    await fileRef.putFile(audioFile);
    fileRef.getDownloadURL().then((value) => print(value));
    return fileRef.getDownloadURL();
  }

}