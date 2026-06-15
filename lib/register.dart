import 'dart:async';

import 'package:bus_hub/main.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import 'package:fluttertoast/fluttertoast.dart';

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
    if (passwd.text != repeatPassWd.text) {
      print("Password Tak Cocok");
      fnShowErrorPass();

      setState(() {
        isLoading = false;
      });
    } else {
      try {
        var response = await dio.post('${myIpAddr()}/register',
            options: Options(headers: {"Content-Type": "application/json"}),
            data: {
              'username': username.text,
              'email': email.text,
              'passwd': passwd.text
            });

        if (context.mounted && response.statusCode == 200) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyApp(
                        isNewRegister: true,
                      )));
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
      } on DioException catch (e) {
        if (e.response?.statusCode == 409) {
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

  void clearData() {
    username.clear();
    passwd.clear();
    repeatPassWd.clear();
    email.clear();

    usernameFocus.requestFocus();
  }

  void fnShowErrorPass() {
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

  void fnShowErrorEmail() {
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Color(0xFFD8BFD8)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                // Logo
                                Container(
                                  height: 80,
                                  alignment: Alignment.center,
                                  child: Image.asset('assets/images/tayo.png'),
                                ),
                                const SizedBox(height: 10),
                                const Center(
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Nama Lengkap Field
                                TextField(
                                  controller: username,
                                  focusNode: usernameFocus,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Nama Lengkap',
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Masukkan Email Field
                                TextField(
                                  controller: email,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Masukkan Email',
                                    prefixIcon: const Icon(Icons.email),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                if (isErrorEmail) ...[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                                      child: AnimatedOpacity(
                                        opacity: isErrorEmail ? 1.0 : 0.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: const Text(
                                          "Email Sudah Ada",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),

                                // Masukkan Password Field
                                TextField(
                                  controller: passwd,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Masukkan Password',
                                    prefixIcon: const Icon(Icons.lock),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Ulangi Password Field
                                TextField(
                                  controller: repeatPassWd,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Ulangi Password',
                                    prefixIcon: const Icon(Icons.lock),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                if (isErrorPass) ...[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                                      child: AnimatedOpacity(
                                        opacity: isErrorPass ? 1.0 : 0.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: const Text(
                                          "Password Tidak Cocok",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 15),

                                // Daftar Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[600],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (username.text.isNotEmpty &&
                                          email.text.isNotEmpty &&
                                          passwd.text.isNotEmpty &&
                                          repeatPassWd.text.isNotEmpty) {
                                        buatRegis(context);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Harap Lengkapi Data sebelum Register!"),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Daftar",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Sudah Punya Akun? Text
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Sudah punya Akun?'),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyApp()),
                                        );
                                      },
                                      child: Text(
                                        ' Login Sekarang',
                                        style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
