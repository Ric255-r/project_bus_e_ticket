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
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    runApp(const MyApp());

  });
}

// Alurnya Adalah 
// StatelessWidget -> StatefulWidget yang berisi createState _konten -> _konten extends State 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        body: MyTextField(),
      ));
  }
}

class MyTextField extends StatefulWidget {
  @override
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State {
  TextEditingController tfnum1 = TextEditingController();
  TextEditingController tfnum2 = TextEditingController();
  String outputnya = "";

  var n1 = 0;
  var n2 = 0;
  var sum = 0;
  String? jwt;

  final storage = new FlutterSecureStorage();

  // inisiasikan state. kaya react
  void initState(){
    super.initState();
    _loadJwt();
  }

  Future<void> _loadJwt() async {
    String? value = await storage.read(key: 'jwt');

    setState(() {
      jwt = value;
    });
  }
  // end inisiasikan state


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

    print(width);

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
                    height: 400,
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
                            alignment: Alignment.center,
                            //width: ,
                            height: 80,
                            child: Image.asset('assets/images/tayo.png'),
                          ),
                        ),

                        // Form title
                        Positioned(
                          top: 110,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),

                        // Email Field
                        Positioned(
                          top: 160,
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
                          top: 230,
                          left: 20,
                          right: 20,
                          child: SizedBox(
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
                        ),


                        // Submit
                        Positioned(
                          top: 280,
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
                          top: 360,
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
                                      MaterialPageRoute(builder: (context) => MenuRegister())
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


