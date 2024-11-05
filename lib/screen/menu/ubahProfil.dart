import 'dart:async';
import 'dart:io';

import 'package:bus_hub/screen/content/screen2.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:bus_hub/screen/function/me.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bus_hub/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'menu3.dart';


class SecondUbahProfile extends StatelessWidget {
  const SecondUbahProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Ubah Profil"),
        backgroundColor: Colors.blue[400],),
        body: IsiMenuUbahProfil(),
      )
    );
  }
}


class IsiMenuUbahProfil extends StatefulWidget {
  @override
  _KontenUbahProfil createState() => _KontenUbahProfil();
}

class _KontenUbahProfil extends State<IsiMenuUbahProfil> {
  var dio = Dio();
  var storage = FlutterSecureStorage();
  File? _imgFile;
  Map<String, dynamic>? dataUser;
  Timer? _timer;

  TextEditingController nama = TextEditingController();
  TextEditingController nohp = TextEditingController();
  TextEditingController email = TextEditingController();
  // TextEditingController jk = TextEditingController();
  // TextEditingController tg


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _timer = Timer(Duration(milliseconds: 800), () {
      getData(); // mencegah error ngecall dispose dlu abistu initstate()
    });
  }

  Future<void> getData() async {
    var jwt = await storage.read(key: 'jwt');
    
    if (jwt != null && jwt.isNotEmpty) {  // Check if jwt is not null
      var data = await getMyData(jwt);
      
      if (data != null) {  // Check if data is not null
        if(mounted){
          setState(() {
            dataUser = data;

            //  if dataUser terisi keys dan hasilnya not null
            nama.text = dataUser?['username'] ?? '';
            nohp.text = dataUser?['no_hp']?.toString() ?? '';
            email.text = dataUser?['email'] ?? '';
          });
        }
      }
    }
  }

  @override
  void dispose(){
    _timer?.cancel();
    nama.dispose();
    nohp.dispose();
    email.dispose();

    super.dispose();

  }

  Future<void> _fnFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      setState(() {
        _imgFile = File(image.path);
      });
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    var jwt = await storage.read(key: 'jwt');

    try {
      FormData? formData;

      formData = FormData.fromMap({
        'username': nama.text,
        'email': email.text,
        'nohp': nohp.text
      });

      if(_imgFile != null){
        String fileName = _imgFile!.path.split("/").last;

        MultipartFile gbr = await MultipartFile.fromFile(_imgFile!.path, filename: fileName);
        formData.files.add(MapEntry('fotoProfile', gbr));
      }

      var response = await dio.put('${myIpAddr()}/updateProfile', 
        data: formData,
        options: Options(
          headers: {
            "Authorization": "bearer $jwt",
            "Content-Type": 'multipart/form-data'
          }
        )
      );

      if(response.statusCode == 200){
        if(context.mounted){
          // ini ku terlanjur buat secondscreen pake nested object. 
          // jadi manggilnya ['usernya']['blabla']
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => SecondScreen(
                data: {
                  "usernya": dataUser
                },
                indexScreen: 2,
              )
            )
          );
        }
      }
      
    } catch (e) {
      print("Error Ubah Profile $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: (dataUser != null) ? SizedBox(
        height: (screenHeight <= 700) ? screenHeight + 405 : screenHeight,
        child: Stack(
          children: [
            // Bagian Carousel
            Container(
              color: Colors.blue[400],
              height: 300,
              child: Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 5,
                            left: 20,
                            right: 20
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _fnFoto();
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return Dialog(
                              //       child: InteractiveViewer(
                              //         child: Image.asset('assets/images/profile.jpg'),
                              //       ),
                              //     );
                              //   }
                              // );
                            },
                            child: (_imgFile != null)
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                    image:  DecorationImage(
                                      image: FileImage(_imgFile!)
                                    ),
                                    border: Border.all(
                                      color: Colors.blueGrey.shade100
                                    )
                                  ),
                                  height: 200,
                                  width: 200,
                                )
                              : dataUser!['profile_picture'] != null 
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                    image:  DecorationImage(
                                      image: NetworkImage('${myIpAddr()}/fotoprofile/${dataUser!['profile_picture']}')
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
                            )
                        )
                      )
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 30
                        ),
                        child: InkWell(
                          onTap: () async {
                            // Cara Load File Asset dengan rootBundle
                            // supaya widget FileImage bisa baca di kondisi atas pas imgFile != null
                            final byteData = await rootBundle.load('assets/images/profile.jpg');
                            final directory = await getApplicationDocumentsDirectory();
                            final file = File('${directory.path}/profile.jpg');
                            await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
                            
                            // End Cara

                            setState(() {
                              // set null dlu
                              _imgFile = null;
                              // set filenya
                              _imgFile = file;
                            });

                            print(_imgFile);
                          },
                          child: Text("Hapus Foto?", style: TextStyle(color: Colors.white),),
                        )
                      )
                    ],
                  )
                ],
              )
            ),

            Positioned(
              top: 245,
              left: 20,
              right: 20,
              bottom: 180, // mainkan bottom ini klo ad anomali
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
                height: screenHeight ,
                width: MediaQuery.of(context).size.width, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, top: 20),
                            child: Text('Nama Lengkap'),
                            
                          )
                        )
                      ],
                    ),
                    
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 30, top: 20, right : 30),
                      child: TextFormField(
                        readOnly: false,
                        controller: nama,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        enabled: true,
                      ),
                    ),

                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, top: 20),
                        child: Text('No HP'),
                      )
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 30, bottom: 20, right : 30),
                      child: TextFormField(
                        readOnly: false,
                        controller: nohp,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        enabled: true,
                      ),
                    ),

                  //   const Row(
                  //     children: [
                  //         Expanded(
                  //           child: Padding(
                  //             padding: EdgeInsets.only(left: 30, bottom: 20),
                  //             child: Text('Email'),
                              
                  //           )
                  //         )
                  //       ],
                  //     ),
                    
                  //   Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   alignment: Alignment.centerLeft,
                  //   padding: const EdgeInsets.only(left: 30, bottom:20, right : 30),
                  //   child: TextFormField(
                  //     readOnly: false,
                  //     controller: email,
                  //     decoration: InputDecoration(
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: const BorderSide(width: 1, color: Colors.black),
                  //         borderRadius: BorderRadius.circular(15),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(width: 1, color: Colors.black),
                  //         borderRadius: BorderRadius.circular(15),
                  //       ),
                  //     ),
                  //     enabled: true,
                  //   ),
                  // ),

                    const Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, bottom: 20),
                            child: Text('Jenis Kelamin'),
                          )
                        )
                      ],
                    ),
                    
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 30, bottom: 20, right : 30),
                      child: TextFormField(
                        readOnly: false,
                        initialValue: "Pria",
                        decoration: InputDecoration(
                          enabledBorder:  OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        enabled: true,
                      ),
                    ),


                    const Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, bottom: 20),
                            child: Text('Tanggal Lahir'),
                            
                          )
                        )
                      ],
                    ),
                    
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 30, bottom: 20, right : 30),
                      child: TextFormField(
                        readOnly: false,
                        initialValue: dataUser!['tanggal_lahir'],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        enabled: true,
                      ),
                    ),
                  ]
                )
              )
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 755,
                      left: 20,
                      right: 20
                    ),
                    child: MaterialButton(
                      height: 50,
                      onPressed: () {
                        updateProfile(context);
                      },
                      child: Text('Simpan', style: TextStyle(color: Colors.white),),
                      minWidth: 200,
                      color: Colors.blue[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                    )
                  )
                )
              ],
            ),
          ]
        )
      ) : SizedBox(
        child: Padding(
          padding: EdgeInsets.only(
            top: (screenHeight - 200) / 2
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      )
    );
  }
}