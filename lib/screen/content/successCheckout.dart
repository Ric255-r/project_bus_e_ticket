import 'package:bus_hub/screen/content/halteTerdekat.dart';
import 'package:bus_hub/screen/content/screen2.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:bus_hub/screen/function/me.dart';
import 'package:bus_hub/screen/menu/menu2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class MenuSuccess extends StatelessWidget {
  var totalHarga;
  MenuSuccess({this.totalHarga});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[400],
        appBar: AppBar(
          //title: Text("Hai"),
          // toolbarHeight: 40,
          backgroundColor: Colors.white,
        ),
        body: TampilanSukses(totalBiaya: totalHarga,),
      )
    );
  }
}

class TampilanSukses extends StatefulWidget {
  var totalBiaya;
  TampilanSukses({this.totalBiaya});

  @override
  State<TampilanSukses> createState() => _TampilanSuksesState();
}

class _TampilanSuksesState extends State<TampilanSukses> {
  var storage = new FlutterSecureStorage();
  var dio = Dio();
  Map<String, dynamic>? responseData;
  String? datePart;
  String? timePart;

  Future<void> getTransaksi() async {
    try {
      var jwt = await storage.read(key: "jwt");

      var response = await dio.get("${myIpAddr()}/checkout",
        options: Options(
          headers: {
            "Authorization" : "Bearer $jwt"
          }
        )
      );

      setState(() {
        responseData = response.data;
        
        String? dateTimeString = responseData!['tgl_trans'];

        if(dateTimeString != null){
          List<String> dateTimePart = dateTimeString.split("T");
          datePart = dateTimePart[0];
          // buang timezone sekalian & detik2 akhir 
          timePart = dateTimePart[1].split('+')[0].split(".")[0]; 
        }
      });

    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransaksi();
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    // ak letak fungsi dalam widget supaya nda butuh parameter context.
    Future<void> tarikJwt(String menu) async {
      var myJwt = await storage.read(key: 'jwt');

      // Tarik Datanya kek gini
      Map<String, dynamic> data = {
        "usernya": await getMyData(myJwt)
      };

      // ini buat cegah biru2 pas di context 
      if(context.mounted){
        // Navigate ke main menu
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(
            builder: (context) => (menu == "History") 
              ? SecondScreen(data: data, indexScreen: 1,) 
              : SecondScreen(data: data)
          ), 
          (Route<dynamic> route) => false
        );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        tarikJwt("SecondScreen");
        return false; // mencegah aksi default backbutton
      },
      child: Stack(
        children: [
          Container(
            height: 450,
            width: width,
            margin: EdgeInsets.only(
              left: 20, right: 20, top: 20
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
              
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 20, right: 20
              ),
              child: (responseData != null) ? Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.money, size: 100,),
                      )
                    ],
                  ),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.totalBiaya, 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                      )
                    ],
                  ),

                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Diteruskan kepada Ekspedisi Damriku", 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12
                          ),
                        ),
                      )
                    ],
                  ),

                  Divider(),

                  const Row(
                    children: [
                      Text(
                        "Rincian Transaksi",
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 10,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          "Status",
                          style: TextStyle(
                            fontSize: 11
                          ),
                        )
                      ),
                      Expanded(
                        child: Text(
                          "Menunggu Konfirmasi",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11,
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
                            fontSize: 11
                          ),
                        )
                      ),
                      Expanded(
                        child: Text(
                          "Transfer",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11,
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
                          "Wakt Transaksi",
                          style: TextStyle(
                            fontSize: 11
                          ),
                        )
                      ),
                      Expanded(
                        child: Text(
                          timePart ?? "N/A", //default value kalo timepart is null
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11,
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
                          "Tanggal Transaksi",
                          style: TextStyle(
                            fontSize: 11
                          ),
                        )
                      ),
                      Expanded(
                        child: Text(
                          datePart ?? "N/A", //default value kalo variable is null
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11,
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
                          "Id Transaksi",
                          style: TextStyle(
                            fontSize: 11
                          ),
                        )
                      ),
                      Expanded(
                        child: Text(
                          responseData!['id_trans'],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11,
                          ),
                        )
                      )
                    ],
                  ),

                  Divider(),


                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          "Bukti Transfer",
                          style: TextStyle(
                            fontSize: 11
                          ),
                        )
                      ),
                      Expanded(
                        child: Text(
                          "Click Here",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11,
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
                          "Total",
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      Expanded(
                        child: Text(
                          widget.totalBiaya,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold
                          ),
                        )
                      )
                    ],
                  ),

                
                  SizedBox(height: 15,),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            tarikJwt("SecondScreen");
                          }, 
                          child: Text("Back To Home")
                        )
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            tarikJwt("History");
                          }, 
                          child: Text("Go To History")
                        )
                      ),
                    ],
                  ),
                ],
              ) : const Center(child: CircularProgressIndicator()),
            ),
          )
        ],
      ),
    );
  }
}