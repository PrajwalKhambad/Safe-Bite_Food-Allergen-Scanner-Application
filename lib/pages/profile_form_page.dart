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
  final List<String> _allergies = [];

  final List<String> _dietaryPref = [];
  final List<String> _dietarySuggestions = [
    'Vegetarian',
    'Vegan',
    'Gluten-free',
    'Low-carb',
    'Paleo'
  ];

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
          // 'Medical_Conditions' : _medicalConditions,
          // 'Pref_Cuisines' : _prefCuisines,
          // 'PicUrl' : _profilePicUrl,
        });

        // Navigate to the next screen
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return HomePage();
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
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
              const SizedBox(
                height: 18,
              ),
              TextFormField(
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
              const SizedBox(
                height: 18,
              ),
              TextFormField(
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
              const SizedBox(
                height: 18,
              ),
              ListTile(
                title: const Text("Gender"),
                trailing: DropdownButton<String>(
                  hint: Text("Select gender"),
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
              const SizedBox(
                height: 25,
              ),
              Wrap(
                spacing: 8,
                // runSpacing: 4,
                children: _allergies.map((allergy) {
                  return Chip(
                    label: Text(allergy),
                    onDeleted: () => _removeAllergy(allergy),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _allergyController,
                decoration: customTextFieldStyle('Allergies'),
                onFieldSubmitted: _addAllergy,
              ),
              const SizedBox(
                height: 18,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dietary Preferences"),
                  Wrap(
                    spacing: 8,
                    children: _dietaryPref.map((preference) {
                      return Chip(
                        label: Text(preference),
                        onDeleted: () => _removeDietaryPreference(preference),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: customTextFieldStyle('Dietary Preferences'),
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _addDietaryPreference(value);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 8,
                    children: _dietarySuggestions.map((suggestion) {
                      return InputChip(
                        label: Text(suggestion),
                        onPressed: () => _addDietaryPreference(suggestion),
                      );
                    }).toList(),
                  ),
                ],
              ),

              // Implement medical conditions, pref cuisines and profile pic url here if required

              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  style: customElevatedButtonStyle(140, 40),
                  onPressed: _submitForm,
                  child: const Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController _allergyController = TextEditingController();

  void _addAllergy(String allergy) {
    if (allergy.isNotEmpty) {
      setState(() {
        _allergies.add(allergy);
        _allergyController.clear();
      });
    }
  }

  void _removeAllergy(String allergy) {
    setState(() {
      _allergies.remove(allergy);
    });
  }

  void _addDietaryPreference(String preference) {
    setState(() {
      _dietaryPref.add(preference);
    });
  }

  void _removeDietaryPreference(String preference) {
    setState(() {
      _dietaryPref.remove(preference);
    });
  }
}
