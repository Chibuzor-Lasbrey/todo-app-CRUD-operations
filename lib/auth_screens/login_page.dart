import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_database_example/auth_screens/reset.dart';
import 'package:sqflite_database_example/auth_screens/signin_page.dart';
import 'package:sqflite_database_example/page/notes_page.dart';
import 'package:sqflite_database_example/provider/auth_provider.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

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
                        image: AssetImage("assets/images/loag.jpg"),
                        fit: BoxFit.cover))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Container(
                            child: Text(
                      "LOG IN",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ))),
                    Center(
                        child: Container(
                            width: 300,
                            child: TextFormField(
                              controller: _email,
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ))),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: 300,
                        child: TextFormField(
                          controller: _password,
                          decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
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
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              AuthClass()
                                  .signIN(
                                      email: _email.text.trim(),
                                      password: _password.text.trim())
                                  .then((value) {
                                if (value == "Welcome") {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NotesPage()),
                                      (route) => false);
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value)));
                                }
                              });
                            },
                            child: Text(
                              "LOG IN",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Container(
                            height: 50,
                            width: 300,
                            child: GestureDetector(
                              child: Text("Forgot Password?",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResetPage()));
                              },
                            ))),
                    Center(
                        child: Container(
                      height: 50,
                      width: 300,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInPage()),
                                (route) => false);
                          },
                          child: Text(
                              "Don't have an account? Create an account",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 14))),
                    )),
                  ],
                ),
              ))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
