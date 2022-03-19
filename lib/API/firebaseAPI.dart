import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException {
      return null;
    }
  }

  static Future<void> deleteFile(String url) {
    try {
      return FirebaseStorage.instance.refFromURL(url).delete();
    } on FirebaseException catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }
}
