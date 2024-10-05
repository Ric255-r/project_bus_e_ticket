// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class faq extends StatefulWidget{
  const faq({super.key, required this.title});
  final String title;
  
  
  @override
  State<faq> createState() => _faq();
}
class _faq extends State<faq> {
  bool munculpesan = false ;
  bool munculbayar = false;
  bool munculpaket = false;

    void tooglemunculpesantiket() {
      setState(() {
        munculpesan = !munculpesan ;
      });
    }

    void tooglemunculbayar() {
      setState(() {
        munculbayar = !munculbayar ;
      });
    }

    void tooglemunculpaket() {
      setState(() {
        munculpaket = !munculpaket;
      });
    }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    return 
    Scaffold(
      backgroundColor: Colors.blue[400],
      body:
      SingleChildScrollView(
        child: 
        Column(
          children: [
        Row(
          children: [
            Stack(
              children: [
                Padding(padding: EdgeInsets.only(top: 40, left: 20, bottom: 40  , right: 20),
                child: 
                Stack(
                  children: [
                Container(
                  width: width - 40,
                  height: heigth - 85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                 ),
                     Container(
                      padding: EdgeInsets.only(left: 33),
                      child:
                      Stack(
                        children: [
                          Container(
                             padding: EdgeInsets.only(top: 10,left: 10),
                            child: 
                            Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8, left: 270),
                            child: Icon(Icons.question_mark, size: 30)
                          ),
                        ],
                      ),     
                 ),
                  Container(
                    padding: EdgeInsets.only(top:70),
                    child: 
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(Icons.add_circle_sharp),
                        ),
                            Container(
                              padding: EdgeInsets.only(left: 45),
                              child: InkWell(
                                onTap: tooglemunculpesantiket,
                                child: Text('Bagaimana cara memesan tiket', style: TextStyle(fontSize:16),
                        )
                              )
                              
                            ),
                                     munculpesan?
                            Container(
                               padding: EdgeInsets.only(top: 30, left: 45),
                               child: Container(
                                height: 110,
                                width: 300,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: Colors.grey,
                                boxShadow: [
                                  BoxShadow(
                                 color: Colors.grey.withOpacity(0.4),
                                 spreadRadius: 10,
                                blurRadius: 7
                                 )
                                ]
                              ),
                              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Text('Untuk memesan ticket, anda dapat kembali ke halaman menu utama dan memilih menu pesan tiket, dan isikan data sesuai dengan yang diminta', style: TextStyle(fontSize: 14),textAlign: TextAlign.justify,softWrap: true, )
                               ) 
                              ) :Stack(),
                      ],
                    )
                  ) ,
                  Container(      
                    padding: EdgeInsets.only(top: munculpesan? 230 : 100),
                    child: 
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(Icons.add_circle_sharp),
                        ),
                            Container(
                              padding: EdgeInsets.only(left: 45),
                              child: InkWell(
                                onTap: tooglemunculbayar,
                                child: Text('Bagaimana cara membayar tiket', style: TextStyle(fontSize:16),
                        )
                              )
                              
                            ),
                                     munculbayar?
                            Container(
                               padding: EdgeInsets.only(top: 30, left: 45),
                               child: Container(
                                height: 120,
                                width: 300,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: Colors.grey,
                                boxShadow: [
                                  BoxShadow(
                                 color: Colors.grey.withOpacity(0.4),
                                 spreadRadius: 10,
                                blurRadius: 7
                                 )
                                ]
                              ),
                              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Text('Untuk membayar tiket, anda dapat menggunakan fitur transfer dengan cara mentransfer ke no rekening yang tertera kemudian kirimkan buktinya melalui fitur yang tertera', style: TextStyle(fontSize: 14),textAlign: TextAlign.justify,softWrap: true,)
                               ) 
                              ) :Stack(),
                      ],
                    )
                  ),
                  Container(      
                    padding: EdgeInsets.only(top: (munculpesan && munculbayar)? 390:(munculbayar)?  260 : (munculpesan)? 260:130),
                    child: 
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(Icons.add_circle_sharp),
                        ),
                            Container(
                              padding: EdgeInsets.only(left: 45),
                              child: InkWell(
                                onTap: tooglemunculpaket,
                                child: Text('Bagaimana cara membeli paket', style: TextStyle(fontSize:16),
                        )
                              )
                              
                            ),
                            munculpaket?
                            Container(
                               padding: EdgeInsets.only(top: 30, left: 45),
                               child: Container(
                                height: 120,
                                width: 300,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: Colors.grey,
                                boxShadow: [
                                  BoxShadow(
                                 color: Colors.grey.withOpacity(0.4),
                                 spreadRadius: 10,
                                blurRadius: 7
                                 )
                                ]
                              ),
                              padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Text('Untuk membeli paket, anda dapat pergi ke menu paket wisata dan kemudian memilih paket wisata yang sesuai dengan apa yang kalian inginkan dan tekan tombol', style: TextStyle(fontSize: 14),textAlign: TextAlign.justify,softWrap: true,)
                               ) 
                              ) :Stack(),
                      ],
                    )
                  ),
                  ]
                )
                  )
              ],
            )
          ],
        ),  
          ]
        )
      )
    );
  }
}