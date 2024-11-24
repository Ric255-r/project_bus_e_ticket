// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:bus_hub/screen/menu/menu2.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../function/me.dart';
import 'screen2.dart';

class DetailRiwayatStless extends StatelessWidget {
  var idTrans;
  DetailRiwayatStless({this.idTrans});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[400],
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 50
              ),
              child: Text("Transaksi"),
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: DetailRiwayat(
          idTrans: idTrans,
        ),
      )
    );
  }
}

class DetailRiwayat extends StatefulWidget {
  var idTrans;
  DetailRiwayat({this.idTrans});

  @override
  State<DetailRiwayat> createState() => _DetailRiwayatState();
} 

class _DetailRiwayatState extends State<DetailRiwayat> {
  @override
  void initState(){
    super.initState();
    getData();

  }

  var dio = Dio();
  var storage = FlutterSecureStorage();
  var formatRp = NumberFormat.currency(
    locale: "id_ID",
    symbol: "Rp. ",
    decimalDigits: 0
  );

  String statusTrans = "";
  Map<String, dynamic> responseData = {};
  String dateTimePartStr = "";
  String timePart = "";
  String datePart = "";
  

  Future<void> getData() async{
    try {
      var jwt = await storage.read(key: 'jwt');

      var response = await dio.get('${myIpAddr()}/checkout/${widget.idTrans}',
        options: Options(
          headers: {
            "authorization": "bearer $jwt"
          }
        )
      );
      

      setState(() {
        responseData = response.data;

        dateTimePartStr = responseData['tgl_trans'];
        List<String> splitDate = dateTimePartStr.split("T");

        datePart = splitDate[0];
        timePart = splitDate[1].substring(0, 8);
      });

      if(response.data['status_trans'] == "PENDING"){
        setState(() {
          statusTrans = "Menunggu Konfirmasi";
        });
      }else if(response.data['status_trans'] == "COMPLETED"){
        setState(() {
          statusTrans = "Transaksi Sukses";
        });
      }else{
        setState(() {
          statusTrans = "Transaksi Dibatalkan";
        });
      }

      // print(responseData);
    } catch (e) {
      print("Ada error $e");
    }
  }

  TextEditingController alasanTolak = TextEditingController();

  Future<void> cancelTransaksi(String idTrans, BuildContext context) async {
    try {
      var response = await dio.put('${myIpAddr()}/dataTrans/$idTrans', 
        data: {
          "status_trans": "CANCELLED",
          "alasan_tolak": "${alasanTolak.text}"
        }
      );

      var myJwt = await storage.read(key: 'jwt');

      // Tarik Datanya kek gini. supaya bs balik ke screen2.dart. terlanjur
      Map<String, dynamic> data = {
        "usernya": await getMyData(myJwt)
      };

      // ini buat cegah biru2 pas di context 
      if(context.mounted){
        // Navigate ke main menu
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(
            builder: (context) => SecondScreen(data: data, indexScreen: 1,) 
          ), 
          (Route<dynamic> route) => false
        );
      }

    } catch (e) {
      print(e);
    }
  }

  void launchWhatsapp(String number) async {
    var url = 'whatsapp://send?phone=$number';

    if(await canLaunch(url)){
      await launch(url);
    }else{
      print("Whatsapp Ga Keinstall");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    alasanTolak.dispose();
  }


  

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Stack(
        children: [
          // container ini ibarat parent untuk peletakan positioned.
          Container(
            height: (responseData['status_trans'] == "COMPLETED") ? height + 300 : height,
            width: width,
            margin: EdgeInsets.only(
              left: 1, right: 1, top: 20
            ),
          ),

          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: Container(
              height: (responseData['metode_byr'] == "cash" && responseData['status_trans'] == "PENDING") 
                ? 500
                : 415,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: SizedBox(
                height: 300,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20, right: 20
                  ),
                  child: (responseData.isNotEmpty) ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // kombinasikan mainaxisalignment dengan align untuk centerkan expanded
                          Expanded(
                            child: (responseData['metode_byr'] == "cash" && responseData['status_trans'] == "PENDING")
                            ? Align(
                                alignment: Alignment.center,
                                child: QrImageView(
                                  data: responseData['id_trans'],
                                  version: QrVersions.auto,
                                  size: 200,
                                ),
                              )
                            : Icon(Icons.money, size: 100,),
                          )
                        ],
                      ),
                      
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${formatRp.format(responseData['total_harga'])}", 
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),
                            ),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              (responseData['metode_byr'] == "cash" && responseData['status_trans'] == "PENDING") 
                                ? "Harap Menunjukkan QR kepada Jasa Travel ${responseData['jasa_travel']}" 
                                : (responseData['status_trans'] == "CANCELLED" )
                                  ? "Transaksi Anda Sudah Dibatalkan"
                                  : "Diteruskan kepada Jasa Travel ${responseData['jasa_travel']}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12
                              ),
                            ),
                          )
                        ],
                      ),

                      if(responseData['status_trans'] == "PENDING")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context, 
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    scrollable: true,
                                    title: Text(
                                      "Bantuan Pembatalan",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            // Awal. Ubah ide. user gbs cancel
                                            // Row(
                                            //   children: [
                                            //     Expanded(
                                            //       child: TextField(
                                            //         controller: alasanTolak,
                                            //         decoration: const InputDecoration(
                                            //           hintText: 'Input Alasan batal',
                                            //           hintStyle: TextStyle(
                                            //             fontWeight: FontWeight.w200
                                            //           ),
                                            //           prefixIcon: Icon(
                                            //             Icons.comment,
                                            //             size: 28.0,
                                            //           ),
                                            //         ),
                                            //         onChanged: (String? value) {

                                            //         },
                                            //       ),
                                            //     )
                                            //   ],
                                            // ),
                                            // SizedBox(height: 10,),
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.center,
                                            //   children: [
                                            //     ElevatedButton(
                                            //       onPressed: () {
                                            //         cancelTransaksi(responseData['id_trans'], context);
                                            //       },
                                            //       child: Text("Submit"),
                                            //     )
                                            //   ],
                                            // )
                                          
                                            // New. Tembak Ke Whatsapp
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    readOnly: true,
                                                    onTap: () {
                                                      launchWhatsapp('+6285650826414');
                                                    },
                                                    decoration: const InputDecoration(
                                                      hintText: '1. Klik untuk Hubungi CS Whatsapp Kami',
                                                      hintStyle: TextStyle(
                                                        fontWeight: FontWeight.w200,
                                                        fontSize: 12
                                                      ),
                                                      prefixIcon: Icon(
                                                        Icons.phone,
                                                        size: 28.0,
                                                      ),
                                                    ),
                                                    onChanged: (String? value) {

                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10,),

                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    readOnly: true,
                                                    decoration: const InputDecoration(
                                                      hintText: '2. Datang Ke Loket Bis',
                                                      hintStyle: TextStyle(
                                                        fontWeight: FontWeight.w200,
                                                        fontSize: 12
                                                      ),
                                                      prefixIcon: Icon(
                                                        Icons.person_pin_circle_outlined,
                                                        size: 28.0,
                                                      ),
                                                    ),
                                                    onChanged: (String? value) {

                                                    },
                                                  ),
                                                )
                                              ],
                                            ),


                                          ],
                                        ),
                                      )
                                    ),
                                  );
                                }
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 12
                              ),
                              child: Text(
                                "Batalkan Pesanan?",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold,      
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Divider(),

                      const Row(
                        children: [
                          Text(
                            "Rincian Transaksi",
                            style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            )
                          ),
                          Expanded(
                            child: Text(
                              "$statusTrans",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          )
                        ],
                      ),

                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              "Metode Pembayaran",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            )
                          ),
                          Expanded(
                            child: Text(
                              "${responseData['metode_byr']}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          )
                        ],
                      ),

                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: Text(
                              "Waktu Transaksi",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            )
                          ),
                          Expanded(
                            child: Text(
                              "$timePart",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          )
                        ],
                      ),

                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: Text(
                              "Tanggal Transaksi",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            )
                          ),
                          Expanded(
                            child: Text(
                              "$datePart",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          )
                        ],
                      ),

                      if(responseData['status_trans'] == "CANCELLED")
                      SizedBox(height: 5,),

                      if(responseData['status_trans'] == "CANCELLED")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: Text(
                              "Alasan Ditolak",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            )
                          ),
                          Expanded(
                            child: Text(
                              "${responseData['alasan_tolak']}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          )
                        ],
                      ),


                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: Text(
                              "Id Transaksi",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            )
                          ),
                          Expanded(
                            child: Text(
                              "${responseData['id_trans']}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          )
                        ],
                      ),

                      Divider(),


                      SizedBox(height: 5,),
                      
                      if(responseData['metode_byr'] == "transfer")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Text(
                              "Bukti Transfer",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            )
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: InteractiveViewer(
                                        child: Image.network('${myIpAddr()}/buktiByr/${responseData['bukti_foto']}')
                                      ),
                                    );
                                  }
                                );
                              },
                              child: Text(
                                "Click Here",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            )
                          )
                        ],
                      ),

                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
                            child: Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold
                              ),
                            )
                          ),
                          Expanded(
                            child: Text(
                              formatRp.format(responseData['total_harga']),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold
                              ),
                            )
                          )
                        ],
                      ),

                    
                      SizedBox(height: 15,),
                      Divider(),
                    ],
                  )  : const SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ),
              ),
            )
          ),


          if(responseData.isNotEmpty)
          Positioned(
            top: (responseData['metode_byr'] == "cash" && responseData['status_trans'] == "PENDING") 
              ? 550
              : (responseData['status_trans'] == "COMPLETED") ? 740 : 455,
            left: 20,
            right: 20,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3)
                  )
                ],
              ),
              
              child: Column(
                children: [
                  SizedBox(height: 20,),

                  Text(
                    "Detail Pemesanan", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          // spacebetweeen buat // Pushes items to both ends
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              flex: 1,
                              child: AutoSizeText(
                                "Jenis & Kelas Bis",
                                maxLines: 1,
                                minFontSize: 7,
                                maxFontSize: 12,
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align( // tambah align biar bs kekanan
                                alignment: Alignment.centerRight, 
                                child: AutoSizeText(
                                  "${responseData['nama_bis']} / ${responseData['nama_kelas']}",
                                  maxLines: 1,
                                  minFontSize: 7,
                                  maxFontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 3,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child:  AutoSizeText(
                                "Rute",
                                maxLines: 1,
                                minFontSize: 7,
                                maxFontSize: 12,
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: AutoSizeText( // ini plugin. update pubspec.yaml
                                  "${responseData['kota_awal']} -> ${responseData['kota_akhir']}",
                                  maxLines: 1,
                                  minFontSize: 7,
                                  maxFontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 3,),

                        // Cek string length id_paket, cek apakah kosong atau nd
                        if(responseData['id_paket'].length == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child:  AutoSizeText(
                                "Biaya Bis",
                                maxLines: 1,
                                minFontSize: 7,
                                maxFontSize: 12,
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: AutoSizeText( // ini plugin. update pubspec.yaml
                                  //"${txtTglBrkt.text} / ${txtTglBalik.text}",
                                  formatRp.format(responseData['harga']),
                                  maxLines: 1,
                                  minFontSize: 5,
                                  maxFontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        
                        if(responseData['id_paket'].length > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child:  AutoSizeText(
                                "Biaya Paket Bis",
                                maxLines: 1,
                                minFontSize: 7,
                                maxFontSize: 12,
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: AutoSizeText( // ini plugin. update pubspec.yaml
                                  //"${txtTglBrkt.text} / ${txtTglBalik.text}",
                                  formatRp.format(responseData['total_harga']),
                                  maxLines: 1,
                                  minFontSize: 5,
                                  maxFontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        
                        
                        
                        SizedBox(height: 3,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child:  AutoSizeText(
                                "Penumpang",
                                maxLines: 1,
                                minFontSize: 7,
                                maxFontSize: 12,
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: AutoSizeText( // ini plugin. update pubspec.yaml
                                  //"${txtTglBrkt.text} / ${txtTglBalik.text}",
                                  "${responseData['jlh_penumpang']} Penumpang",
                                  maxLines: 1,
                                  minFontSize: 5,
                                  maxFontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 3,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child:  AutoSizeText(
                                "Tanggal Booking",
                                maxLines: 1,
                                minFontSize: 7,
                                maxFontSize: 12,
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: AutoSizeText( // ini plugin. update pubspec.yaml
                                  //"${txtTglBrkt.text} / ${txtTglBalik.text}",
                                  (responseData['tgl_pergi'] == responseData['tgl_balik']) ? "${responseData['tgl_pergi']}" : "${responseData['tgl_pergi']} -> ${responseData['tgl_balik']}",
                                  maxLines: 1,
                                  minFontSize: 5,
                                  maxFontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 2,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child:  AutoSizeText(
                                "Jam Berangkat",
                                maxLines: 1,
                                minFontSize: 7,
                                maxFontSize: 12,
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: AutoSizeText( // ini plugin. update pubspec.yaml
                                  //"${txtTglBrkt.text} / ${txtTglBalik.text}",
                                  "${responseData['waktu_berangkat']} => ${responseData['waktu_sampai']}",
                                  maxLines: 1,
                                  minFontSize: 5,
                                  maxFontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),

                        SizedBox(height: 2,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child:  AutoSizeText(
                                "Jenis Tiket",
                                maxLines: 1,
                                minFontSize: 7,
                                maxFontSize: 12,
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: AutoSizeText( // ini plugin. update pubspec.yaml
                                  (responseData['tgl_pergi'] == responseData['tgl_balik']) ? "Pergi Saja" : "Pulang Pergi",
                                  maxLines: 1,
                                  minFontSize: 5,
                                  maxFontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),


                        
                        Divider(), // buat garis

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Total Biaya", style: TextStyle(fontWeight: FontWeight.bold),)
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    formatRp.format(responseData['total_harga']), 
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  )
                                ),
                              ),
                            )
                          ],
                        ),
                      
                      ],
                    ),
                  ),
                
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        
          if(responseData.isNotEmpty && responseData['status_trans'] == "COMPLETED")
          Positioned(
            top: (responseData['status_trans'] == "COMPLETED") ? 453 : 740,  //440
            left: 20,
            right: 20,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3)
                  )
                ],
              ),
              
              child: Column(
                children: [
                  SizedBox(height: 20,),

                  Text(
                    "Berikut Ini Tiket Anda", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                    ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: const Image(
                                  image: AssetImage('assets/images/Ticket.png'),
                                  height: 150,
                                  width: 150,
                                ),
                              )
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: AutoSizeText(
                                  "Nomor Tiket : ${responseData['generated_ticket']}",
                                  maxLines: 1,
                                  minFontSize: 15,
                                  maxFontSize: 17,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            )
                          ],
                        )
                        // const Row(
                        //   // spacebetweeen buat // Pushes items to both ends
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        //   children: [
                        //     Expanded(
                        //       flex: 1,
                        //       child: AutoSizeText(
                        //         "Jenis & Kelas Bis",
                        //         maxLines: 1,
                        //         minFontSize: 7,
                        //         maxFontSize: 12,
                        //       )
                        //     ),
                        //     Expanded(
                        //       flex: 1,
                        //       child: Align( // tambah align biar bs kekanan
                        //         alignment: Alignment.centerRight, 
                        //         child: AutoSizeText(
                        //           "Bla",
                        //           maxLines: 1,
                        //           minFontSize: 7,
                        //           maxFontSize: 12,
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        // SizedBox(height: 3,),
                      ],
                    ),
                  ),
                
                  SizedBox(height: 5,),
                ],
              ),
            ),
          )
        
      

      
        ],
      ),
    );
  }
}