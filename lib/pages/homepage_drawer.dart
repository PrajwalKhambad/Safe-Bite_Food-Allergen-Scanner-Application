import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/pages/display_profile_page.dart';
import 'package:safe_bite/pages/login_screen.dart';

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
  var snapshot;

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
    snapshot = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: Text(accName),
            accountEmail: Text(accountEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                "A",
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_box_outlined),
            title: Text("My Profile"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return My_Profile_Page();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.medical_services_outlined),
            title: Text("Medicines"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.arrow_back_ios_new_outlined),
            title: Text("About"),
            onTap: () {},
          ),
          ListTile(
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
