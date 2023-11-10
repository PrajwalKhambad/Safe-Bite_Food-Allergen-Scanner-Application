import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safe_bite/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class Meal {
  final int id;
  final String title;
  final String imageType;
  final int readyInMinutes;
  final int servings;
  final String sourceUrl;

  Meal({
    required this.id,
    required this.title,
    required this.imageType,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      title: json['title'],
      imageType: json['imageType'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      sourceUrl: json['sourceUrl'],
    );
  }
}

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
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

  Future<List<Meal>> fetchAllergenFreeMeals() async {
    const String apiUrl = 'https://api.spoonacular.com/mealplanner/generate';

    final Map<String, String> queryParams = {
      'apiKey': 'f4cd3530b540488bbc54d73f2e939e96',
      'timeFrame': 'day', // You can change this as needed
      'targetCalories': '2000', // You can change this as needed
      'diet': 'vegetarian', // You can change this as needed
      'exclude': userAllergies
          .join(','), // User's allergies as a comma-separated string
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    print("URI OP: $uri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<Meal> meals = [];
      final Map<String, dynamic> data = jsonDecode(response.body);

      for (var mealData in data['meals']) {
        // Parse the meal details from the API response and create Meal objects.
        meals.add(Meal.fromJson(mealData));
      }

      return meals;
    } else {
      throw Exception('Failed to fetch allergen-free meals');
    }
  }

  Future<void> _launchUrl(String url) async {
    if(url.isNotEmpty){
      final Uri uri = Uri.parse(url);
      // if(await canLaunchUrl(uri)){
      //   await launchUrl(uri);
      // } else {
      //   print("Could not launch $url");
      // }
      await launchUrl(uri);
    } else {
      print("Invalid Url: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Allergen Free Meals",
          style: customTextStyle_appbar,
        ),
      ),
      body: FutureBuilder(
        future: fetchAllergenFreeMeals(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              "Error: ${snapshot.error}",
              style: customTextStyle_normal.apply(color: Colors.red),
            ));
          } else {
            return Column(
              children: [
                Card(
                  margin:const EdgeInsets.all(12),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      color: customBackgroundColor,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        "The below meals do not contain: ${userAllergies.join(', ')}",
                        style:
                            customTextStyle_normal.apply(color: Colors.black),
                      ))),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin:const EdgeInsets.all(12),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: customBackgroundColor,
                          padding: const EdgeInsets.only(bottom:17),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Display the meal title
                              ListTile(
                                horizontalTitleGap: 40,
                                onTap: () {},
                                title: Text(
                                  snapshot.data![index].title,
                                  style: customTextStyle_normal.apply(
                                      color: Colors.black),
                                ),
                              ),
                              // Display the meal image (if available)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (snapshot.data![index].imageType ==
                                      "jpg")
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        "https://spoonacular.com/recipeImages/${snapshot.data![index].id}-480x360.jpg",
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.75,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Ready in ${snapshot.data![index].readyInMinutes} minutes",
                                        style: customTextStyle_normal.apply(
                                            fontSizeFactor: 0.8,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                      Text(
                                        "Servings: ${snapshot.data![index].servings}",
                                        style: customTextStyle_normal.apply(
                                            fontSizeFactor: 0.7,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      ElevatedButton(
                                        style: customElevatedButtonStyle(
                                            double.infinity, 15),
                                        onPressed: () {
                                          print(snapshot
                                              .data![index].sourceUrl);
                                          _launchUrl(snapshot
                                              .data![index].sourceUrl);
                                        },
                                        child: const Text("View Recipe"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Provide a button to open the source URL
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
