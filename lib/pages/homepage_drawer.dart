import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_bite/pages/aboutpage.dart';
import 'package:safe_bite/pages/display_profile_page.dart';
import 'package:safe_bite/pages/login_screen.dart';
import 'package:safe_bite/pages/allergyfreemeals.dart';
import 'package:safe_bite/pages/scan_history.dart';
import 'package:safe_bite/themes.dart';

class HomePage_Drawer extends StatefulWidget {
  const HomePage_Drawer({super.key});

  @override
  State<HomePage_Drawer> createState() => _HomePage_DrawerState();
}

class _HomePage_DrawerState extends State<HomePage_Drawer> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String accName = '';
  String accountEmail = '';
  String? profileImageUrl;

  Future<void> getData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        accountEmail = user.email!;
      });
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(accountEmail).get();
      if (snapshot.exists) {
        setState(() {
          String initialName = snapshot.data()!['Name'];
          String surname = snapshot.data()!['Surname'];
          accName = "$initialName  $surname";
          profileImageUrl = snapshot.data()!['profileImageUrl'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> uploadImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child('profile_images/$accountEmail.jpg');

      await storageRef.putFile(file);
      final imageUrl = await storageRef.getDownloadURL();

      await _firestore
          .collection('users')
          .doc(accountEmail)
          .update({'profileImageUrl': imageUrl});

      setState(() {
        profileImageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF4682A9)),
              accountName: Text(
                accName,
                style: customTextStyle_normal,
              ),
              accountEmail: Text(
                accountEmail,
                style: customTextStyle_normal,
              ),
              currentAccountPicture: profileImageUrl != null
                  ? Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 3)),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(profileImageUrl!, scale: 1),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        uploadImage();
                      },
                      child: const CircleAvatar(
                          backgroundColor: Color(0xFF91C8E4),
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                          )),
                    )),
          ListTile(
            // tileColor:const Color(0xFF91C8E4),
            iconColor: Colors.black,
            leading: const Icon(Icons.account_box_outlined),
            title: const Text("My Profile"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const My_Profile_Page();
              }));
            },
          ),
          ListTile(
            // tileColor:const Color(0xFF91C8E4),
            iconColor: Colors.black,
            leading: const Icon(Icons.food_bank_outlined),
            title: const Text("Allergen Free Meals"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const MealScreen();
              }));
            },
          ),
          // ListTile(
          //   // tileColor:const Color(0xFF91C8E4),
          //   iconColor: Colors.black,
          //   leading: const Icon(Icons.food_bank_outlined),
          //   title: const Text("Substitutes"),
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (BuildContext context) {
          //       return const SubstituteScreen();
          //     }));
          //   },
          // ),
          ListTile(
            // tileColor:const Color(0xFF91C8E4),
            iconColor: Colors.black,
            leading: const Icon(Icons.history),
            title: const Text("Scans History"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const ScanHistory();
              }));
            },
          ),
          ListTile(
            // tileColor:const Color(0xFF91C8E4),
            iconColor: Colors.black,
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const AboutPage();
              }));
            },
          ),
          const Divider(
            height: 40,
            color: Colors.black,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            // tileColor:const Color(0xFF91C8E4),
            iconColor: Colors.black,
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Do you want to logout?"),
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
                              logout();
                              setState(() {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return const LoginForm();
                                }));
                              });
                            },
                            child: const Text("Logout"))
                      ],
                    );
                  }));
            },
          ),
          ListTile(
            // tileColor:const Color(0xFF91C8E4),
            iconColor: Colors.black,
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Exit App"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Exit App"),
                    content: const Text("Do you want to exit?"),
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
                            exit(0);
                          },
                          child: const Text("Exit"))
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error logging out: $e");
    }
  }
}
