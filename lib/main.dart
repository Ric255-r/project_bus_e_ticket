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
          appBar: AppBar(
            title: const Text('Flutter Pertama Saya'),
            backgroundColor: Colors.red[300],
          ),
          // body: MyTextField(),
          body: MyTextField(),
          // body: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Container(
          //       child: Text("Hello 1"),
          //       color: Colors.lightBlue,
          //       padding: EdgeInsets.all(30.0),
          //     ),
          //     Container(
          //       child: Text("Hello 2"),
          //       color: Colors.purple,
          //       padding: EdgeInsets.all(30.0),
          //     ),
          //     Container(
          //       child: Text("Hello 3"),
          //       color: Colors.yellowAccent,
          //       padding: EdgeInsets.all(30.0),
          //     )
          //   ],
          // ),
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
      final response = await dio.post('http://192.168.1.26:5500/api/login', 
        data: {
          'email': tfnum1.text,
          'passwd': tfnum2.text
        }
      );

      // Parse the response data
      final Map<String, dynamic> responseData = response.data;

      // write jwt
      await storage.write(key: 'jwt', value: responseData['access_token']);
      

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(data: responseData ))
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

    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => await showPopUpExit(context),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: (screenHeight >= 1000) ? 300 : 100,
                  ),
                  child: const Text("Username", style: TextStyle(fontSize: 18),),
                )
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: TextField(controller: tfnum1),
                )
              ),
            ],
          ),

          const Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 10
                  ),
                  child: Text(
                    "Password", 
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 1,
                    left: 10,
                    right: 20
                  ), 
                  child: TextField(
                    controller: tfnum2,
                  ),
                )
              ),
            ],
          ),
          // Tambah Spasi Manual
          RichText(text: const TextSpan(text: '')),
          // End Tambah Spasi.
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // AddTwoNumber();
                  utkLogin(context);
                },
                child: const Text("Login"),
              ),
            ),
            // Text(outputnya),
          ]),
          // Tambah Spasi Manual
          RichText(text: const TextSpan(text: '')),
          // End Tambah Spasi.
          Center(child: Text(outputnya))
        ]
      ), 
    );
  }
}


