// ignore_for_file: prefer_const_constructors
import 'package:bus_hub/screen/content/detailRiwayat.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bus_hub/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';


class Menu2 extends StatelessWidget {
  Menu2();

  // final Map<String, dynamic> getDataNya;

  // Menu2({required this.getDataNya});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IsiMenu2(),
      )
    );
  }
}


class IsiMenu2 extends StatefulWidget {
  @override
  _KontenMenu2 createState() => _KontenMenu2();
}

class _KontenMenu2 extends State<IsiMenu2> {
  bool isPending = true;
  bool isCompleted = false;
  bool isCancelled = false;

  bool kontenPending = true;
  bool kontenCompleted = false;
  bool kontenCancelled = false;

  var formatRp = NumberFormat.currency(
    locale: "id_ID",
    symbol: "Rp. ",
    decimalDigits: 0
  );

  List<dynamic> listData = [];
  var dio = Dio();
  var storage = FlutterSecureStorage();
  bool isLoading = true;

  Future<void> getData(String mode) async {
    try {
      var jwt = await storage.read(key: "jwt");

      var response = await dio.get('${myIpAddr()}/checkout?status=$mode', 
        options: Options(
          headers: {
            "authorization": "bearer $jwt"
          }
        )
      );

      // print(jwt);

      if (response.statusCode == 200) {
        // Check if response data is not null
        if (response.data != null) {
          setState(() {
            listData = response.data;
          });
        } else {
          print("Response data is null");
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print("Error: ${response.statusCode} - ${response.statusMessage}");

        setState(() {
          isLoading = false;
        });
      }

      // print(listData);

    } catch (e) {
      print("Ada Error $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData('pending');
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight - 200 + 50 * listData.length,
        child: Stack(
          children: [
            Container(
              color: Colors.blue[400],
              height: 300,
              child: const Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 100,
                        left: 20,
                        right: 20
                      )
                    )
                  )
                ]
              )

            ),
            Positioned(
              left: 60,
              top: 20,
              child: Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: (isPending) ? 3 : 0,
                    color: const Color.fromARGB(255, 150, 251, 153)
                  )
                )
              ),
              child: InkWell(
                onTap: () async {
                  await getData('pending');

                  if(mounted){
                    setState(() {
                      isPending = true;
                      isCancelled = false;
                      isCompleted = false;
                    });
                  }

                },
                child: Text('Pending', style: TextStyle(color: Colors.white))
              )
              ),
            ),
            
            Positioned(
              left: 170,
              top: 20,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: (isCompleted) ? 3 : 0,
                      color: const Color.fromARGB(255, 150, 251, 153)
                    )
                  )
                ),
                
                child: InkWell(
                  onTap: () async{
                    await getData('completed');

                    if(mounted){
                      setState(() {
                        isPending = false;
                        isCancelled = false;
                        isCompleted = true;
                      });
                    }
                  },
                  child: Text('Completed', style: TextStyle(color: Colors.white))
                )
              ),
            ),  
              
            Positioned(
              left: 290,
              top: 20,
              child: Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: (isCancelled) ? 3 : 0,
                    color: const Color.fromARGB(255, 150, 251, 153)
                  )
                )
              ),
              
              child: InkWell(
                onTap: () async{
                  await getData("cancelled");

                  if(mounted){
                    setState(() {
                      isPending = false;
                      isCancelled = true;
                      isCompleted = false;
                    });
                  }

                },
                child: Text('Cancelled', style: TextStyle(color: Colors.white),)
              )
            ),
            ),

            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Visibility(
                visible: isPending, // ini buat menu isPending
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
                  height: (listData.isNotEmpty) ? 120 + (150.0 * listData.length) : 400,
                  width: MediaQuery.of(context).size.width,
                  child: (isLoading) 
                  ? SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                  : (listData.isNotEmpty) ?  
                    ListView( //ganti column dgn listview biar g error
                      // NeverScrollableScrollPhysics.
                      // you will disable scrolling on the ListView, but still allow clicking on its items
                      physics: NeverScrollableScrollPhysics(),
                      children: listData.map((items){
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => DetailRiwayatStless(
                                  idTrans: items['id_trans'],
                                )
                              )
                            );
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                                child: Container(
                                  width: 360,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.withOpacity(0.2)
                                  ),
                                )
                              ),
                              
                              Padding(
                                padding: EdgeInsets.only(top: 45, left: 40),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: items['gbrpaket'] == null || items['id_paket'] == ""
                                      ? Image.asset('assets/images/tayo.png', fit: BoxFit.contain)
                                      : Image.network(
                                        '${myIpAddr()}/fotoPaket/${items['gbrpaket']}',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/loading.gif'); // Fallback image on error
                                        },
                                        // Smpe sini ak nd tau dah, ini dibantu AI. tanpa ini error kodingan
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 125, top: 45),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(items['nama_paket'] != null)
                                    AutoSizeText(
                                      items!['nama_paket'],
                                      maxLines: 1,
                                      minFontSize: 8,
                                      maxFontSize: 12,
                                    ),

                                    AutoSizeText(
                                      "${items['id_rute'].substring(0,3)} -> ${items['id_rute'].substring(3, 6)}",
                                      maxLines: 1,
                                      minFontSize: 8,
                                      maxFontSize: 12,
                                    ),
                                    
                                    Text(
                                      (items['tgl_balik'] == items['tgl_pergi']) 
                                      ? "${items['tgl_pergi']}"
                                      : "${items['tgl_pergi']} -> ${items['tgl_balik']}",
                                      style: TextStyle(
                                        fontSize: 11
                                      ),
                                    ),
                                    SizedBox(height: 3,),

                                    Row(
                                      children: [
                                        Flexible(
                                          child: Icon(Icons.pending_actions, size: 20)
                                        ),
                                        Expanded(
                                          child: Text('Pending', style: TextStyle(fontSize: 12)),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 25, left: 45),
                                child: Text(
                                  "${items['tgl_trans'].substring(0, 10)}",
                                  style: TextStyle(fontSize: 12)
                                )
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 285, top: 45),
                                child: Text('${formatRp.format(items['total_harga'])}', style: TextStyle(fontSize: 12))
                              )
                            
                            ]
                          ),
                        );
                      }).toList(),
                    ) : SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Text("No Data"),
                    ),
                  )
                )
              )
            ),  
            
            Positioned(
              top:60,
              left: 20,
              right: 20,
              child : Visibility(
                visible: isCompleted,  // ini buat isCompleted
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
                  height: (listData.isNotEmpty) ? 200 + (150.0 * listData.length) : 400,
                  width: MediaQuery.of(context).size.width,
                  child: (isLoading)
                    ? SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                    : (listData.isNotEmpty) ?  
                    ListView( //ganti column dgn listview biar g error
                      // NeverScrollableScrollPhysics.
                      // you will disable scrolling on the ListView, but still allow clicking on its items
                      physics: NeverScrollableScrollPhysics(),
                      children: listData.map((items){
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => DetailRiwayatStless(
                                  idTrans: items['id_trans'],
                                )
                              )
                            );
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                                child: Container(
                                  width: 360,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.withOpacity(0.2)
                                  ),
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 45, left: 40),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: items['gbrpaket'] == null || items['id_paket'] == ""
                                      ? Image.asset('assets/images/tayo.png', fit: BoxFit.contain)
                                      : Image.network(
                                        '${myIpAddr()}/fotoPaket/${items['gbrpaket']}',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/loading.gif'); // Fallback image on error
                                        },
                                        // Smpe sini ak nd tau dah, ini dibantu AI. tanpa ini error kodingan
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 125, top: 45),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(items['nama_paket'] != null)
                                    AutoSizeText(
                                      items['nama_paket'],
                                      maxLines: 1,
                                      minFontSize: 8,
                                      maxFontSize: 12,
                                    ),

                                    AutoSizeText(
                                      "${items['id_rute'].substring(0,3)} -> ${items['id_rute'].substring(3, 6)}",
                                      maxLines: 1,
                                      minFontSize: 8,
                                      maxFontSize: 12,
                                    ),
                                    
                                    Text(
                                      (items['tgl_balik'] == items['tgl_pergi']) 
                                      ? "${items['tgl_pergi']}"
                                      : "${items['tgl_pergi']} -> ${items['tgl_balik']}",
                                      style: TextStyle(
                                        fontSize: 11
                                      ),
                                    ),
                                    SizedBox(height: 3,),

                                    Row(
                                      children: [
                                        Flexible(
                                          child: Icon(Icons.check, size: 20)
                                        ),
                                        Expanded(
                                          child: Text('Completed', style: TextStyle(fontSize: 12)),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 25, left: 45),
                                child: Text(
                                  "${items['tgl_trans'].substring(0, 10)}",
                                  style: TextStyle(fontSize: 12)
                                )
                              ),

                              Padding(
                                padding: EdgeInsets.only(left: 285, top: 45),
                                child: Text('${formatRp.format(items['total_harga'])}', style: TextStyle(fontSize: 12))
                              )
                            
                            ]
                          )
                        );
                      }).toList(),
                    ) : SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Text("No Data"),
                    ),
                  )
                )
              ),
            ),

            Positioned(
              top:60,
              left: 20,
              right: 20,
              child : Visibility(
                visible: isCancelled, // ini buat menu iscancelled
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
                  height: (listData.isNotEmpty) ? 200 + (150.0 * listData.length) : 400,
                  width: MediaQuery.of(context).size.width,
                  child: (isLoading) ? 
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ) 
                    : (listData.isNotEmpty) ? 
                    ListView( //ganti column dgn listview biar g error
                      // NeverScrollableScrollPhysics.
                      // you will disable scrolling on the ListView, 
                      // but still allow clicking on its items
                      physics: NeverScrollableScrollPhysics(),
                      children: listData.map((items){
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => DetailRiwayatStless(
                                  idTrans: items['id_trans'],
                                )
                              )
                            );
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                                child: Container(
                                  width: 360,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.withOpacity(0.2)
                                  ),
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 45, left: 40),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: items['gbrpaket'] == null || items['id_paket'] == ""
                                      ? Image.asset('assets/images/tayo.png', fit: BoxFit.contain)
                                      : Image.network(
                                        '${myIpAddr()}/fotoPaket/${items['gbrpaket']}',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/images/loading.gif'); // Fallback image on error
                                        },
                                        // Smpe sini ak nd tau dah, ini dibantu AI. tanpa ini error kodingan
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          // // Original
                                          // return Center(
                                          //   child: CircularProgressIndicator(
                                          //     value: loadingProgress.expectedTotalBytes != null
                                          //       ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                          //       : null,
                                          //   ),
                                          // );

                                          // //  Versi Simple
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 125, top: 45),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(items['nama_paket'] != null)
                                    AutoSizeText(
                                      items['nama_paket'],
                                      maxLines: 1,
                                      minFontSize: 8,
                                      maxFontSize: 12,
                                    ),

                                    AutoSizeText(
                                      "${items['id_rute'].substring(0,3)} -> ${items['id_rute'].substring(3, 6)}",
                                      maxLines: 1,
                                      minFontSize: 8,
                                      maxFontSize: 12,
                                    ),
                                    
                                    Text(
                                      (items['tgl_balik'] == items['tgl_pergi']) 
                                      ? "${items['tgl_pergi']}"
                                      : "${items['tgl_pergi']} -> ${items['tgl_balik']}",
                                      style: TextStyle(
                                        fontSize: 11
                                      ),
                                    ),
                                    SizedBox(height: 3,),

                                    Row(
                                      children: [
                                        Flexible(
                                          child: Icon(Icons.cancel, size: 20)
                                        ),
                                        Expanded(
                                          child: Text('Cancelled', style: TextStyle(fontSize: 12)),
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 25, left: 45),
                                child: Text(
                                  "${items['tgl_trans'].substring(0, 10)}",
                                  style: TextStyle(fontSize: 12)
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 285, top: 45),
                                child: Text('${formatRp.format(items['total_harga'])}', style: TextStyle(fontSize: 12))
                              )
                            
                            ]
                          ),
                        );
                      }).toList(),
                    ) 
                    : SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Text("No Data"),
                    ),
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}