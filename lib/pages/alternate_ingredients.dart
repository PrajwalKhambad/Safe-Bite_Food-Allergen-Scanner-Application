import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Substitute {
  final String ingredient;
  final List<String> substitutes;
  final String message;

  Substitute({
    required this.ingredient,
    required this.substitutes,
    required this.message,
  });

  factory Substitute.fromJson(Map<String, dynamic> json) {
    return Substitute(
      ingredient: json['ingredient'],
      substitutes: json['substitutes'],
      message: json['message'],
    );
  }
}

class SubstituteScreen extends StatefulWidget {
  const SubstituteScreen({super.key});

  @override
  State<SubstituteScreen> createState() => _SubstituteScreenState();
}

class _SubstituteScreenState extends State<SubstituteScreen> {
  List<dynamic> userAllergies = [];
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> fetchUserAllergies() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.email).get();
      if (snapshot.exists) {
        setState(() {
          userAllergies = snapshot.data()!['Allergies'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserAllergies();
  }

  Future<Map<String, List<String>>> fetchSubstitutes() async {
    const String apiUrl = 'https://api.spoonacular.com/food/ingredients/substitutes';

    final Map<String, String> queryParams = {
      'apiKey': 'f4cd3530b540488bbc54d73f2e939e96',
      'ingredientName': userAllergies.join(','), // Pass the user allergies as a comma-separated string
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    print("URI OP: $uri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, List<String>> substitutesMap = {};
      final Map<String, dynamic> data = jsonDecode(response.body);

      for (var ingredient in userAllergies) {
        // Check if the ingredient has substitutes in the API response
        if (data.containsKey(ingredient)) {
          substitutesMap[ingredient] = List<String>.from(data[ingredient]);
        } else {
          substitutesMap[ingredient] = [];
        }
      }

      return substitutesMap;
    } else {
      throw Exception('Failed to fetch substitutes');
    }
  }

  Future<void> _launchUrl(String url) async {
    if(url.isNotEmpty){
      final Uri uri = Uri.parse(url);
      await launchUrl(uri);
    } else {
      print("Invalid Url: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Substitute Ingredients",
        ),
      ),
      body: FutureBuilder(
        future: fetchSubstitutes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF4682A9),));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          } else {
            Map<String, List<String>> substitutesMap = snapshot.data as Map<String, List<String>>;
            return ListView.builder(
              itemCount: substitutesMap.length,
              itemBuilder: (context, index) {
                String ingredient = substitutesMap.keys.elementAt(index);
                List<String> substitutes = substitutesMap[ingredient] ?? [];
                return ListTile(
                  title: Text(ingredient),
                  subtitle: Text("Substitutes: ${substitutes.join(', ')}"),
                  onTap: () {
                    // Handle onTap event if needed
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
