import 'package:bus_hub/main.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MenuRegister extends StatelessWidget {
  const MenuRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IsiRegister(),
      )
    );
  }
}

class IsiRegister extends StatefulWidget {
  const IsiRegister({super.key});

  @override
  State<IsiRegister> createState() => _regis();
}

//kode rio
class _regis extends State<IsiRegister> {
  var dio = Dio();
  var username = "";
  var email = "";
  var passwd = "";
  var repeatPassWd = "";

  Future<void> buatRegis(BuildContext context) async {

    if(passwd != repeatPassWd){
      print("Password Tak Cocok");

    }else{
      try {
        var response = await dio.post('${myIpAddr()}/register', 
          options: Options(
            headers: {
              "Content-Type": "application/json"
            }
          ),
          data: {
            'username': username,
            'email': email,
            'passwd': passwd
          }
        );

        switch (response.statusCode) {
          case 409:
            print("Error. Email Sudah Ada");
            break;
          case 200:
            if(context.mounted){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => MyApp())
              );
            }
            break;
        }
      } catch (e) {
        print("Error Register di $e");
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // print(width);
    // print(height);

    return Container(
      decoration: const BoxDecoration(
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
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 130),
                child: Container(
                  width: width - 100,
                  height: height - 330,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Logo
                      Positioned(
                        top: 25,
                        left: 0,
                        right: 0,
                        child: Container(
                          // width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          child: Image.asset('assets/images/tayo.png'),
                        ),
                      ),

                      // Form title
                      Positioned(
                        top: 105,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Nama Lengkap Field
                      Positioned(
                        top: 160,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                username = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Nama Lengkap',
                            ),
                          ),
                        ),
                      ),

                      // Masukkan Email Field
                      Positioned(
                        top: 230,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Masukkan Email',
                            ),
                          ),
                        ),
                      ),

                      // Masukkan Password Field
                      Positioned(
                        top: 300,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                passwd = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Masukkan Password',
                            ),
                          ),
                        ),
                      ),

                      // Ulangi Password Field
                      Positioned(
                        top: 370,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                repeatPassWd = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Ulangi Password',
                            ),
                          ),
                        ),
                      ),

                      // Daftar Button
                      Positioned(
                        top: 440,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  buatRegis(context);
                                }, 
                                child: Text("Daftar")
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Sudah Punya Akun? Text
                      Positioned(
                        top: 500,
                        left: 40,
                        child: SizedBox(
                          height: 20,
                          child: Row(
                            children: [
                              Text('Sudah punya Akun?'),

                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => MyApp())
                                  );
                                },
                                child: Text(
                                  ' Login Sekarang',
                                  style: TextStyle(color: Colors.blue[700]),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
