import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  StorageService() {}

  Future<String> uploadUserPfp({
    required File file,
    required String uId,
  }) async {
    try {
      Reference fileRef = _firebaseStorage
          .ref('users/pfps')
          .child('$uId${p.extension(file.path)}');

      UploadTask task = fileRef.putFile(file);

      TaskSnapshot snapshot = await task;

      if (snapshot.state == TaskState.success) {
        String downloadUrl = await fileRef.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception('File upload failed: ${snapshot.state}');
      }
    } catch (e) {
      print('Error occurred during file upload: $e');
      throw e;
    }
  }

  Future<String?> uploadImageToChat(
      {required File file, required String chatID}) async {
    try {
      Reference fileRef = _firebaseStorage.ref("chats/$chatID").child(
          "${DateTime.now().toIso8601String()}${p.extension(file.path)}");

      UploadTask task = fileRef.putFile(file);

      TaskSnapshot snapshot = await task;

      if (snapshot.state == TaskState.success) {
        String downloadUrl = await fileRef.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception('File upload failed: ${snapshot.state}');
      }
    } catch (e) {
      print('Error occurred during file upload: $e');
      throw e;
    }
  }
}
