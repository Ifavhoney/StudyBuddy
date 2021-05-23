import 'dart:io';

import 'package:buddy/V2/other/sizeConfig.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadHelper {
  final String downloadLink;
  final String name;
  UploadHelper(this.downloadLink, this.name);

  static Future<UploadHelper> getImageUrl() async {
    File _image;

    final pickedFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: (SizeConfig.blockSizeHorizontal * 10) * 2,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print("success !!!");
    } else {
      print('No image selected.');
    }
    String fileName = _image.path.split("/").last;

    Reference ref = FirebaseStorage.instance.ref();
    UploadTask uploadTask = ref.child("profile/$fileName").putFile(_image);
    UploadHelper uploadHelper;

    await uploadTask.then((r) async {
      String url = await r.ref.getDownloadURL();
      uploadHelper = UploadHelper(url, fileName);
      return;
    });
    return uploadHelper;
  }
}
