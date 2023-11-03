// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../themes.dart';

// class UpdateProfileScreen extends StatefulWidget {
//   @override
//   State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
// }

// class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Profile"),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios_new_rounded),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           color: customBackgroundColor,
//           padding: EdgeInsets.symmetric(vertical:5, horizontal: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Stack(
//                 children: [
//                   SizedBox(
//                     width: 120,
//                     height: 120,
//                     child: ClipRRect(
//                         borderRadius: BorderRadius.circular(100),
//                         child: const CircleAvatar(backgroundColor: Color(0xFF91C8E4),)),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 35,
//                       height: 35,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: Colors.orange),
//                       child: const Icon(Icons.camera_alt,
//                           color: Colors.black, size: 20),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             initialValue: iniName,
//                             decoration: customTextFieldStyle(iniName),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Please enter name";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               iniName = value!;
//                             },
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 25,
//                         ),
//                         Expanded(
//                           child: TextFormField(
//                             initialValue: surname,
//                             decoration: customTextFieldStyle(surname),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Please renter your surname";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               surname = value!;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             keyboardType: TextInputType.number,
//                             initialValue: "$age",
//                             decoration: customTextFieldStyle("$age"),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Please renter your age";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               age = int.parse(value!);
//                             },
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: TextFormField(
//                             decoration: customTextFieldStyle(gender),
//                             initialValue: gender,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "Please renter your gender";
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               gender = value!;
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Text(
//                       " Existing Allergies: $allergies",
//                       style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     ListTile(
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(width: 1, color: Colors.black),
//                           borderRadius: BorderRadius.circular(20)),
//                       leading: Icon(Icons.add),
//                       title: Text("Other"),
//                       onTap: () {
//                         _showCustomDialog(
//                           title: "Add Allergy",
//                           labelText: "Allergy Name",
//                           listToUpdate: allergies,
//                         );
//                       },
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "Existing Dietary Preferences: $dietaryPref",
//                       style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     ListTile(
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(width: 1, color: Colors.black),
//                           borderRadius: BorderRadius.circular(20)),
//                       leading: Icon(Icons.add),
//                       title: Text("Other"),
//                       onTap: () {
//                         _showCustomDialog(
//                           title: "Add Preference",
//                           labelText: "Dietary Preference Name",
//                           listToUpdate: dietaryPref,
//                         );
//                       },
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     ElevatedButton(
//                         style: customElevatedButtonStyle(140, 40),
//                         onPressed: _submitForm,
//                         child: const Text("Submit")),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   final _firestore = FirebaseFirestore.instance;

//   final _auth = FirebaseAuth.instance;

//   String email = '';
//   String iniName = "";
//   String surname = '';
//   int? age;
//   String gender = "";
//   List<dynamic> allergies = [];
//   List<dynamic> dietaryPref = [];

//   Future<void> getData() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       setState(() {
//         email = user.email!;
//       });
//       DocumentSnapshot<Map<String, dynamic>> snapshot =
//           await _firestore.collection('users').doc(email).get();
//       if (snapshot.exists) {
//         print("Snapshot exists");
//         setState(() {
//           iniName = snapshot.data()!['Name'];
//           surname = snapshot.data()!['Surname'];
//           age = snapshot.data()!['Age'];
//           gender = snapshot.data()!['Gender'];
//           allergies = snapshot.data()!['Allergies'];
//           dietaryPref = snapshot.data()!['Dietary_Pref'];
//         });
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   void _showCustomDialog(
//       {required String title,
//       required String labelText,
//       required List<dynamic> listToUpdate}) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         String customValue = '';
//         return AlertDialog(
//           title: Text(title),
//           content: TextField(
//             onChanged: (value) {
//               customValue = value;
//             },
//             decoration: InputDecoration(labelText: labelText),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   listToUpdate.add(customValue);
//                 });
//                 Navigator.pop(context);
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       final user = _auth.currentUser;
//       if (user != null) {
//         String userEmail = user.email!;

//         // New document in firestore
//         await _firestore.collection('users').doc(userEmail).set({
//           'Name': iniName,
//           'Surname': surname,
//           'Age': age,
//           'Gender': gender,
//           'Allergies': allergies,
//           'Dietary_Pref': dietaryPref,
//           // 'Medical_Conditions' : _medicalConditions,
//           // 'Pref_Cuisines' : _prefCuisines,
//           // 'PicUrl' : _profilePicUrl,
//         });

//         Navigator.pop(context);
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:safe_bite/themes.dart';

class EditInfoDialog extends StatefulWidget {
  final String currentInfo;
  final Function(String) onInfoChanged;
  final String dialogTitle;
  final String labelText;

  const EditInfoDialog({super.key, 
    required this.currentInfo,
    required this.onInfoChanged,
    required this.dialogTitle,
    required this.labelText,
  });

  @override
  State<EditInfoDialog> createState() => _EditInfoDialogState();
}

class _EditInfoDialogState extends State<EditInfoDialog> {
  late TextEditingController _infoController;

  @override
  void initState() {
    super.initState();
    _infoController = TextEditingController(text: widget.currentInfo);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: customBackgroundColor,
      title: Text(widget.dialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _infoController,
            decoration: InputDecoration(
              labelText: widget.labelText,
              border:const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
              ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: TextStyle(color: Colors.red),),
        ),
        TextButton(
          onPressed: () {
            widget.onInfoChanged(_infoController.text);
            Navigator.pop(context);
          },
          child: Text("Confirm"),
        ),
      ],
    );
  }
}

class EditName extends StatefulWidget {

  final String currFirstName;
  final String currSurname;
  final Function(String, String) onNameChanged;

  const EditName({super.key, required this.currFirstName, required this.currSurname, required this.onNameChanged});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  late TextEditingController _namecontroller;
  late TextEditingController _surnamecontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _namecontroller = TextEditingController(text: widget.currFirstName);
    _surnamecontroller =  TextEditingController(text: widget.currSurname);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: customBackgroundColor,
      title: Text("Edit Name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _namecontroller,
            decoration: const InputDecoration(
              labelText: "Enter your name",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          const SizedBox(height: 15,),
          TextField(
            controller: _surnamecontroller,
            decoration:const InputDecoration(
              labelText: "Enter your surname",
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel", style: TextStyle(color: Colors.red),),
        ),
        TextButton(
          onPressed: () {
            // widget.onInfoChanged(_infoController.text);
            widget.onNameChanged(_namecontroller.text, _surnamecontroller.text);
            Navigator.pop(context);
          },
          child: Text("Confirm"),
        ),
      ],
    );
  }
}