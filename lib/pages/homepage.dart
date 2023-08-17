import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_bite/pages/login_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Safe-Bite", style: customTextStyle_appbar,),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(textScanning) const CircularProgressIndicator(),
                if(!textScanning && imageFile==null) Container(
                  width: 300,
                  height: 300,
                  color: Colors.grey,
                ),
                if(imageFile!=null) Image.file(File(imageFile!.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(onPressed: (){
                          getImage(ImageSource.gallery);
                        }, 
                        child: Icon(Icons.image),
                        style: customElevatedButtonStyle(30, 40),
                        ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(onPressed: (){
                          getImage(ImageSource.camera);
                        }, 
                        child: Icon(Icons.camera_alt),
                        style: customElevatedButtonStyle(30, 40),
                        ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  child: Text(scannedText),
                )
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        width: 200, //
        backgroundColor: customBackgroundColor,
        elevation: 20,
        child: Container(
          margin: EdgeInsets.symmetric(vertical:20, horizontal: 10),
          child: ListView(
            children: [
              Container(height: 150,),
              ElevatedButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const LoginForm()));
              }, 
              child: Text("HomePage"),
              style: customElevatedButtonStyle(double.infinity, 30),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){}, 
              child: Text("My Profile"),
              style: customElevatedButtonStyle(double.infinity, 30),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){}, 
              child: Text("Medicines"),
              style: customElevatedButtonStyle(double.infinity, 30),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){}, 
              child: Text("About"),
              style: customElevatedButtonStyle(double.infinity, 30),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){}, 
              child: Text("Exit"),
              style: customElevatedButtonStyle(double.infinity, 30),
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async{
    try{
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage != null){
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognizedText(pickedImage);
      }
    } catch(e){
        textScanning = false;
        imageFile = null;
        scannedText = "Error occured while scanning";
        setState(() {});
    }
  }

  void getRecognizedText(XFile image) async{
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }

    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}