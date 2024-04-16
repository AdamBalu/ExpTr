import 'package:camera/camera.dart';
import 'package:expense_tracker/common/service/common_service.dart';
import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'display_picture_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  final _commonService = get<CommonService>();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(_commonService.cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
    _controller.setFlashMode(FlashMode.off);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        // Force the widget to stay in portrait mode
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        return Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
              ),
            ),
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await _initializeControllerFuture;
                          final image = await _controller.takePicture();

                          if (!mounted) return;
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                imagePath: image.path,
                              ),
                            ),
                          );
                        } catch (e) {
                          _commonService.throwToastNotification("Camera initialization failed");
                        }
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
