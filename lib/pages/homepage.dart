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
  bool checkScanning = false;
  bool isChecked = false;
  XFile? imageFile;
  String scannedText = "";
  String url = "";
  // String ingredients = "";
  var data;
  List<String> tempAllergies = ["Milk", "Nut", "Gluten", "Fish"];
  List<dynamic> predictedAllergies = [];
  List<String> allergies = [];
  String causing = "";
  List<dynamic> ingredient_causing = [];

  final TextEditingController _savecontroller = TextEditingController();
  String nameOfProduct = '';
  bool isSafe = true;

  Future<void> handleRefresh(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
    setState(() {
      textScanning = false;
      imageFile = null;
      scannedText = '';
      predictedAllergies = [];
      allergies = [];
      isSafe = true;
      causing = "";
      ingredient_causing = [];
      nameOfProduct = '';
      data = null;
      isChecked = false;
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
        actions: [
          IconButton(onPressed: (){
            handleRefresh(2);
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(
        height: double.infinity,
        color: customBackgroundColor,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (textScanning) const CircularProgressIndicator(color: Color(0xFF4682A9),),
                  if (!textScanning && imageFile == null)
                    Container(
                      width: 300,
                      height: 300,
                      color: Colors.grey.shade400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:const [
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
                  ElevatedButton(
                    style: customElevatedButtonStyle(150, 50),
                    onPressed: () async {
                      setState(() {
                        checkScanning= true;
                      });

                      url = 'http://192.168.0.104:5000/api?query=$scannedText';
                      data = await fetchData(url);
                      var decoded = jsonDecode(data);
                      setState(() {
                        // ingredients = decoded['extracted_ingredients'];
                        predictedAllergies = decoded['predicted_allergies'];
                        print("Allergies:$predictedAllergies");

                        for (int i = 0; i < predictedAllergies.length; i++) {
                          if (predictedAllergies[i] == 1) {
                            allergies.add(tempAllergies[i]);
                          }
                        }

                        isChecked = true;
                        ingredient_causing = decoded['ingredients'];
                        checkScanning = false;
                      });
                      checkIfisSafe();
                    },
                    child: const Text("Check"),
                  ),
                  const SizedBox(height: 20,),
                  isChecked
                  ? Container(
                      padding:const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:const Color(0xFF749BC2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Predicted Allergies: ${allergies.join(", ")}",
                            style: customTextStyle_normal.copyWith(color: Colors.white, fontSize: 20)
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding:const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFF6F4EB),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                isSafe
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 50,
                                  )
                                : const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                            const SizedBox(height: 10),
                            isSafe
                                ? const Text(
                                    "You are safe to eat it!",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    "You are allergic to $causing",
                                    style:const TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                  Text("The allergy causing ingredient is ${ingredient_causing.join(",")}",
                                  style:const TextStyle(
                                      fontSize: 20,
                                      // color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                    : checkScanning ? const CircularProgressIndicator(color: Color(0xFF4682A9),)
                                    : Container()
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          (imageFile == null)
              ? showDialog(
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      content: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "No scanned Image found\nFirst Scan an image",
                            style:
                                customTextStyle_normal.apply(color: Colors.red),
                          )),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ],
                    );
                  }))
              : (!isChecked)
              ? showDialog(
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      content: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            "First Check if the allergy is present or not",
                            style:
                                customTextStyle_normal.apply(color: Colors.red),
                          )),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ],
                    );
                  }))
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
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
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Scan saved successfulyy")));
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
          'predictedAllergies': allergies,
          'isSafe': isSafe,
          'timestamp': currentTime
        });
      }

      setState(() {
        handleRefresh(0);
      });
    } catch (e) {
      print("Error saving scan: $e");
    }
  }

  Future<void> checkIfisSafe() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final firestore = FirebaseFirestore.instance;

    List<dynamic> userAllergies = [];

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('users').doc(user.email).get();
      userAllergies = snapshot.data()!['Allergies'];
    }

    for (String allergy in allergies) {
      if (userAllergies.contains(allergy)) {
        setState(() {
          isSafe = false;
          causing = '$causing $allergy, ';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
