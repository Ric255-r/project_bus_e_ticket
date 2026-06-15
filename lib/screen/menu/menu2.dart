// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';

import 'package:bus_hub/screen/content/detailRiwayat.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:bus_hub/screen/function/me.dart';
import 'package:flutter/material.dart';
import 'package:bus_hub/main.dart';
import 'package:dio/dio.dart';

import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';


class Menu2 extends StatelessWidget {
  final String? status;
  final Key? key;

  // key disini untuk force rebuild menu2. incase notif muncul, lalu user tap & posisi user di menu riwayat/history
  Menu2({this.status, this.key}) : super(key: key);

  // final Map<String, dynamic> getDataNya;
  // Menu2({required this.getDataNya});


  @override
  Widget build(BuildContext context) {
    // return data status ini isinya Sukses, Ditolak, dan Pending. 
    // Hasil Translate dari triggerNotif Websocket Screen2.dart
    if(status != null ){
      switch (status) {
        case "Sukses":
          return SafeArea(
            child: Scaffold(
              body:  IsiMenu2(
                key: key == null ? ValueKey("Tanpa_Key") : key,
                status: "completed",
              ),
            )
          );
        case "Ditolak":
          return SafeArea(
            child: Scaffold(
              body:  IsiMenu2(
                key: key == null ? ValueKey("Tanpa_Key") : key,
                status: "cancelled",
              ),
            )
          );
        default:
          return SafeArea(
            child: Scaffold(
              body:  IsiMenu2(
                key: key == null ? ValueKey("Tanpa_Key") : key,
                status: "pending",
              ),
            )
          );
      }
    }else{
      return SafeArea(
        child: Scaffold(
          body: IsiMenu2(
            key: key == null ? ValueKey("Tanpa_Key") : key,
            status: "pending",
          ),
        )
      );
    }

  }
}


class IsiMenu2 extends StatefulWidget {
  final String status;
  final Key? key; // ini buat force rebuild klo misalkan notif nyala ttp di Menu2()

  IsiMenu2({required this.status, this.key}) : super(key: key);

  @override
  _KontenMenu2 createState() => _KontenMenu2();
}

class _KontenMenu2 extends State<IsiMenu2> {
  bool isPending = true;
  bool isCompleted = false;
  bool isCancelled = false;

  var formatRp = NumberFormat.currency(
    locale: "id_ID",
    symbol: "Rp. ",
    decimalDigits: 0
  );

  List<dynamic> listData = [];
  var dio = Dio();

  bool isLoading = true;
  var jwtUser = "";

  Future<void> getData(String mode) async {
    var jwt = await getStoredJwt();
    setState(() {
      jwtUser = jwt ?? ''; // store jwt ke variabel global
    });

    try {
      var response = await dio.get('${myIpAddr()}/checkout?status=$mode', 
        options: Options(
          headers: {
            "authorization": "bearer $jwt"
          }
        )
      );

      print(response);

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          listData = response.data; // Update listData with new data
          isLoading = false; // Set loading to false
        });
      } else {
        print("Error: ${response.statusCode} - ${response.statusMessage}");
        setState(() {
          isLoading = false; // Set loading to false even if there's an error
        });
      }

      // print(listData);

    } catch (e) {
      print("Ada Error $e");
    } 
  }

  // // Websocket channel
  // late WebSocketChannel _channel;
  // Timer? _timerStatus;

  // void _connectToWebSocket(){
  //   // mesti replace dari http ke ws. krn myIpAddr ini ada http.
  //   var originalUrl = myIpAddr();
  //   var replacedUrl = originalUrl.replaceAll("http", "ws");

  //   // ambil endpoint route websocket yg udh dibuat
  //   var wsUri = Uri.parse("$replacedUrl/ws-transaksi");

  //   // buat koneksi websocket
  //   _channel = IOWebSocketChannel.connect(wsUri);

  //   // ambil pesan dari server
  //   _channel.stream.listen((message) async {
  //     // parse message yg akan datang. asumsinya json.
  //     final data = jsonDecode(message);
  //     print(data);

  //     // get data user
  //     var thisUser = await getMyData(jwtUser);

  //     // Utk Cek apakah useryg login skrg sama dgn data email cust yang diwebsocket
  //     // klo misal admin update utk beda user, jd ga perlu update data websocket.
  //     if(thisUser['email'] == data['email_cust']){
  //       switch (data['status_trans']) {
  //         case 'COMPLETED':
  //           setState(() {
  //             isLoading = true;
  //           });

  //           _timerStatus = Timer(Duration(milliseconds: 1500), ()  {
  //             getData("completed").then((_) {
  //               setState(() {
  //                 isLoading = false;
  //                 isPending = false;
  //                 isCancelled = false;
  //                 isCompleted = true;
  //               });
  //             });
  //           });

  //           break;
  //         case 'CANCELLED':
  //           setState(() {
  //             isLoading = true;
  //           });

  //           _timerStatus = Timer(Duration(milliseconds: 1500), () {
  //             getData("cancelled").then((_) {
  //               setState(() {
  //                 isLoading = false;
  //                 isPending = false;
  //                 isCancelled = true;
  //                 isCompleted = false;
  //               });
  //             });
  //           });
  //           break;
  //       }
  //     }
  //   }, onError: (err) {
  //     print("Websocket error: $err");
  //   }, onDone: () {
  //     print("Websocket Closed");
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    switch (widget.status) {
      case "completed":
        getData("completed").then((_) {
          setState(() {
            isLoading = false;
            isPending = false;
            isCancelled = false;
            isCompleted = true;
          });
        });
        break;
      case "cancelled":
        getData("cancelled").then((_) {
          setState(() {
            isLoading = false;
            isPending = false;
            isCancelled = true;
            isCompleted = false;
          });
        });
        break;
      default:
        getData("pending").then((_) {
          setState(() {
            isLoading = false;
            isPending = true;
            isCancelled = false;
            isCompleted = false;
          });
        });
        break;
    }

    // _connectToWebSocket();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Matikan koneksi websocket ketika menu ini diclose
    // _channel.sink.close();
    // _timerStatus?.cancel();
    super.dispose();

  }



  Widget _buildTransactionCard(Map<String, dynamic> items, String statusType) {
    IconData icon;
    String statusLabel;
    if (statusType == 'completed') {
      icon = Icons.check;
      statusLabel = 'Completed';
    } else if (statusType == 'cancelled') {
      icon = Icons.cancel;
      statusLabel = 'Cancelled';
    } else {
      icon = Icons.pending_actions;
      statusLabel = 'Pending';
    }

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
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(0.2)
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45, left: 40),
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
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 125, top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (items['nama_paket'] != null)
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
                  style: const TextStyle(
                    fontSize: 11
                  ),
                ),
                const SizedBox(height: 3,),
                Row(
                  children: [
                    Flexible(
                      child: Icon(icon, size: 20)
                    ),
                    Expanded(
                      child: Text(statusLabel, style: const TextStyle(fontSize: 12)),
                    )
                  ],
                )
              ],
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 45),
            child: Text(
              "${items['tgl_trans'].substring(0, 10)}",
              style: const TextStyle(fontSize: 12)
            )
          ),
          Positioned(
            right: 25,
            top: 45,
            child: Text(
              formatRp.format(items['total_harga']), 
              style: const TextStyle(fontSize: 12),
            ),
          )
        ]
      ),
    );
  }

  Widget _buildList(String statusType) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (listData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text("No Data"),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: listData.map((items) => _buildTransactionCard(items, statusType)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              color: Colors.blue[400],
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
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
                    child: const Text('Pending', style: TextStyle(color: Colors.white))
                  )
                ),
                Container(
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
                    onTap: () async {
                      await getData('completed');
                      if(mounted){
                        setState(() {
                          isPending = false;
                          isCancelled = false;
                          isCompleted = true;
                        });
                      }
                    },
                    child: const Text('Completed', style: TextStyle(color: Colors.white))
                  )
                ),
                Container(
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
                    onTap: () async {
                      await getData('cancelled');
                      if(mounted){
                        setState(() {
                          isPending = false;
                          isCancelled = true;
                          isCompleted = false;
                        });
                      }
                    },
                    child: const Text('Cancelled', style: TextStyle(color: Colors.white))
                  )
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3)
                )
              ]
            ),
            child: isPending 
                ? _buildList('pending')
                : isCompleted
                    ? _buildList('completed')
                    : _buildList('cancelled'),
          ),
        ],
      ),
    );
  }
}