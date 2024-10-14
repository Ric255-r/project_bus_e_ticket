import 'dart:async';

import 'package:bus_hub/main.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  // var username = "";
  // var email = "";
  // var passwd = "";
  // var repeatPassWd = "";
  FocusNode usernameFocus = FocusNode();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passwd = TextEditingController();
  TextEditingController repeatPassWd = TextEditingController();


  bool isLoading = true;
  bool isErrorEmail = false;
  bool isErrorPass = false;
  Timer? _timerErrorEmail;
  Timer? _timerErrorPass;

  Future<void> buatRegis(BuildContext context) async {

    if(passwd.text != repeatPassWd.text){
      print("Password Tak Cocok");
      fnShowErrorPass();

      setState(() {
        isLoading = false;
      });

    }else{
      try {
        var response = await dio.post('${myIpAddr()}/register', 
          options: Options(
            headers: {
              "Content-Type": "application/json"
            }
          ),
          data: {
            'username': username.text,
            'email': email.text,
            'passwd': passwd.text
          }
        );

        if(context.mounted && response.statusCode == 200){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => MyApp(
              isNewRegister: true,
            ))
          );
        }


        // jangan buat status code 400 keatas di sini. dia masuk ke catch block
        // switch (response.statusCode) {
        //   case 409:
        //     fnShowErrorEmail();

        //     print("Error. Email Sudah Ada");

        //     break;
        //   case 200:
        //     if(context.mounted){
        //       Navigator.push(
        //         context, 
        //         MaterialPageRoute(builder: (context) => MyApp())
        //       );
        //     }
        //     break;
        // }
      } on DioException catch (e){
        if(e.response?.statusCode == 409){
          fnShowErrorEmail();
        }

      } finally {
        clearData();

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void clearData(){

    username.clear();
    passwd.clear();
    repeatPassWd.clear();
    email.clear();

    usernameFocus.requestFocus();
  }



  void fnShowErrorPass(){
    clearData();

    setState(() {
      isErrorPass = true;
    });

    _timerErrorPass = Timer((Duration(seconds: 3)), () {
      setState(() {
        isErrorPass = false;
      });
    });
  }

  
  void fnShowErrorEmail(){
    print("Panggil");

    setState(() {
      isErrorEmail = true;
    });

    _timerErrorEmail = Timer(Duration(seconds: 3), () {
      setState(() {
        isErrorEmail = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _timerErrorEmail?.cancel();
    _timerErrorPass?.cancel();
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
                  height: height - 300,
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
                            controller: username,
                            focusNode: usernameFocus,
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
                          child: Column(
                            children: [
                              TextField(
                                controller: email,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: 'Masukkan Email',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if(isErrorEmail)
                      Positioned(
                        top: 290,
                        left: 30,
                        right: 0,
                        child: SizedBox(
                          width: width - 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedOpacity(
                                opacity: isErrorEmail ? 1.0 : 0.0, 
                                duration: Duration(milliseconds: 200),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: const Text(
                                    "Email Sudah Ada",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                      // Masukkan Password Field
                      Positioned(
                        top: (isErrorEmail) ? 330 : 300,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            controller: passwd,
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
                        top: isErrorEmail ? 400 : 370,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            controller: repeatPassWd,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Ulangi Password',
                            ),
                          ),
                        ),
                      ),

                      if(isErrorPass)
                      Positioned(
                        top: 430,
                        left: 30,
                        right: 0,
                        child: SizedBox(
                          width: width - 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedOpacity(
                                opacity: isErrorPass ? 1.0 : 0.0, 
                                duration: Duration(milliseconds: 200),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: const Text(
                                    "Password Tidak Cocok",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Daftar Button
                      Positioned(
                        top: (isErrorEmail || isErrorPass) ? 470 : 440,
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
                                  if(username.text.isNotEmpty && email.text.isNotEmpty 
                                    && passwd.text.isNotEmpty && repeatPassWd.text.isNotEmpty){
                                    
                                    buatRegis(context);
                                  }else{
                                    Fluttertoast.showToast(
                                      msg: "Harap Lengkapi Data sebelum Register!",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 10,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                    );
                                  }
                                }, 
                                child: Text("Daftar")
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Sudah Punya Akun? Text
                      Positioned(
                        top: (isErrorEmail || isErrorPass) ? 530 : 500,
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
