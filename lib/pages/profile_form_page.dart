import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/pages/homepage.dart';
import 'package:safe_bite/themes.dart';

class Profile_Form extends StatefulWidget {
  const Profile_Form({super.key});

  @override
  State<Profile_Form> createState() => _Profile_FormState();
}

class _Profile_FormState extends State<Profile_Form> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _iniName = "";
  String _surname = "";
  int _age = 0;
  String _gender = "";
  String profilePicUrl = "";

  final List<String> _allergies = [];
  final List<String> _commonAllergies = ['Peanuts','Milk','Eggs','Wheat','Soy'];

  final List<String> _dietaryPref = [];
  final List<String> _dietarySuggestions = ['Vegetarian','Vegan','Gluten-free','Low-carb','Paleo'];

  // String _medicalConditions = "";
  // String _prefCuisines = "";
  // String _profilePicUrl = "";

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = _auth.currentUser;
      if (user != null) {
        String userEmail = user.email!;

        // New document in firestore
        await _firestore.collection('users').doc(userEmail).set({
          'Name': _iniName,
          'Surname': _surname,
          'Age': _age,
          'Gender': _gender,
          'Allergies': _allergies,
          'Dietary_Pref': _dietaryPref,
          'profileImageUrl': profilePicUrl,
          // 'Medical_Conditions' : _medicalConditions,
          // 'Pref_Cuisines' : _prefCuisines,
          // 'PicUrl' : _profilePicUrl,
        });

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return const HomePage();
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fill Profile"),
      ),
      body: Container(
        color: customBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: customTextFieldStyle('Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _iniName = value!;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: customTextFieldStyle('Surname'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your surname";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _surname = value!;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: customTextFieldStyle('Age'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your age";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _age = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text("Gender"),
                        trailing: DropdownButton<String>(
                          hint: const Text("Select gender"),
                          value: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                          items: ["", "Male", "Female", "Other"]
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("  Allergies", style: TextStyle(color: Colors.black, fontSize: 15),),
                const SizedBox(height: 9,),
                Wrap(
                  runSpacing: 4,
                  spacing: 8,
                  children: _commonAllergies.map((allergy) {
                    bool isSelected = _allergies.contains(allergy);
                    return ChoiceChip(
                      selectedColor: const Color(0xFF749BC2),
                      label: Text(allergy),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _allergies.add(allergy);
                          } else {
                            _allergies.remove(allergy);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  shape: RoundedRectangleBorder(side: const BorderSide(width: 1),borderRadius: BorderRadius.circular(20)),
                  leading: const Icon(Icons.add),
                  title: const Text("Other"),
                  onTap: () {
                    _showCustomDialog(title: "Add Allergy", labelText: "Allergy Name", listToUpdate: _allergies, suggestionList: _commonAllergies);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(" Dietary Preferences", style: TextStyle(color: Colors.black, fontSize: 15),),
                const SizedBox(height: 9,),
                Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: _dietarySuggestions.map((preference){
                    bool isPrefSel = _dietaryPref.contains(preference);
                    return ChoiceChip(
                      selectedColor: const Color(0xFF749BC2),
                      label: Text(preference),
                      selected: isPrefSel,
                      onSelected: (selected){
                        setState(() {
                          if(selected){
                            _dietaryPref.add(preference);
                          } else {
                            _dietaryPref.remove(preference);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10,),
                ListTile(
                  shape: RoundedRectangleBorder(side: const BorderSide(width: 1),borderRadius: BorderRadius.circular(20)),
                  leading: const Icon(Icons.add),
                  title: const Text("Other"),
                  onTap: (){
                    _showCustomDialog(title: "Add Dietary Preference",labelText: "Dietary Preference",listToUpdate: _dietaryPref, suggestionList: _dietarySuggestions);
                  },
                ),
                // Implement medical conditions, pref cuisines and profile pic url here if required
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
        ),
      ),
    );
  }
  
  void _showCustomDialog({required String title,required String labelText,required List<String> listToUpdate, required List<String> suggestionList}) {
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                listToUpdate.add(customValue);
                suggestionList.add(customValue);                
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
}
