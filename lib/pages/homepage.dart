import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_bite/fetch.dart';
import 'package:safe_bite/pages/homepage_drawer.dart';
import 'package:safe_bite/themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";
  String url = "";
  String ingredients = "";
  var data;

  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      imageFile = null;
      scannedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Safe-Bite",
          style: customTextStyle_appbar,
        ),
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: handleRefresh,
        child: Container(
          height: double.infinity,
          color: customBackgroundColor,
          child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.grey.shade400,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.image,
                            size: 100,
                          ),
                          Text(
                              "Scan an Image with Camera\nOR Add an image from gallery")
                        ],
                      ),
                    ),
                  ),
                if (imageFile != null) Image.file(File(imageFile!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        style: customElevatedButtonStyle(30, 40),
                        child: Icon(
                          Icons.image,
                          color: customBackgroundColor,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        style: customElevatedButtonStyle(30, 40),
                        child: Icon(
                          Icons.camera_alt,
                          color: customBackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  color: Colors.red,
                  margin: const EdgeInsets.all(8),
                  child: Text(scannedText),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("op");
                    url =
                        'http://192.168.0.103:5000/api?query=$scannedText';
                    print("url done");
                    data = await fetchData(url);
                    var decoded = jsonDecode(data);
                    print("doneee");
                    setState(() {
                      ingredients = decoded['extracted_ingredients'];
                      print(ingredients);
                    });
                  },
                  child: const Text("Extract"),
                ),
                Text("ingredients=    $ingredients")
              ],
            ),
          ),
        ),
          ),
        ),
      ),
      drawer: const HomePage_Drawer(),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        final croppedImage = await ImageCropper().cropImage(
            sourcePath: pickedImage.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: const AndroidUiSettings(
                toolbarTitle: ' Cropper',
                toolbarWidgetColor: Colors.white,
                toolbarColor: Color(0xFF4682A9),
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false));

        if (croppedImage != null) {
          textScanning = true;
          imageFile = XFile(croppedImage.path);
          setState(() {});
          getRecognizedText(imageFile!);
        }
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognizedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }

    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
