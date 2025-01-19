import 'package:flutter/material.dart';
import 'faq.dart';

class panduan extends StatelessWidget {
  const panduan({super.key});

    @override
  Widget build(BuildContext context) {
    return Panduanbepergian(title: "title");
  }
}

class Panduanbepergian extends StatefulWidget {
  const Panduanbepergian({super.key, required this.title});
  final String title;

  @override
  State<Panduanbepergian> createState() => _Panduanbepergian();
}

class _Panduanbepergian extends State<Panduanbepergian> {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 65, left: 27, right: 10),
                  width: width -50,
                  height: (height <= 700)? height-330 : height-850 ,
                   decoration: BoxDecoration(
                   color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text('Panduan Berpergian Bersama BusHub', style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
            ),
                  
                  
                )
              ]
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width -50,
                  height: (height <= 700)? height-75 : height -500,
                  margin: EdgeInsets.only(top:15, left: 27, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: 
                    Align( alignment: Alignment.center,
                    child: 
                    Stack(
                      children: [
                        Container(
                          child:
                          Padding(padding: EdgeInsets.only(top:7, left: 70),
                          child:Text('Panduan Penggunaan Aplikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))
                        ),
                        Container(
                          child: 
                          Padding(padding: EdgeInsets.only(top: 45, left: 40),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFAEC6CF).withOpacity(0.3),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                              image: DecorationImage(image: AssetImage('assets/images/tiketbis2.png'),
                               fit: BoxFit.cover,
                               ),
                            )
                          )
                          )
                        ),
                        Container(
                          child: 
                          Padding(padding: EdgeInsets.only(top: 45, left: 210),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFAEC6CF).withOpacity(0.3),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                              image: DecorationImage(image: AssetImage('assets/images/bayar.png'),
                               fit: BoxFit.cover)
                            )
                          )
                          )
                              ),
                        Container(
                          child:
                          Padding(padding: EdgeInsets.only(top: 150, left:20),
                          child: Container(
                            width: 140,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)
                            )
                            ),
                            child: Text('Pesan Tiket Melalui Menu Pesan Tiket', textAlign: TextAlign.center, style: TextStyle( fontSize: 11))
                          )
                          )
                        ),
                        Container(
                          child:
                          Padding(padding: EdgeInsets.only(top: 150, left: 185),
                          child: Container(
                            width: 160,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)
                            )
                            ),
                            child: Text('Lakukan Pembayaran', textAlign: TextAlign.center, style: TextStyle( fontSize: 11))
                          )
                          )
                        ),
                         Container(
                          child: 
                          Padding(padding: EdgeInsets.only(top: 190 , left: 40),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFAEC6CF).withOpacity(0.3),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                              image: DecorationImage(image: AssetImage('assets/images/haltebis.png'),
                               fit: BoxFit.cover)
                            )
                          )
                          )
                        ),
                        Container(
                          child: 
                          Padding(padding: EdgeInsets.only(top: 190, left: 210),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color(0xFFAEC6CF).withOpacity(0.3),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                              image: DecorationImage(image: AssetImage('assets/images/kunjungan.png'),
                               fit: BoxFit.cover)
                            )
                          )
                          )
                              ),
                            Container(
                          child:
                          Padding(padding: EdgeInsets.only(top: 295, left: 20),
                          child: Container(
                            width: 140,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)
                            )
                            ),
                            child: Text('Cek Halte Terdekat Melalui Menu Halte Terdekat', textAlign: TextAlign.center, style: TextStyle(fontSize: 11))
                          )
                          )
                        ),
                        Container(
                          child:
                          Padding(padding: EdgeInsets.only(top: 295, left: 185),
                          child: Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)
                            )
                            ),
                            child: Text('Kunjungi Halte Tepat Waktu dan Berangkat', textAlign: TextAlign.center, style: TextStyle(fontSize: 11))
                          )
                          )
                        )
                      ],
                    ),
                  ),
                )
             
              ],
            ),
            Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width -50,
                    height: (height <= 700)? height-250 : height -750,
                   margin: EdgeInsets.only(top:15, left: 27, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: 
                    Align(alignment: Alignment.center,
                    child: 
                    Stack(
                      children: [
                        Container(
                          child:
                          Padding(padding: EdgeInsets.only(top:7, left: 60),
                          child:Text('Panduan Pelanggan BusHub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)))
                        ),
                        Container(
                          child: 
                          Padding(padding: EdgeInsets.only(top: 45, left: 25),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFAEC6CF),
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              image: DecorationImage(image: AssetImage('assets/images/sabuk.png'),
                               fit: BoxFit.cover)
                            )
                          )
                          )
                        ),
                        Container(
                          child: 
                          Padding(padding: EdgeInsets.only(top: 45, left: 140),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFAEC6CF),
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              image: DecorationImage(image: AssetImage('assets/images/rokok.png'),
                               fit: BoxFit.cover)
                            )
                          )
                          )
                        ),
                        Container(
                          child: 
                          Padding(padding: EdgeInsets.only(top: 45, left: 245),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFAEC6CF),
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              image: DecorationImage(image: AssetImage('assets/images/lari.png'),
                               fit: BoxFit.cover)
                            )
                            // child: 
                            // InkWell(
                            //   onTap :()
                            //   {
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => paketwisata1())
                            //   );
                            // },
                            // child: Text(''),
                            // )
                          )
                          )
                        ),
                        Container(
                          child: Padding(padding: EdgeInsets.only(top:105, left:5),
                          child: Text('Gunakan SeatBelt', style: TextStyle(fontSize: 11)),
                          )
                        ),
                        Container(
                          child: Padding(padding: EdgeInsets.only(top:105, left:123),
                          child: Text('Dilarang Merokok', style: TextStyle(fontSize: 11)),
                          )
                        ),
                        Container(
                          child: Padding(padding: EdgeInsets.only(top:105, left:233 ),
                          child: Text('Dilarang Berlari', style: TextStyle(fontSize: 11)),
                          )
                        )
                      ]
                    )
                    )
                )
              ],
            ),
            Container(
              child: 
              SizedBox(
                height: 20
              )
            )
          ],
        ),
      )
        
       )
      ;
  }
}