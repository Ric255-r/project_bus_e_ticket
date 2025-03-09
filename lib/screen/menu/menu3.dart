import 'package:bus_hub/screen/content/faq.dart';
import 'package:bus_hub/screen/content/kebijakanPrivasi.dart';
import 'package:bus_hub/screen/content/profile.dart';
import 'package:bus_hub/screen/function/me.dart';
import 'package:bus_hub/screen/menu/syaratDanKet.dart';
import 'package:bus_hub/screen/menu/ubahPassword.dart';
import 'package:bus_hub/screen/menu/ubahProfil.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:bus_hub/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../function/ip_address.dart';

class Menu3 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IsiMenu3()
      )
    );
  }
}

class IsiMenu3 extends StatefulWidget {
  @override
  _KontenMenu3 createState() => _KontenMenu3();
}

class _KontenMenu3 extends State<IsiMenu3> {
  var storage = FlutterSecureStorage();
  Map<String, dynamic> user = {};

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var jwt = await storage.read(key: 'jwt');

    if (jwt != null && jwt.isNotEmpty) {  // Check if jwt is not null
      var fnUser= await getMyData(jwt);
      
      if (mounted) {  // Check supaya ga error setstate called after dispose
        setState(() {
          user = fnUser;
        });
      }
    }

    // setState(() {
    //   user = fnUser;
    // });
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: (screenHeight <= 700) ? screenHeight + 400 : screenHeight ,
        // ksh willpopscope biar nyegah die nd nyangkut akun lain
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (context) => SecondProfile(
                  data: user
                )
              )
            );

            return false;
          },
          child: Stack(
            children: [
              Container(
                color: Colors.blue[400],
                height: 300,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => SecondProfile(
                          data: user,
                        )
                      )
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
                              child: (user.isNotEmpty) ? Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: user['profile_picture'] != null 
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                          image:  DecorationImage(
                                            image: NetworkImage('${myIpAddr()}/fotoprofile/${user['profile_picture']}')
                                          ),
                                          border: Border.all(
                                            color: Colors.blueGrey.shade100
                                          )
                                        ),
                                        height: 200,
                                        width: 200,
                                      ) 
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                          image: const DecorationImage(
                                            image: AssetImage('assets/images/profile.jpg'), fit: BoxFit.contain
                                          ),
                                          border: Border.all(
                                            color: Colors.blueGrey.shade100
                                          )
                                        ),
                                        height: 200,
                                        width: 200,
                                      )
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
                                        text: TextSpan(
                                          text: '${user['username']} \n\nMau Ngapain Hari Ini? \n',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )
                                ]
                              ) : Center(
                                child: CircularProgressIndicator(),
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
                  height: screenHeight - 320,
                  width: MediaQuery.of(context).size.width, 
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30, top: 20, bottom: 10),
                              child: Text(
                                'Pengaturan Akun',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
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
                                    left: 3,
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
                                        MaterialPageRoute(
                                          builder: (context) => SecondUbahProfile()
                                        )
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(Icons.person, size: 50,),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 25
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
                                        MaterialPageRoute(builder: (context) => MenuUbahPassword())
                                      );
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(Icons.lock, size: 40,),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 30
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
                              child: Text(
                                'Tentang',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600
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
                                        Icon(Icons.comment, size: 38,),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 35
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
                                        Icon(Icons.theater_comedy_sharp, size: 45,),
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
                                        Icon(Icons.privacy_tip, size: 35,),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 35
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
                                onPressed: () async {
                                  await storage.delete(key: 'jwt');

                                  Navigator.pushAndRemoveUntil(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (context) =>  MyApp()
                                    ),
                                    (Route<dynamic> route) => false // This removes all previous routes
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
        ),
        
      )
    );
  }
  
}