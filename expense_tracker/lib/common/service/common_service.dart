import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonService {
  List<CameraDescription> cameras;
  CommonService(this.cameras);

  final FirebaseStorage _storage = FirebaseStorage.instance;

  String path = "";
  File? imageFile;

  Future<String> uploadImage(File image) async {
    final Reference reference = _storage.ref().child("images/${const Uuid().v4()}");
    await reference.putFile(image);
    return await reference.getDownloadURL();
  }

  void throwToastNotification(String message) {
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.TOP, fontSize: 16.0);
  }
}
