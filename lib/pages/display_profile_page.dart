import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_bite/pages/update_profile.dart';
import 'package:safe_bite/themes.dart';

class My_Profile_Page extends StatefulWidget {
  const My_Profile_Page({super.key});

  @override
  State<My_Profile_Page> createState() => _My_Profile_PageState();
}

class _My_Profile_PageState extends State<My_Profile_Page> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String _email = "Email";
  String name = "Name";
  String firstname = "";
  String surname = "";
  int age = 0;
  String gender = "Gender";
  List<dynamic> allergies = [];
  List<dynamic> dietaryPref = [];
  String profilePicUrl = "";

  bool isLoading = false;

  Future<void> getData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email!;
      });
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(_email).get();
      if (snapshot.exists) {
        print("Snapshot exists");
        setState(() {
          firstname = snapshot.data()!['Name'];
          surname = snapshot.data()!['Surname'];
          name = "$firstname $surname";
          age = snapshot.data()!['Age'];
          gender = snapshot.data()!['Gender'];
          allergies = snapshot.data()!['Allergies'];
          dietaryPref = snapshot.data()!['Dietary_Pref'];
          profilePicUrl = snapshot.data()!['profileImageUrl'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> pick_and_uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        isLoading = true;
      });

      final File imageFile = File(pickedFile.path);
      final storage = FirebaseStorage.instance;
      Reference storageRef = storage.ref().child('profile_images/$_email.jpg');
      await storageRef.putFile(imageFile);

      String downloadUrl = await storageRef.getDownloadURL();
      _firestore
          .collection('users')
          .doc(_email)
          .update({'profileImageUrl': downloadUrl});

      setState(() {
        profilePicUrl = downloadUrl;
        isLoading = false;
      });
    }
  }

  Future<void> openEditDialog(String dialogTitle, String labelText,
      Function(String) onInfoChanged) async {
    final newInfo = await showDialog<String>(
      context: context,
      builder: (context) {
        return EditInfoDialog(
          currentInfo: dialogTitle == 'Name'
              ? name
              : dialogTitle == 'Age'
                  ? age.toString()
                  : gender,
          onInfoChanged: onInfoChanged,
          dialogTitle: dialogTitle,
          labelText: labelText,
        );
      },
    );

    if (newInfo != null) {
      onInfoChanged(newInfo);
    }
  }

  Future<void> openEditNameDialog(
      Function(String, String) onNameChanged) async {
    final newName = await showDialog<List>(
        context: context,
        builder: (context) {
          return EditName(
            currFirstName: firstname,
            currSurname: surname,
            onNameChanged: onNameChanged,
          );
        });

    if (newName != null) {
      onNameChanged(newName[0], newName[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Your Profile",
        style: customTextStyle_appbar,
      )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 4,
              child: Container(
                color: customBackgroundColor,
                width: double.infinity,
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(alignment: Alignment.center, children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 4)),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF749BC2),
                          radius: 70,
                          backgroundImage: profilePicUrl.isNotEmpty
                              ? NetworkImage(profilePicUrl)
                              : null,
                        ),
                      ),
                      if (isLoading) const CircularProgressIndicator()
                    ]),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        color: const Color(0xFF749BC2),
                        onPressed: () {
                          pick_and_uploadImage();
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 4,
              // margin: EdgeInsets.all(10),
              child: Container(
                color: customBackgroundColor,
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name:  $name",
                        style:
                            customTextStyle_normal.apply(color: Colors.black)),
                    TextButton(
                        onPressed: () {
                          openEditNameDialog((fname, lastname) {
                            setState(() {
                              firstname = fname;
                              surname = lastname;
                              name = "$firstname $surname";
                              _firestore
                                  .collection('users')
                                  .doc(_email)
                                  .update({"Name": firstname});
                              _firestore
                                  .collection('users')
                                  .doc(_email)
                                  .update({"Surname": surname});
                            });
                          });
                        },
                        child:const Text("Edit", style: TextStyle(color: Color(0xFF749BC2)),))
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    // margin: EdgeInsets.all(10),
                    child: Container(
                      color: customBackgroundColor,
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Gender:  $gender",
                              style: customTextStyle_normal.apply(
                                  color: Colors.black)),
                          TextButton(
                              onPressed: () {
                                openEditDialog('Gender', 'Enter you gender',
                                    (newGender) {
                                  setState(() {
                                    gender = newGender;
                                    _firestore
                                        .collection('users')
                                        .doc(_email)
                                        .update({"Gender": gender});
                                  });
                                });
                              },
                              child:const Text("Edit", style: TextStyle(color: Color(0xFF749BC2))))
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    // margin: EdgeInsets.all(10),
                    child: Container(
                      color: customBackgroundColor,
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Age:  $age",
                              style: customTextStyle_normal.apply(
                                  color: Colors.black)),
                          TextButton(
                              onPressed: () {
                                openEditDialog('Age', 'Enter you age',
                                    (newAge) {
                                  setState(() {
                                    age = int.parse(newAge);
                                    _firestore
                                        .collection('users')
                                        .doc(_email)
                                        .update({"Age": age});
                                  });
                                });
                              },
                              child:const Text("Edit", style: TextStyle(color: Color(0xFF749BC2))))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
              color: Colors.white,
              elevation: 4,
              // margin: EdgeInsets.all(10),
              child: Container(
                color: customBackgroundColor,
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Allergies:",
                          style:
                              customTextStyle_normal.apply(color: Colors.black),
                        ),
                        TextButton(onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AddAllergiesDialog(
                                allergies: allergies,
                                onAllergiesUpdated: (newAllergies){
                                  setState(() {
                                    allergies = newAllergies;
                                    _firestore.collection('users').doc(_email).update({"Allergies": allergies});
                                  });
                                },
                              );
                            },
                          );
                        }, child: const Text("Add", style: TextStyle(color: Color(0xFF749BC2)))),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        children: allergies.map((allergen) {
                          return Chip(
                            onDeleted: (){
                              setState(() {
                                allergies.remove(allergen);
                                _firestore.collection('users').doc(_email).update({"Allergies":allergies});
                              });
                            },
                            deleteIcon:const Icon(Icons.delete, size: 15,),
                            backgroundColor:const Color(0xFF749BC2),
                            labelStyle:const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side:const BorderSide(color: Color(0xFF749BC2))),
                            label: Text(allergen),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 4,
              // margin: EdgeInsets.all(10),
              child: Container(
                color: customBackgroundColor,
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dietary Preferences:",
                          style:
                              customTextStyle_normal.apply(color: Colors.black),
                        ),
                        TextButton(onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AddDietaryPrefDialog(
                                prefs: dietaryPref,
                                onprefsUpdated: (newPrefs){
                                  setState(() {
                                    dietaryPref = newPrefs;
                                    _firestore.collection('users').doc(_email).update({"Dietary_Pref": dietaryPref});
                                  });
                                },
                              );
                            },
                          );
                        }, child: const Text("Add", style: TextStyle(color: Color(0xFF749BC2)))),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        children: dietaryPref.map((allergen) {
                          return Chip(
                            onDeleted: (){
                              setState(() {
                                dietaryPref.remove(allergen);
                                _firestore.collection('users').doc(_email).update({"Dietary_Pref":dietaryPref});
                              });
                            },
                            deleteIcon:const Icon(Icons.delete, size: 15,),
                            backgroundColor:const Color(0xFF749BC2),
                            labelStyle:const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side:const BorderSide(color: Color(0xFF749BC2))),
                            label: Text(allergen),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
