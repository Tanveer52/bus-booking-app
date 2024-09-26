import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  File? profilePic;
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    profilePic = File(pickedImage.path);
  }
  return profilePic;
}
