import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bus_hub/main.dart';

class Menu3 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IsiMenu3(),
      )
    );
  }
}

class IsiMenu3 extends StatefulWidget {
  @override
  _KontenMenu3 createState() => _KontenMenu3();
}

class _KontenMenu3 extends State<IsiMenu3> {
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 30, top: 40),
                  child: Text('Pengaturan Akun'),
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  // padding ini buat container
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black)
                      )
                    ),
                    // padding ini buat isi teks
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 10,
                        bottom: 10
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: "Klik Profile",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.person, size: 50,),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 28
                              ),
                              child: Text("Ubah Profile", style: TextStyle(fontSize: 15),),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_right, size: 50, )
                          ],
                        )
                      )
                    ),
                  ),
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  // padding ini buat container
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black)
                      )
                    ),
                    // padding ini buat isi teks
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 10,
                        bottom: 10
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: "Klik Profile 2",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.person, size: 50,),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 28
                              ),
                              child: Text("Ubah Password", style: TextStyle(fontSize: 15),),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_right, size: 50, )
                          ],
                        )
                      )
                    ),
                  ),
                )
              )
            ],
          ),
          const Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 30, top: 20),
                  child: Text('Tentang'),
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  // padding ini buat container
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black)
                      )
                    ),
                    // padding ini buat isi teks
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 10,
                        bottom: 10
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: "Klik Profile 2",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.person, size: 50,),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 28
                              ),
                              child: Text("FAQ", style: TextStyle(fontSize: 15),),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_right, size: 50, )
                          ],
                        )
                      )
                    ),
                  ),
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  // padding ini buat container
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black)
                      )
                    ),
                    // padding ini buat isi teks
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 10,
                        bottom: 10
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: "Klik Profile 2",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.person, size: 50,),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 28
                              ),
                              child: Text("Syarat Dan Ketentuan", style: TextStyle(fontSize: 15),),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_right, size: 50, )
                          ],
                        )
                      )
                    ),
                  ),
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  // padding ini buat container
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black)
                      )
                    ),
                    // padding ini buat isi teks
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        top: 10,
                        bottom: 10
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: "Klik Profile 2",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.person, size: 50,),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 28
                              ),
                              child: Text("Kebijakan Privasi", style: TextStyle(fontSize: 15),),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_right, size: 50, )
                          ],
                        )
                      )
                    ),
                  ),
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 30,
                    right: 30
                  ),
                  child: MaterialButton(
                    onPressed: () {

                    },
                    child: Text('Ganti Akun?'),
                    color: Colors.lime,
                  )
                )
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    left: 30,
                    right: 30
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) =>  MyApp()
                        )
                      );
                    },
                    child: Text('Logout', style: TextStyle(color: Colors.white),),
                    color: Colors.red.shade300,
                  )
                )
              )
            ],
          )
        ],
      ),
    );
  }
  
}