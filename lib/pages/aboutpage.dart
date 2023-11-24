import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/themes.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String feedback = "";
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: customBackgroundColor,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Safe-Bite',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description: Your app description goes here. Provide information about the purpose and features of your app.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 5,
              color: customBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Provide your feedback and suggestions to improve the quality of the application',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          labelText: "Feedback and Suggestions"),
                      onChanged: (value) {
                        setState(() {
                          isTyping = value.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (isTyping)
                      Center(
                        child: ElevatedButton(
                            style: customElevatedButtonStyle(150, 30),
                            onPressed: () {
                              setState(() {
                                feedback = _controller.text;
                                savefeedback(feedback);
                                isTyping = false;
                                _controller.clear();

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Thank you for your feedback\nFeedback Submitted successfully!")));
                              });
                            },
                            child: const Text("Submit Feedback")),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: customElevatedButtonStyle(90, 40),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void savefeedback(String feedback) async {
    await FirebaseFirestore.instance
        .collection('feedback & suggestions')
        .add({"feedback": feedback});
  }
}
