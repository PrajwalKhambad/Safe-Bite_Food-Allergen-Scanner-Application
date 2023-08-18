import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../themes.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const CircleAvatar()),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.orange),
                      child: const Icon(Icons.camera,
                          color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: iniName,
                            decoration: customTextFieldStyle(iniName),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter name";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              iniName = value!;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: surname,
                            decoration: customTextFieldStyle(surname),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please renter your surname";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              surname = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: "$age",
                            decoration: customTextFieldStyle("$age"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please renter your age";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              age = int.parse(value!);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: customTextFieldStyle(gender),
                            initialValue: gender,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please renter your gender";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              gender = value!;
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      " Existing Allergies: $allergies",
                      style: customTextStyle_normal,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(20)),
                      leading: Icon(Icons.add),
                      title: Text("Other"),
                      onTap: () {
                        _showCustomDialog(
                          title: "Add Allergy",
                          labelText: "Allergy Name",
                          listToUpdate: allergies,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Existing Dietary Preferences: $dietaryPref",
                      style: customTextStyle_normal,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(20)),
                      leading: Icon(Icons.add),
                      title: Text("Other"),
                      onTap: () {
                        _showCustomDialog(
                          title: "Add Preference",
                          labelText: "Dietary Preference Name",
                          listToUpdate: dietaryPref,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: customElevatedButtonStyle(140, 40),
                        onPressed: _submitForm,
                        child: const Text("Submit")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;

  String email = '';
  String iniName = "";
  String surname = '';
  int? age;
  String gender = "";
  List<dynamic> allergies = [];
  List<dynamic> dietaryPref = [];

  Future<void> getData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        email = user.email!;
      });
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(email).get();
      if (snapshot.exists) {
        print("Snapshot exists");
        setState(() {
          iniName = snapshot.data()!['Name'];
          surname = snapshot.data()!['Surname'];
          age = snapshot.data()!['Age'];
          gender = snapshot.data()!['Gender'];
          allergies = snapshot.data()!['Allergies'];
          dietaryPref = snapshot.data()!['Dietary_Pref'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _showCustomDialog(
      {required String title,
      required String labelText,
      required List<dynamic> listToUpdate}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String customValue = '';
        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (value) {
              customValue = value;
            },
            decoration: InputDecoration(labelText: labelText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  listToUpdate.add(customValue);
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = _auth.currentUser;
      if (user != null) {
        String userEmail = user.email!;

        // New document in firestore
        await _firestore.collection('users').doc(userEmail).set({
          'Name': iniName,
          'Surname': surname,
          'Age': age,
          'Gender': gender,
          'Allergies': allergies,
          'Dietary_Pref': dietaryPref,
          // 'Medical_Conditions' : _medicalConditions,
          // 'Pref_Cuisines' : _prefCuisines,
          // 'PicUrl' : _profilePicUrl,
        });

        Navigator.pop(context);
      }
    }
  }
}
