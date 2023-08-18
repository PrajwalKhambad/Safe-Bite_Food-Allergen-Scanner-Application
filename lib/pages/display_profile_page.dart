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
      if(snapshot.exists){
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
        backgroundColor: Color.fromARGB(255, 241, 125, 0),
        leading:IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
              return HomePage();
            }));
          },
          icon: Icon(Icons.arrow_back, size: 28,),
        ),
      ),
      body: Column(
        children: [
          const Expanded(flex: 2, child: _TopPortion(),),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(name, style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Age: $age", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      const SizedBox(width: 20,),
                      Text("Gender: $gender", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Text("Allergies", style: customTextStyle_normal,),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 5,
                      children: allergies.map((allergen){
                        return Chip(
                          label: Text(allergen),
                          backgroundColor: Colors.redAccent,
                          labelStyle: TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Text("Dietary Preferences", style: customTextStyle_normal,),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 5,
                      children: dietaryPref.map((pref){
                        return Chip(
                          label: Text(pref),
                          backgroundColor: Colors.redAccent,
                          labelStyle: TextStyle(color: Colors.white),
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
          margin: EdgeInsets.only(bottom: 60),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color.fromARGB(255, 186, 124, 0), Color.fromARGB(255, 241, 125, 0)]
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    // Image
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: (){
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                        //   return UpdateProfileScreen();
                        // }));
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                          return UpdateProfileScreen();
                        }));
                      },
                      icon: Icon(Icons.edit, size: 28, color: Colors.orange,),
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