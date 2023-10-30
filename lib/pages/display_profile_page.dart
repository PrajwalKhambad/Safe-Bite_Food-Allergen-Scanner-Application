import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/pages/homepage.dart';
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
  int age = 0;
  String gender = "Gender";
  List<dynamic> allergies = [];
  List<dynamic> dietaryPref = [];

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
          name = snapshot.data()!['Name'];
          name = "$name  " + snapshot.data()!['Surname'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your  Profile",
          style: customTextStyle_appbar,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 28,
            color: customBackgroundColor,
          ),
        ),
      ),
      body: Container(
        color: customBackgroundColor,
        child: Column(
          children: [
            const Expanded(
              flex: 2,
              child: _TopPortion(),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal:15, vertical: 25),
                child: Column(
                  children: [
                    Chip(
                      backgroundColor: Color(0xFF749BC2),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Set borderRadius to 0 for rectangular shape
                          side: BorderSide(color: Color(0xFF749BC2)), // Add a border if desired
                        ),
                        label: Text(name)),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          backgroundColor: Color(0xFF749BC2),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Set borderRadius to 0 for rectangular shape
                          side: BorderSide(color: Color(0xFF749BC2)), // Add a border if desired
                        ),
                          label: Text(
                            "Age: $age",
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Chip(
                          backgroundColor: Color(0xFF749BC2),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Set borderRadius to 0 for rectangular shape
                          side: BorderSide(color: Color(0xFF749BC2)), // Add a border if desired
                        ),
                          label: Text(
                            "Gender: $gender",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Allergies",
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 5,
                        children: allergies.map((allergen) {
                          return Chip(
                            backgroundColor: Color(0xFF749BC2),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Set borderRadius to 0 for rectangular shape
                          side: BorderSide(color: Color(0xFF749BC2)), // Add a border if desired
                        ),
                            label: Text(allergen),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Dietary Preferences",
                      style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 5,
                        children: dietaryPref.map((pref) {
                          return Chip(
                            backgroundColor: Color(0xFF749BC2),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Set borderRadius to 0 for rectangular shape
                          side: BorderSide(color: Color(0xFF749BC2)), // Add a border if desired
                        ),
                            label: Text(pref),
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

class _TopPortion extends StatelessWidget {
  const _TopPortion({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 80),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFF4682A9),
                  Color(0xFF4682A9),
                ]),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 200,
            width: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF91C8E4),
                    shape: BoxShape.circle,
                    // Image
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: customBackgroundColor,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return UpdateProfileScreen();
                        }));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 32,
                        color: Color(0xFF91C8E4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
