import 'package:bus_hub/screen/content/faq.dart';
import 'package:bus_hub/screen/content/kebijakanPrivasi.dart';
import 'package:bus_hub/screen/content/profile.dart';
import 'package:bus_hub/screen/menu/syaratDanKet.dart';
import 'package:bus_hub/screen/menu/ubahPassword.dart';
import 'package:bus_hub/screen/menu/ubahProfil.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: (screenHeight <= 700) ? screenHeight + 400 : screenHeight +150,
        child: Stack(
          children: [
            Container(
              color: Colors.blue[400],
              height: 300,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => SecondProfile())
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                          bottom: 100,
                          left: 20,
                          right: 20
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.blueGrey.shade100
                            )
                          ),
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: Icon(Icons.account_circle, size: 85,),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 30,
                                      bottom: 0
                                    ),
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      text: const TextSpan(
                                        text: 'Asep Budiman \n\nMau Ngapain Hari Ini? \n',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                )

                              ]
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 255,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3)
                    )
                  ]
                ),
                height: screenHeight,
                width: MediaQuery.of(context).size.width, 
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
                                    // Fluttertoast.showToast(
                                    //   msg: "Klik Profile",
                                    //   toastLength: Toast.LENGTH_LONG,
                                    //   gravity: ToastGravity.BOTTOM,
                                    //   timeInSecForIosWeb: 10,
                                    //   textColor: Colors.white,
                                    //   fontSize: 16.0
                                    // );
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => SecondUbahProfile())
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
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => SecondUbahPass())
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
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => faq(title: "bla"))
                                    );
                                    // Fluttertoast.showToast(
                                    //   msg: "Klik Profile 2",
                                    //   toastLength: Toast.LENGTH_LONG,
                                    //   gravity: ToastGravity.BOTTOM,
                                    //   timeInSecForIosWeb: 10,
                                    //   textColor: Colors.white,
                                    //   fontSize: 16.0
                                    // );
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
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => SecondSK())
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
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => Kebijakan(title: "title"))
                                    );
                                    // Fluttertoast.showToast(
                                    //   msg: "Klik Profile 2",
                                    //   toastLength: Toast.LENGTH_LONG,
                                    //   gravity: ToastGravity.BOTTOM,
                                    //   timeInSecForIosWeb: 10,
                                    //   textColor: Colors.white,
                                    //   fontSize: 16.0
                                    // );
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
                                Navigator.pushReplacement(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) =>  MyApp()
                                  ),
                                  // (Route<dynamic> route) => false
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
              )
            )
          ],
        ),
      )
    );
  }
  
}