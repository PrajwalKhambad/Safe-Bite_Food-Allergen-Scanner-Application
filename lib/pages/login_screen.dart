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
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return const HomePage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: Color(0xFFF6F4EB)),
          child: ListView(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 220,
                  child: HeaderWidget(200),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Safe-Bite", style: customTextStyle_normal.copyWith(fontSize: 40, color: Colors.black),),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Food Allergen Scanner Application", style: customTextStyle_normal.copyWith(fontSize: 15, color: Colors.black),),
                      ),
                      const SizedBox(height: 40,),
                      login
                      ? Container(
                        alignment: Alignment.centerLeft,
                        child:Text("Welcome back, User", style: customTextStyle_normal.copyWith(fontSize: 20, color: Colors.black),),
                      )
                      : Container(
                        alignment: Alignment.centerLeft,
                        child:Text("Let's Eat Safe", style: customTextStyle_normal.copyWith(fontSize: 20, color: Colors.black),),
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity - 150,
                        child: TextField(
                          controller: emailcontroller,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF6F4EB),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: "Enter your email",
                              prefixIcon: Icon(Icons.mail),
                              prefixIconColor: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity - 150,
                        child: TextField(
                          obscureText: true,
                          controller: passcontroller,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFF6F4EB),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: 'Enter your password',
                              prefixIcon: Icon(Icons.password)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                login
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLoading == true
                              ? const CircularProgressIndicator(
                                  color: Color(0xFF4682A9),
                                )
                              : ElevatedButton(
                                  style: customElevatedButtonStyle(130, 40),
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                      error = "";
                                    });
                                    final response = await FirebaseAuthMethods()
                                        .login(emailcontroller.text,
                                            passcontroller.text);
                                    response.fold((left) {
                                      setState(() {
                                        error = left.message;
                                      });
                                    }, (right) => print(right.user!.email));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (error.isEmpty) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return const HomePage();
                                      }));

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Logged in successfully")));
                                    }
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      login = !login;
                                    });
                                  },
                                  child: const Text(
                                    "Sign-Up",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF749BC2)),
                                  )),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          isLoading == true
                              ? const CircularProgressIndicator(
                                  color: Color(0xFF4682A9),
                                )
                              : ElevatedButton(
                                  style: customElevatedButtonStyle(130, 40),
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                      error = "";
                                    });
                                    final response = await FirebaseAuthMethods()
                                        .signup(emailcontroller.text,
                                            passcontroller.text);
                                    response.fold((left) {
                                      setState(() {
                                        error = left.message;
                                      });
                                    }, (right) => print(right.user!.email));
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (error.isEmpty) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return const Profile_Form();
                                      }));
                                    }
                                  },
                                  child: const Text(
                                    "Sign-up",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      login = !login;
                                    });
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF749BC2)),
                                  )),
                            ],
                          ),
                        ],
                      )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  final double _height;

  const HeaderWidget(this._height, {Key? key}) : super(key: key);
  //static const primaryColor = Colors.black;
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState(_height);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final double _height;

  _HeaderWidgetState(
    this._height,
  );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        ClipPath(
          clipper: ShapeClipper([
            Offset(width / 5, _height),
            Offset(width / 10 * 5, _height - 60),
            Offset(width / 5 * 4, _height + 50),
            Offset(width, _height - 18)
          ]),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color(0xFF749BC2).withOpacity(0.4),
                    const Color(0xFF4682A9).withOpacity(0.4)
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        ClipPath(
          clipper: ShapeClipper([
            Offset(width / 3, _height + 50),
            Offset(width / 10 * 8, _height - 60),
            Offset(width / 5 * 4, _height - 60),
            Offset(width, _height - 20)
          ]),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color(0xFF749BC2).withOpacity(0.4),
                    const Color(0xFF4682A9).withOpacity(0.4)
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        ClipPath(
          clipper: ShapeClipper([
            Offset(width / 5, _height),
            Offset(width / 2, _height - 40),
            Offset(width / 5 * 4, _height - 80),
            Offset(width, _height - 20)
          ]),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF4682A9),
            ),
          ),
        ),
        Positioned(
            top: _height - 40,
            left: width / 2 - 20,
            child: Row(
              children: [
                Image.asset(
                  "assets/images/login_icon.png",
                  width: 70,
                  height: 60,
                ),
                Image.asset(
                  "assets/images/login_icon2.png",
                  width: 80,
                  height: 60,
                ),
                Image.asset(
                  "assets/images/login_icon3.png",
                  width: 70,
                  height: 58,
                ),
              ],
            )),
      ],
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);
    path.quadraticBezierTo(
        _offsets[0].dx, _offsets[0].dy, _offsets[1].dx, _offsets[1].dy);
    path.quadraticBezierTo(
        _offsets[2].dx, _offsets[2].dy, _offsets[3].dx, _offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
