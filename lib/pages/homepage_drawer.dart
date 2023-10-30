import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/pages/display_profile_page.dart';
import 'package:safe_bite/pages/login_screen.dart';
import 'package:safe_bite/themes.dart';

import '../firebase_methods/firebase_auth_method.dart';

class HomePage_Drawer extends StatefulWidget {
  const HomePage_Drawer({super.key});

  @override
  State<HomePage_Drawer> createState() => _HomePage_DrawerState();
}

class _HomePage_DrawerState extends State<HomePage_Drawer> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String accName = 'Name';
  String accountEmail = 'Email';

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF4682A9)),
            accountName: Text(accName, style: customTextStyle_normal,),
            accountEmail: Text(accountEmail, style: customTextStyle_normal,),
            currentAccountPicture:const CircleAvatar(
              backgroundColor: Color(0xFF91C8E4),
              child: Text(
                "A",
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          ListTile(
            tileColor: Color(0xFF91C8E4),
            iconColor: Colors.black,
            hoverColor: customBackgroundColor,
            leading: Icon(Icons.account_box_outlined),
            title: Text("My Profile"),
            onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
            return My_Profile_Page();
          }));
            },
          ),
          ListTile(
            tileColor: Color(0xFF91C8E4),
            iconColor: Colors.black,
            hoverColor: customBackgroundColor,
            leading: Icon(Icons.medical_services_outlined),
            title: Text("Medicines"),
            onTap: () {},
          ),
          ListTile(
            tileColor: Color(0xFF91C8E4),
            iconColor: Colors.black,
            hoverColor: customBackgroundColor,
            leading: Icon(Icons.arrow_back_ios_new_outlined),
            title: Text("About"),
            onTap: () {},
          ),
          ListTile(
            tileColor: Color(0xFF91C8E4),
            iconColor: Colors.black,
            hoverColor: customBackgroundColor,
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
          logout();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return LoginForm();
          }));
            },
          ),
          ListTile(
            tileColor: Color(0xFF91C8E4),
            iconColor: Colors.black,
            hoverColor: customBackgroundColor,
            leading: Icon(Icons.exit_to_app),
            title: Text("Exit App"),
            onTap: () {},
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
