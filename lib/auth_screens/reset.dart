import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_database_example/auth_screens/login_page.dart';
import 'package:sqflite_database_example/provider/auth_provider.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  TextEditingController email = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 4,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 38,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )),
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
                            child: Text("RESET PASSWORD",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20)))),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Container(
                            width: 300,
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ))),
                    SizedBox(
                      height: 10,
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
                                  .resetPassword(
                                email: email.text.trim(),
                              )
                                  .then((value) {
                                if (value == "Email sent") {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
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
                              "RESET",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ))),
                  ],
                ),
              ))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
