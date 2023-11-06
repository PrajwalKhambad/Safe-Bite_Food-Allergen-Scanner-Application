import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  final TextEditingController _savecontroller = TextEditingController();
  String nameOfProduct = '';

  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      textScanning = false;
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
                        url =
                            'http://192.168.0.103:5000/api?query=$scannedText';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          imageFile == null
          ? showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                content: Padding(
                  padding:const EdgeInsets.all(4),
                  child: Text("No scanned Image found\nFirst Scan an image", style: customTextStyle_normal.apply(color: Colors.red),)),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child:const Text("OK"))
                ],
              );
            })
          )
          : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Save AS"),
                content: TextField(
                  controller: _savecontroller,
                  decoration: const InputDecoration(
                      labelText: "Enter the name of the product",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          nameOfProduct = _savecontroller.text;
                        });
                        save_scan_toFirebase();
                        _savecontroller.text = '';
                        Navigator.of(context).pop();
                      },
                      child: const Text("Save"))
                ],
              );
            },
          );
        },
        elevation: 4,
        backgroundColor: const Color(0xFF4682A9),
        child: const Icon(Icons.save),
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

  Future<void> save_scan_toFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && imageFile != null) {
        final email = user.email;
        final userDoc =
            FirebaseFirestore.instance.collection('scans').doc(email);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('scannedImages/$email/$nameOfProduct.jpg');
        await storageRef.putFile(File(imageFile!.path));

        final imageUrl = await storageRef.getDownloadURL();

        final currentTime = Timestamp.now();

        await userDoc.collection('scansOfthatUser').add({
          'nameOfProduct': nameOfProduct,
          'scannedImageurl': imageUrl,
          'predictedAllergies': ['Soy', "milk"],
          'isSafe': true,
          'timestamp': currentTime
        });
      }

      setState(() {
        textScanning = false;
        imageFile = null;
        scannedText = '';
      });
    } catch (e) {
      print("Error saving scan: $e");
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
