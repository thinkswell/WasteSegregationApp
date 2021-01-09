import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  File imageFile;
  String status =
      'Click 👆 to select image of the waste then, Click 👇 to upload the image and get creative ideas to minimize wastes.';

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  _cropImage(filePath) async {
    try {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: filePath,
          maxHeight: 800,
          maxWidth: 800,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
      if (croppedImage != null) {
        imageFile = croppedImage;
        setState(() {});
      }
    } catch (err) {
      setStatus('Not able to crop the image due to error $err');
      print("Err in Camera.dart💥💥");
      print('Error Croping the file: $err');
    }
  }

  chooseImage(String s) async {
    PickedFile pickedFile;
    if (s == 'g') {
      pickedFile = await ImagePicker()
          .getImage(source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    } else {
      pickedFile = await ImagePicker()
          .getImage(source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    }

    _cropImage(pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waste Segregation App'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select an Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                ButtonBar(alignment: MainAxisAlignment.spaceEvenly, children: [
                  RaisedButton(
                    color: Colors.green,
                    onPressed: () => chooseImage('c'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Text('- or -'),
                  RaisedButton(
                    onPressed: () => chooseImage('g'),
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
            Divider(height: 10),
            Container(
              child: (imageFile == null)
                  ? Text("$status",
                      style: TextStyle(
                        fontSize: 20,
                      ))
                  : Container(
                      width: 400,
                      height: 400,
                      child: Image.file(imageFile),
                    ),
            ),
            Divider(height: 10),
            Container(
              child: imageFile == null
                  ? Text('')
                  : RaisedButton(
                      onPressed: () => setState(() {
                        imageFile = null;
                      }),
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ),
            RaisedButton(
              onPressed: () {
                if (imageFile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please select an image first.',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    backgroundColor: Colors.green,
                  ));
                } else {
                  Navigator.pushNamed(context, '/upload',
                      arguments: {'image': imageFile});
                }
              },
              color: Colors.white,
              elevation: 1.5,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Upload Image',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
