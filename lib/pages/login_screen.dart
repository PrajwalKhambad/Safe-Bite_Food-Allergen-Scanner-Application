import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_bite/firebase_methods/firebase_auth_method.dart';
import 'package:safe_bite/pages/homepage.dart';
import 'package:safe_bite/pages/profile_form_page.dart';
import 'package:safe_bite/themes.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController passcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  bool isLoading = false;
  bool login = false;
  String error = "";

  @override
  void initState() {
    super.initState();
    //  autologin
    FirebaseAuth.instance.authStateChanges().listen((User? user){
      if(user != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
          return HomePage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ Color.fromARGB(255, 177, 216, 247), Color.fromARGB(255, 104, 179, 241), Color.fromARGB(255, 104, 179, 245), Color.fromARGB(255, 177, 216, 247)]
          )),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("E-mail",style: customTextStyle_normal,),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity - 150,
                    child: TextField(
                      controller: emailcontroller,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 209, 222, 236),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          hintText: "Enter your email",
                          prefixIcon: Icon(Icons.mail),
                          prefixIconColor: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text("Password",style: customTextStyle_normal,),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity - 150,
                    child: TextField(
                      controller: passcontroller,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 210, 222, 237),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.password)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:const EdgeInsets.all(6),
                    child: Text(error, style: const TextStyle(color: Colors.white),),
                  ),           
                  const SizedBox(height: 10,),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              login
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading==true
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: customElevatedButtonStyle(130, 40),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                                error = "";
                              });
                              final response = await FirebaseAuthMethods().login(emailcontroller.text, passcontroller.text);
                              response.fold((left) {
                                setState(() {
                                  error = left.message;
                                });
                              }, (right) => print(right.user!.email));
                              setState(() {
                                isLoading = false;
                              });
                              if(error.isEmpty){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
                                  return HomePage();
                                }));
                              }
                            },
                            child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),)),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                            TextButton(
                                onPressed: (){
                                  setState(() {
                                    login = !login;
                                  });
                                },
                                child: const Text("Sign-Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        isLoading==true
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: customElevatedButtonStyle(130, 40),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                                error = "";
                              });
                              final response = await FirebaseAuthMethods().signup(emailcontroller.text, passcontroller.text);
                              response.fold((left) {
                                setState(() {
                                  error = left.message;
                                });
                              }, (right) => print(right.user!.email));
                              setState(() {
                                isLoading = false;
                              });
                              if(error.isEmpty){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
                                  return Profile_Form();
                                }));
                              }
                            },
                            child: Text("Sign-up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    login = !login;
                                  });
                                },
                                child: const Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                          ],
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
