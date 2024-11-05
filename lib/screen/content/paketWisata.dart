//file rio
// ignore_for_file: camel_case_types, refer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers
import 'dart:async';

import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'checkout.dart';
import 'detailPaketWisata.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

// void main() {
//   runApp(const secondpage());
// }

// class secondpage extends StatelessWidget {
//   const secondpage({super.key});

//     @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter',
//       theme: ThemeData(
//       colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
//         useMaterial3: true,
//       ),
//       home: const paketwisata1(title: 'wisata'),
//     );
//   }
// }

class paketwisata1 extends StatefulWidget {
  const paketwisata1({super.key, required this.title});
  final String title;
  @override
  State<paketwisata1> createState() => _paketwisata1();
}

class _paketwisata1 extends State<paketwisata1> {
  //  bool _showBox = false;

  // void _tooglebox() {
  //   setState(() {
  //     _showBox = !_showBox;
  //   });
  // }
  var dio = Dio();
  // note, format hanya menerima bentuk angka, bukan bentuk string. jd harus konversi dlu string ke angka
  var formatRp = NumberFormat.currency(
    locale: "id_ID",
    decimalDigits: 0,
    symbol: "Rp. "
  );

  List<dynamic>? isiData;
  Timer? _timer;
  var isLoadingImage = true;


  Future<void> tarikPaketWisata() async {
    try {
      var response = await dio.get('${myIpAddr()}/cekpaket');

      setState(() {
        isiData = response.data;
      });

    } catch (e) {
      print('Error di $e');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // underscore buat void, kita g ambil callback
    tarikPaketWisata().then((_) => {

      // NetworkImage ga bs langsung load. mau ksh jeda sedikit
      _timer = Timer(Duration(milliseconds: 350), () {
        setState(() {
          isLoadingImage = false;
        });
      })
    });


  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }


  @override
  //harus ingat gunakan buildcontext jadi bisa pindah ke halaman lain
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Container(
                      height: height - 740,
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            child: Padding(
                            padding: EdgeInsets.only(top: 60, left: 55),
                            child: Container(
                              width: 300,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                  )
                                ]),
                                child: Center(
                                  child: Text('Paket Wisata',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800]
                                    )
                                  ),
                                )
                              ),
                            )
                          )
                        ]
                      )
                    )
                  )
                )
              ]
            ),

            Column(
              children: (isiData != null) 
                ? isiData!.map((items) {
                  return Row(
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 10
                          ),
                          child: Container(
                            width: width - 40,
                            height: height - 750,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 7
                                )
                              ]
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 20, left: 30),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => paketsingkawang( 
                                            herotag: 'idhero${items['id_paket']}',
                                            data: {
                                              "id_paket": items['id_paket'],
                                              "nama_paket": items['nama_paket'],
                                              "harga_paket": items['harga_paket'],
                                              "id_bis": items['id_bis'],
                                              "rute_awal": items['rute_awal'],
                                              "rute_akhir": items['rute_akhir'],
                                              "tgl_brkt": items['tgl_brkt'],
                                              "tgl_balik": items['tgl_balik'],
                                              "gbrpaket": items['gbrpaket'],
                                              "subjudulpaket": items['subjudulpaket'],
                                              "nama_bis": items['nama_bis'],
                                              "detailpaket": items['detailpaket'],
                                              "jlhpenumpang": items['jlhpenumpang']
                                            }
                                          )
                                        )
                                      );
                                    },
                                    child:Container(
                                      child: Hero(
                                        tag: 'idhero${items['id_paket']}',
                                        child: Container(
                                          width: 90,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(width: 1),
                                            image: DecorationImage(
                                                image: isLoadingImage 
                                                  ? AssetImage('assets/images/loading.gif')
                                                  : NetworkImage('${myIpAddr()}/fotoPaket/${items['gbrpaket']}'),
                                                fit: BoxFit.cover
                                              )
                                            ),
                                          ),
                                        )
                                      )
                                    )
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 20, left: 140),
                                  child: Text('${items!['nama_paket']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16))),
                                Container(
                                  padding: EdgeInsets.only(top: 43, left: 140),
                                  child: Text(
                                    items!['subjudulpaket'],
                                    style: TextStyle(
                                      color: Colors.black, fontSize: 14
                                    )
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 60, left: 140),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(100, 30),
                                        backgroundColor: Colors.blue[100]
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (builder) => MenuCheckout(
                                            // yg total_biaya ak jadikan array yg terdiri dari String Formatted di index 0, sama value real di index 1
                                            // ak malas mw buat parameter lg.
                                              totalBiaya: [formatRp.format(double.parse(items['harga_paket'])), double.parse(items['harga_paket'])],
                                              id_bis: items['id_bis'],
                                              tgl_pergi: items['tgl_brkt'],
                                              tgl_balik: items['tgl_balik'],
                                              jlh_penumpang: items['jlhpenumpang'],
                                              hrg_tiket_perorg: double.parse(items['harga_paket']) / int.parse(items['jlhpenumpang']),
                                              id_paket: items['id_paket']
                                            )
                                          )
                                        );
                                      },
                                      child: Text(
                                        'Pesan',
                                        style: TextStyle(color: Colors.black),
                                      )
                                    )
                                  )
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 75, left: 260),
                                  child: Text(formatRp.format(double.parse(items['harga_paket'])))
                                )
                              ]
                            )
                          )
                        )
                      )
                    
                    ],
                  );
                }).toList() 
                : [Text("")]
            ),
          
          ]
        )
      )
    );
  }
}
