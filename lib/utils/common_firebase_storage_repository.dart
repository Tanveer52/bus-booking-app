import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> storeFileToFirebase(
      {required File file, required String ref}) async {
    final UploadTask uploadTask =
        firebaseStorage.ref().child(ref).putFile(file);

    final TaskSnapshot taskSnapshot = await uploadTask;

    final String downloadedUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadedUrl;
  }
}
