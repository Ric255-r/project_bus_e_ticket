import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SecondScreen extends StatelessWidget {
  // Ambil dari main.dart
  final String data;

  SecondScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Screen'),),
      // body: Center(
      //   child: Text('Selamat Datang Cuy $data'),
      // ),
      // jadi disini bisa taruh argument
      body: IsiBody(dataPassing: data)
    );
  }
}

class IsiBody extends StatefulWidget {
  // Buat Parameter
  final String dataPassing;

  IsiBody({required this.dataPassing});
  // End Parameter

  @override
  _Kontennya createState() => _Kontennya();
}

class _Kontennya extends State<IsiBody> {
  // Taruh Fungsi disini
  double Tinggi = 150;
  bool changes = true;

  // void ubahTinggi(perubahan){
  //   setState(() {
  //     if(!perubahan){
  //       Tinggi = 600;
  //       changes = false;
  //     }else{
  //       Tinggi = 150;
  //       changes = true;
  //     }


  //   });
  // }

  // End Taruh Fungsi


  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Text('Selamat Datang Di ${widget.dataPassing}'),
    // );
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 20,
                    left: 20,
                    right: 20
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber.shade200,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 50
                      ),
                      child: Text('Selamat Datang ${widget.dataPassing}'),
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
                    left: 20,
                    right: 10
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: "This is a Toast Kiri",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    },
                    child: Container(
                      height: Tinggi,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.red
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/tayo.png'),
                            height: 100,
                            width: 100,
                          ),
                          Text(
                            'Your Text Here',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                )
              ),
              Expanded(                
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 20
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: "This is a Toast message Gesture",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    },
                    child: Container(
                      height: Tinggi,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.red
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/tayo.png'),
                            height: 100,
                            width: 100,
                          ),
                          Text(
                            'Your Text Here',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                )
              ),
            ],
          ),
          // Tambah Spasi Manual
          RichText(text: const TextSpan(text: '')),
          // End Tambah Spasi.
          Row(
            children: [
              Expanded(                
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 10
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: "This is a Toast Kiri",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    },
                    child: Container(
                      height: Tinggi,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.red
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/tayo.png'),
                            height: 100,
                            width: 100,
                          ),
                          Text(
                            'Your Text Here',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                )
              ),
              Expanded(                
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 20
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: "This is a Toast message Gesture",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0
                      );
                    },
                    child: Container(
                      height: Tinggi,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.red
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/images/tayo.png'),
                            height: 100,
                            width: 100,
                          ),
                          Text(
                            'Your Text Here',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )
                )
              ),
            ],
          )
        ],
      ),
    );
  }
}

