// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class forgetpassword extends StatefulWidget {
  const forgetpassword({super.key, required this.title});
  final String title;

  @override
  State<forgetpassword> createState() => isiforget();
}

class isiforget extends State<forgetpassword> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Color(0xFFD8BFD8)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50, left: 35),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 35),
                    child: Container(
                      width: 350,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              'Forgot',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 60, left: 20),
                            child: Text(
                              'Password?',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: 320,
                            padding: EdgeInsets.only(top: 20, left: 200),
                            child: Image.asset('assets/images/tayo.png'),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 200, left: 20),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 210, left: 20, right: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Isi email anda disini',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 300, left: 20, right: 20),
                            child: Container(
                              width: 320,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Colors.blue,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Send Verification',
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
