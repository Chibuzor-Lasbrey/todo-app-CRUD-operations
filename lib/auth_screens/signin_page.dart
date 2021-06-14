import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_database_example/auth_screens/login_page.dart';
import 'package:sqflite_database_example/auth_screens/reset.dart';
import 'package:sqflite_database_example/page/notes_page.dart';
import 'package:sqflite_database_example/provider/auth_provider.dart';

void main() => runApp(SignInPage());

class SignInPage extends StatefulWidget {
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading == false
            ? SafeArea(
                child: Container(
                    decoration: BoxDecoration(
                        image: (DecorationImage(
                            image: AssetImage("assets/images/lines.jpg"),
                            fit: BoxFit.cover))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: Container(
                            child: Text(
                              "SIGN IN",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                          SizedBox(height: 10),
                          Center(
                              child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    controller: email,
                                    decoration: InputDecoration(
                                        labelText: "Email",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ))),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: 300,
                              child: TextFormField(
                                controller: password,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              height: 50,
                              width: 300,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                  ),
                                  child: Text(
                                    "CREATE ACCOUNT",
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    AuthClass()
                                        .createAccount(
                                            email: email.text.trim(),
                                            password: password.text.trim())
                                        .then((value) {
                                      if (value == "Account created") {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NotesPage()),
                                            (route) => false);
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                SnackBar(content: Text(value)));
                                      }
                                    });
                                  })),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Container(
                            height: 50,
                            width: 300,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResetPage()));
                                },
                                child: Text("Forgot password? Reset",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14))),
                          )),
                          Center(
                              child: Container(
                            height: 50,
                            width: 300,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text("Already have an account? Log in",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14))),
                          ))
                        ])))
            : Center(child: CircularProgressIndicator()));
  }
}
