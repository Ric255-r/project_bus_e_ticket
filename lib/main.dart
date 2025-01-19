import 'dart:async';

import 'package:bus_hub/forgotpass.dart';
import 'package:bus_hub/register.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'screen/content/screen2.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './screen/function/confirmExit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log error but prevent debugger from pausing.
      FlutterError.dumpErrorToConsole(details);
    };

    runApp(MyApp());

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
          ? MyTextField(isNewRegister: true,) 
          : MyTextField(),
      )
    );
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

  final storage = new FlutterSecureStorage();

  // inisiasikan state. kaya react
  @override
  void initState(){
    super.initState();
    fnIsNewRegister();
    _loadJwt();
  }

  Future<void> _loadJwt() async {
    String? value = await storage.read(key: 'jwt');

    setState(() {
      jwt = value;
    });
  }
  // end inisiasikan state

  // function buat show dia keregis atau nda
  void fnIsNewRegister(){
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
        data: {
          'email': tfnum1.text,
          'passwd': tfnum2.text
        }
      );

      // Parse the response data
      final Map<String, dynamic> responseData = response.data;

      // write jwt
      await storage.write(key: 'jwt', value: responseData['access_token']);
      

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
          builder: (context) =>  SecondScreen(data: responseData,)
        ),
        // (Route<dynamic> route) => false
      );

      tfnum1.text = "";
      tfnum2.text = "";
    } catch (e) {
      if(e is DioException){
        if(e.response != null){
          Fluttertoast.showToast(
            msg: (e.response?.statusCode == 401) ? "Error Username / Password Salah" : "Error ${e.response?.statusCode}: ${e.response?.data}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 10,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }else{
          Fluttertoast.showToast(
            msg: "Error ${e}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 10,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
      }
    }
  }

  
  //Ketika menggunakan texteditingcontroller, pastikan untuk menghapus controller 
  //ketika halaman atau widget sudah tidak digunakan. 
  //Ini bertujuan supaya tidak menimbulkan kebocoran memori (memory leak).
  @override
  void dispose(){
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

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => await showPopUpExit(context),
      child: Container(
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
                  padding: EdgeInsets.only(top: (height / 4)),
                  child: Container(
                    width: width - 100,
                    height: 420,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        // Logo
                        Positioned(
                          top: (isNewRegister != null && isNewRegister) ? 15 : 45,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                //width: ,
                                height: 80,
                                child: Image.asset('assets/images/tayo.png'),
                              ),
                              Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if(isNewRegister != null && isNewRegister)
                        Positioned(
                          top: 140,
                          left: 20,
                          right: 20,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.green[400],
                              borderRadius: BorderRadius.circular(10)
                            ),
                            height: 35,
                            child: Text(
                              "Akun Berhasil Regis. Silahkan Login", 
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,                                
                              ),
                            ),
                          )
                        ),

                        // Email Field
                        Positioned(
                          top: 190,
                          left: 20,
                          right: 20,
                          child: SizedBox(
                            width: width - 100,
                            child: TextField(
                              controller: tfnum1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: 'Email',
                              ),
                            ),
                          ),
                        ),

                        // Masukkan Pass Field
                        Positioned(
                          top: 255,
                          left: 20,
                          right: 20,
                          child: Column(
                            children: [
                              SizedBox(
                                width: width - 100,
                                child: TextField(
                                  controller: tfnum2,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Password',
                                  ),
                                ),
                              ),

                              SizedBox(height: 8,),

                              SizedBox(
                                width: width - 100,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => const forgetpassword(title: 'title'))
                                    );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                            ]
                          ),
                        ),

                        // Submit
                        Positioned(
                          top: 315,
                          left: 0,
                          right: 0,
                          child: Container(
                            alignment: Alignment.center,
                            //width: ,
                            height: 80,
                            child: ElevatedButton(
                              onPressed: () {
                                utkLogin(context);
                              }, 
                              child: Text("Login")
                            ),
                          ),
                        ),

                        // Sudah Punya Akun? Text
                        Positioned(
                          top: 385,
                          left: 40,
                          child: SizedBox(
                            height: 20,
                            child: Row(
                              children: [
                                Text('Belum punya Akun?'),

                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => IsiRegister())
                                    );
                                  },
                                  child: Text(
                                    ' Regis Sekarang',
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
      ), 
    );
  }
}


