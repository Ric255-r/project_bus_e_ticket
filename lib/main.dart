import 'dart:async';

import 'package:bus_hub/forgotpass.dart';
import 'package:bus_hub/register.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'screen/content/screen2.dart';
import 'package:dio/dio.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import './screen/function/confirmExit.dart';

import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bus_hub/screen/function/me.dart';

// referensi :
// https://stackoverflow.com/questions/51765092/how-to-scroll-page-in-flutter
// https://www.dhiwise.com/post/how-to-flutter-navigate-to-a-new-page-with-data-passing
//  https://medium.com/@sharonatim/building-responsive-layouts-in-flutter-ea329c3637d3
// https://medium.com/flutter-developer-indonesia/belajar-widget-widget-pada-flutter-flutter-starter-pack-part-1-7f386a02fbb6
// https://gedetikapermana.medium.com/flutter-membuat-bottom-navigation-bar-9c6fadde865a
// https://medium.com/@azizndao/mastering-http-requests-in-flutter-with-dio-package-975b75002911
void main() {
  // kunci orientasi
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log error but prevent debugger from pausing.
      FlutterError.dumpErrorToConsole(details);
    };

    runZonedGuarded(
      () async {
        runApp(MyApp());
      },
      (error, stack) {
        log('[ZONE_ERROR] $error');
        log('[ZONE_STACK] $stack');
      },
    );
  });
}

// gaboleh pake banyak materialapp, cukup satu di main.dart. ntr dia bkl kereplace
// The issue you're experiencing is likely due to the way you're navigating between screens in your Flutter application.
//When you navigate to DetailWisata, it seems that the MaterialApp widget is being recreated, which can cause the navigation stack to reset.
// Remove the MaterialApp from DetailWisata: You should not wrap your DetailWisata widget with a MaterialApp again.
//The MaterialApp should only be at the root of your application (usually in main.dart). Instead, just return a Scaffold or any other widget directly.

// Alurnya Adalah
// StatelessWidget -> StatefulWidget yang berisi createState _konten -> _konten extends State

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  var isNewRegister;

  MyApp({this.isNewRegister = false});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const MyHomePage(title: 'Popopop'),
        home: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Flutter Pertama Saya'),
          //   backgroundColor: Colors.red[300],
          // ),
          // body: MyTextField(),
          body: (isNewRegister && isNewRegister != null)
              ? MyTextField(
                  isNewRegister: true,
                )
              : MyTextField(),
        ));
  }
}

class MyTextField extends StatefulWidget {
  var isNewRegister;
  MyTextField({this.isNewRegister});

  @override
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State<MyTextField> {
  TextEditingController tfnum1 = TextEditingController();
  TextEditingController tfnum2 = TextEditingController();
  String outputnya = "";
  var isNewRegister;

  var n1 = 0;
  var n2 = 0;
  var sum = 0;
  String? jwt;

  Timer? _timerIsRegister;



  // inisiasikan state. kaya react
  @override
  void initState() {
    super.initState();
    fnIsNewRegister();
    _loadJwt();
  }

  Future<void> _loadJwt() async {
    String? value = await getStoredJwt();

    setState(() {
      jwt = value;
    });

    if (value != null && value.isNotEmpty) {
      final userData = await getMyData(value);
      if (userData.isNotEmpty && !userData.containsKey("Error Bagian User")) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SecondScreen(
                data: {
                  "usernya": userData,
                },
              ),
            ),
          );
        }
      } else {
        await removeStoredJwt();
      }
    }
  }
  // end inisiasikan state

  // function buat show dia keregis atau nda
  void fnIsNewRegister() {
    setState(() {
      isNewRegister = (widget.isNewRegister != null) ? widget.isNewRegister : false;
    });

    // timer buat setstate ke false lg
    _timerIsRegister = Timer(Duration(seconds: 3), () {
      setState(() {
        isNewRegister = false;
      });
    });
  }

  // Cara kerja dio kaya Axios.
  Future<void> utkLogin(context) async {
    final dio = Dio();

    try {
      // setting php artisan kek gini
      // php artisan serve --host=192.168.150.166
      // wajib pake ip host. kalo kaga dia g jln.
      final response = await dio.post("${myIpAddr()}/login",
          data: {'email': tfnum1.text, 'passwd': tfnum2.text});

      // Parse the response data
      final Map<String, dynamic> responseData = response.data;

      // write jwt
      if (responseData['access_token'] != null) {
        await saveStoredJwt(responseData['access_token']);
      }

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //     SecondScreen(data: responseData )
      //   )
      // );

      // ini biar dia ngereplace urlnya. jadi pas user back, dia nda nembak ke login lagi.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SecondScreen(
                  data: responseData,
                )),
        // (Route<dynamic> route) => false
      );

      tfnum1.text = "";
      tfnum2.text = "";
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          // Fluttertoast.showToast(
          //   msg: (e.response?.statusCode == 401) ?  : ,
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 10,
          //   textColor: Colors.white,
          //   fontSize: 16.0
          // );

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: (e.response?.statusCode == 401)
                  ? Text("Error Username / Password Salah")
                  : Text("Error ${e.response?.statusCode}: ${e.response?.data}")));
        } else {
          // Fluttertoast.showToast(
          //   msg: "Error ${e}",
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 10,
          //   textColor: Colors.white,
          //   fontSize: 16.0
          // );

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error $e")));
        }
      }
    }
  }

  //Ketika menggunakan texteditingcontroller, pastikan untuk menghapus controller
  //ketika halaman atau widget sudah tidak digunakan.
  //Ini bertujuan supaya tidak menimbulkan kebocoran memori (memory leak).
  @override
  void dispose() {
    tfnum1.dispose();
    tfnum2.dispose();
    _timerIsRegister?.cancel();

    super.dispose();
  }

  // void AddTwoNumber() {
  //   n1 = int.parse(tfnum1.text);
  //   n2 = int.parse(tfnum2.text);

  //   sum = n1 + n2;

  //   setState(() {
  //     outputnya = sum.toString();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // alur designnya kek gini :
    // column/listview itu paling awal, lalu dalam children column,
    // masukin lagi row.
    // nah dari children row, masukkin expanded. expanded disini berperan sbg col kalo di web.
    // kalo kau buat 3 expanded dalam satu row, jadi 3 column.
    // nah dalam child expanded lagi, kalo mw kasih jarak. lapis dengan padding.
    // baru isi kontennya isi di dalam child padding
    // jadi Column -> Row -> Expanded -> Padding (Opsional).
    // inti flutter ni berlapis lapis

    return WillPopScope(
      onWillPop: () async => await showPopUpExit(context),
      child: Scaffold(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  // Logo
                                  Container(
                                    alignment: Alignment.center,
                                    height: 80,
                                    child: Image.asset('assets/images/tayo.png'),
                                  ),
                                  const SizedBox(height: 10),
                                  const Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 25, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  if (isNewRegister != null && isNewRegister) ...[
                                    Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.green[400],
                                          borderRadius: BorderRadius.circular(10)),
                                      child: const Text(
                                        "Akun Berhasil Regis. Silahkan Login",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],

                                  // Email Field
                                  TextField(
                                    controller: tfnum1,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Email',
                                      prefixIcon: const Icon(Icons.email),
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  // Password Field
                                  TextField(
                                    controller: tfnum2,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      labelText: 'Password',
                                      prefixIcon: const Icon(Icons.lock),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Forgot Password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const forgetpassword(
                                                        title: 'title')));
                                      },
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 25),

                                  // Submit Button
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
                                          utkLogin(context);
                                        },
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ),
                                  const SizedBox(height: 20),

                                  // Belum Punya Akun? Text
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Belum punya Akun?'),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const IsiRegister()));
                                        },
                                        child: Text(
                                          ' Regis Sekarang',
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
      ),
    );
  }
}
