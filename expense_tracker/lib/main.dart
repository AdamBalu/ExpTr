import 'package:camera/camera.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'color_schemes.g.dart';
import 'common/service/ioc_container.dart';
import 'login/widget/auth_page.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //var idk = await Permission.contacts.request();
  //var status = await Permission.camera.status;
  _cameras = await availableCameras();

  /*if (status.isGranted) {
    _cameras = await availableCameras();
  } else {
    if (await Permission.contacts.request().isGranted) {
      _cameras = await availableCameras();
    }
    print("Camera rights not granted.");
  }*/

  IoCContainer.initialize(_cameras);

  runApp(
    MaterialApp(
      builder: FToastBuilder(),
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const AuthPage(),
    ),
  );
}
