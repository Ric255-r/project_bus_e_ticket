import 'package:flutter/services.dart';
import '../menu/menu3.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:fluttertoast/fluttertoast.dart';
import '../menu/menu2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../function/confirmExit.dart';
// referensi carousel slider
// https://stackoverflow.com/questions/78688921/error-carouselcontroller-is-imported-from-both-package-in-flutter


class SecondScreen extends StatelessWidget {
  // harus define sebagai Map. supaya bisa get data kek data['a']['b']
  final Map<String, dynamic> data;
  // Ambil parameter dari main.dart
  SecondScreen({required this.data});
  // end ambil data main.dart

  // anggapannya class ini class pertamakali onload.
  // lalu pas pencet navbar. class ini kena replace kaya innerHTML.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IsiNavbar(isiData: data)
    );
  }
}

class IsiBody extends StatefulWidget {
  // Buat Parameter
  final Map<String, dynamic> dataPassing;

  IsiBody({required this.dataPassing});
  // End Parameter

  @override
  _Kontennya createState() => _Kontennya();
}

class _Kontennya extends State<IsiBody> {
  // Taruh Fungsi disini
  double Tinggi = 150;
  bool changes = true;

  final List<String> imgList = [
    'assets/images/carousel1.jpeg',
    'assets/images/carousel2.png',
    'assets/images/carousel3.jpeg'
  ];

  // Future<bool> showPopUpExit() async {
  //   return await showDialog(
  //     context: context, 
  //     builder: (context) => AlertDialog(
  //       title: const Text('Keluar Aplikasi?'),
  //       content: const Text('Apakah Yakin Ingin Keluar?'),
  //       actions: [
  //         ElevatedButton(
  //           onPressed: () => Navigator.of(context).pop(false), 
  //           child: Text('No')
  //         ),
  //         ElevatedButton(
  //           onPressed: () => SystemNavigator.pop(), 
  //           child: Text('Yes')
  //         )
  //       ],
  //     )
  //   )??false; //if showDialouge had returned null, then return false
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
          // Bagian Carousel
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
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blueGrey.shade100
                      )
                    ),
                    height: 210,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 50
                      ),
                      child: Column(
                        children: [
                          CarouselSlider(
                            items: imgList.map((item) => 
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    item, 
                                    fit: BoxFit.cover,
                                    width: double.infinity, // Ensures the image width matches the container
                                    height: 200, // Ensures the image height matches the container
                                  ),
                                )
                              )
                            ).toList(), 
                            options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 2.0
                              // onPageChanged: (index, reason){
                              //   // ini buat handle kalo page keubah
                              // }
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
          // Tambah Text DIbawah Carousel
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20
                  ), 
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      text: 'Mau Ngapain Hari Ini? \n',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              )
            ],
          ),
          // End Tambah Text.
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

// ini untuk state NavbarBottom.
class IsiNavbar extends StatefulWidget {
  // Buat Parameter. yang ada di SecondScreen.
  final Map<String, dynamic> isiData;

    // argumen ini di isi dengan data yg sama dengan body()
  IsiNavbar({required this.isiData});
  // End Parameter

  @override
  _KontenNavbar createState() => _KontenNavbar();
}

class _KontenNavbar extends State<IsiNavbar> {
  // Utk Navigasi
  int _currentIndex = 0;
  late List<Widget> _children;
  // End Utk Navigasi

  // Harus pake tipedata ini kalo mau passing data object ke file lain
  late Map<String, dynamic> dataIsiNavbar;

  void initState(){
    super.initState();
    // widget isiData diambil dari argument class SecondScreen(paling atas codeny).
    dataIsiNavbar = widget.isiData;

    _children = [
      IsiBody(dataPassing: dataIsiNavbar),
      Menu2(getDataNya: dataIsiNavbar),
      Menu3()
    ];
  }
  // end passing data

  void onBarTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // ini bakal nimpa yang class pertamakali (SecondScreen);
    return WillPopScope( // widget buat konfirmasi
      onWillPop: () async => await showPopUpExit(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hai ${dataIsiNavbar['user']['name']}'),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar:  BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onBarTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Ini Menu 1'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ini Menu 2'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.accessible_sharp),
              label: 'Ini Menu 3'
            )
          ]
        )
      ),
    );
  }
}

