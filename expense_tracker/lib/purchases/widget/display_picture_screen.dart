import 'dart:io';
import 'package:expense_tracker/common/service/common_service.dart';
import 'package:flutter/material.dart';

import '../../common/service/ioc_container.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final _commonService = get<CommonService>();

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
            ),
          ),
          Stack(children: [
            Image.file(File(widget.imagePath)),
            if (isSaving)
              Positioned.fill(
                child: Container(
                  height: 100,
                  color: const Color.fromRGBO(0, 0, 0, 0.4),
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  )),
                ),
              ),
          ]),
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isSaving = true;
                        });
                        _commonService.path = widget.imagePath;
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.check)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
