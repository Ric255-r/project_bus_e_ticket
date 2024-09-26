import 'dart:async';

import 'package:bus_hub/screen/content/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart'; //buat convert date
import 'package:auto_size_text/auto_size_text.dart';


// biar bisa akses variabel/fungsi dari class ini
final GlobalKey<_BodyPesanTiketState> bodyPesanTiketKey = GlobalKey<_BodyPesanTiketState>();

class Pesantiket extends StatelessWidget {
  // Buat Nullable parameter kalo dia dipanggil dari halteTerdekat.dart
  final String? existsHalte;

  const Pesantiket({super.key, this.existsHalte});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Center(
            child: Padding(
              padding: EdgeInsets.only(
                right: 60
              ),
              child: Text("Perencanaan Travel"),
            ),
          ),
          backgroundColor: Colors.blue[400],
        ),
        body: (existsHalte != null) ? BodyPesanTiket(existsHalteStless: existsHalte,) : BodyPesanTiket(),
      ),
    );
  }
}

class BodyPesanTiket extends StatefulWidget {
  // Buat parameter utk ambil dari statelesswidget
  final String? existsHalteStless;

  // assign key global ke sini. supaya bisa akses variable/fungsi dari state ini.
  BodyPesanTiket({Key? key, this.existsHalteStless}) : super(key: bodyPesanTiketKey);

  @override
  State<BodyPesanTiket> createState() => _BodyPesanTiketState();
}

class _BodyPesanTiketState extends State<BodyPesanTiket> {
  TextEditingController txtKotaAsal = TextEditingController();
  TextEditingController txtKotaTujuan = TextEditingController();
  TextEditingController txtTglBrkt = TextEditingController();
  TextEditingController txtTglBalik = TextEditingController();
  TextEditingController txtJlhPenumpang = TextEditingController();
  TextEditingController txtKlsBis = TextEditingController();
  TextEditingController busPilihan = TextEditingController();
  bool ppSwitch = false;
  bool isCheckHarga = false;
  String changeUbahTextBis = "";

  void ubahTextBis(String value){
    setState(() {
      changeUbahTextBis = value;
      busPilihan.text = value;
    });
  }

  bool showErrorText = false;

  void fnShowErrorText(){
    setState(() {
      showErrorText = true;
    });

    //bikin timer utk switch kondisinya lagi slama 3 detik;
    Timer(Duration(seconds: 3), () {
      setState(() {
        showErrorText = false;
      });
    });
  }

  @override
  void dispose() {
    // ubah value variable kalo user keluar dr page ini : 
    changeUbahTextBis = "";
    isCheckHarga = false;

    // dispose semua value controller
    txtKotaAsal.dispose();
    txtKotaTujuan.dispose();
    txtTglBrkt.dispose();
    txtTglBalik.dispose();
    txtJlhPenumpang.dispose();
    txtKlsBis.dispose();

    super.dispose();
  }

  List<String> kota = ["Pontianak", "Singkawang", "Sambas"];

  double? screenWidth;

  //buat scrollbar sama scrollsection kaya a href
  final ScrollController _scrollController = ScrollController();
  //buat global key untuk target widget yg mw d scroll pas material btn di pencet
  final GlobalKey _detailHarga = GlobalKey();

  //fungsi buat scroll ke widget dengan globalkey
  void _scrollToSection(){
    final context = _detailHarga.currentContext;
    if(context != null){
      // kalkulasi posisi widget
      Scrollable.ensureVisible(
        context,
        duration: Duration(seconds: 1), // smooth scrolling
        curve: Curves.easeInOut
      );
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if(widget.existsHalteStless != null){
      busPilihan.text = widget.existsHalteStless!;
    }

    if(changeUbahTextBis != ""){
      busPilihan.text = changeUbahTextBis;
    }

    var selectedCity;
    var selectedCityTujuan;

    return SingleChildScrollView(
      child: SizedBox(
        height: (screenHeight <= 700) ? screenHeight * 2.0 : screenHeight * 1.75,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              color: Colors.blue[400],
              height: 300,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 30,),

                    Image.asset(
                      'assets/images/tayo.png',
                      height: 150,
                      width: 150,
                    )

                  ],
                ),
              )
            ),
            SizedBox(height: 20,),
            
            Positioned(
              top: 240,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3)
                    ),
                    
                  ]
                ),
                // dalam sini hrs Define a fixed height instead of using Expanded
                // jd harus pake container dlu. baru taruh column and row and expanded.
                // klo g die error
                child: Container(
                  padding: EdgeInsets.all(16),
                  height: (screenHeight <= 700) ? screenHeight + 50 : screenHeight - 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // buat ratakiri
                    children: [
                      // Kode Awal
                      // Text("Dari"),
                      // Container(
                      //   child: TextField(
                      //     controller: txtKotaAsal,
                      //     decoration: const InputDecoration(
                      //       hintText: 'Masukkan KOta Asal',
                      //       hintStyle: TextStyle(
                      //         fontWeight: FontWeight.w200
                      //       ),
                      //       prefixIcon: Icon(
                      //         Icons.location_city,
                      //         size: 28.0,
                      //       ),
                      //     )
                      //   ),
                      // ),

                      // Kode Baru
                      Text("Dari"),
                      DropdownButtonFormField<String>(
                        value: selectedCity,
                        hint: Text('Masukkan Kota Asal'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        items: kota.map((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 3
                              ),
                              child: Text(city),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCity = newValue;
                            txtKotaAsal.text = (newValue == null) ? "" : newValue;
                          });
                        },
                      ),
                      
                      const SizedBox(height: 20,),

                      const Text("Ke"),
                      DropdownButtonFormField<String>(
                        value: selectedCityTujuan,
                        hint: const Text("Masukkan Kota Tujuan"),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_city)
                        ),
                        items: kota.map((String isiKota) {
                          return DropdownMenuItem(
                            value: isiKota,
                            child: Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(isiKota),
                            )
                          );
                        }).toList(), 

                        onChanged: (String? newValue){
                          setState(() {
                            selectedCityTujuan = newValue;
                            txtKotaTujuan.text = (newValue == null) ? "" : newValue;
                          });
                        }
                      ),
                      const SizedBox(height: 20,),

                      const Text("Jasa Bis"),
                      Container(
                        child: InkWell(
                          onTap: () {
                            if(txtKotaAsal.text.isEmpty || txtKotaTujuan.text.isEmpty){
                              fnShowErrorText();
                            }else{
                              _dialogBuilder(context);
                            }
                          },
                          child: IgnorePointer( //mencegah textfield interactive
                            child: TextField(
                              readOnly: true,
                              controller: busPilihan,
                              decoration: const InputDecoration(
                                hintText: 'Bus Pilihan',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w200
                                ),
                                prefixIcon: Icon(
                                  Icons.location_city,
                                  size: 28.0,
                                ),
                              )
                            ),
                          )
                        )
                      ),
                      const SizedBox(height: 20,),

                      if(showErrorText)
                      AnimatedOpacity(
                        opacity: showErrorText ? 1.0 : 0.0, 
                        duration: Duration(milliseconds: 200),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: const Text(
                            "Kota Asal / Kota Tujuan Tidak Boleh Kosong!",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),

                      const Row(
                        children: [
                          Expanded(
                            child:  Text("Tanggal Berangkat"),
                          ),
                          Expanded(
                            child:  Text("Round Trip?", textAlign: TextAlign.right,)
                          )
                        ],
                      ),
                      Container(
                        child: Stack(
                          children: [
                            TextField(
                              controller: txtTglBrkt,
                              onTap: () {
                                showDatePickerDialog(context, "pergi");
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Input Tgl Berangkat',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w200,
                                ),
                                prefixIcon: const Icon(
                                  Icons.account_box,
                                  size: 28.0,
                                ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Switch(
                                    value: ppSwitch,
                                    onChanged: (bool value) {
                                      setState(() {
                                        ppSwitch = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),



                      if(!ppSwitch)
                      const SizedBox(height: 20,),

                      if(!ppSwitch)
                      Wrap(
                        children: [
                          Text("Input Tanggal Balik"),
                          Container(
                            child: TextField(
                              controller: txtTglBalik,
                              readOnly: true,
                              onTap: () {
                                showDatePickerDialog(context, "pulang");
                              },
                              decoration: const InputDecoration(
                                hintText: 'Input Tgl Balik',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w200
                                ),
                                prefixIcon:  Icon(
                                  Icons.account_box,
                                  size: 28.0,
                                ),
                              )
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Penumpang"),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 10
                                  ),
                                  child: Container(
                                    child: TextField(
                                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: txtJlhPenumpang,
                                      decoration: const InputDecoration(
                                        hintText: '... Penumpang',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w200
                                        ),
                                        prefixIcon: Icon(
                                          Icons.account_box,
                                          size: 28.0,
                                        ),
                                      )
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Kelas Bis"),
                                
                                Container(
                                  child: TextField(
                                    controller: txtKlsBis,
                                    decoration: const InputDecoration(
                                      hintText: 'Economy/Executive',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w200
                                      ),
                                      prefixIcon: Icon(
                                        Icons.account_box,
                                        size: 28.0,
                                      ),
                                    )
                                  ),
                                ),
                              ],
                            )
                          )
                        ],
                      ),

                      const SizedBox(height: 20,),

                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            isCheckHarga = true;
                          });

                          // Use this to wait until the frame is built and then scroll
                          // kalo cmn panggil fungsi scrollsection, ntr die mesti di klik 2x
                          // krn widgetnya blm kebuild. ak set boolean baru tampil
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollToSection();
                          });
                          
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        child: Text("Check Harga"),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                      )
                    ],
                  ),
                ),
              )
            ),
          
            SizedBox(height: 20,),

            if(isCheckHarga)
            Positioned(
              top: (screenHeight <= 700) ? screenHeight + 320 : screenHeight + 180,
              left: 20,
              right: 20,
              child: Container(
                key: _detailHarga,
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
                                child: Text("Jenis & Kelas Bis")
                              ),
                              Expanded(
                                flex: 1,
                                child: Align( // tambah align biar bs kekanan
                                  alignment: Alignment.centerRight, 
                                  child: Text("${busPilihan.text} / ${txtKlsBis.text}"),
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
                                child: Text("Rute")
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: AutoSizeText( // ini plugin. update pubspec.yaml
                                    "${txtKotaAsal.text} -> ${txtKotaTujuan.text}",
                                    maxLines: 1,
                                    minFontSize: 5,
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
                                child: Text("Biaya Bis")
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("Rp. 300.000 / Orang"),
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
                                child: Text("Penumpang")
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("${txtJlhPenumpang.text} Penumpang"),
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
                                child: Text("Lama Waktu")
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: AutoSizeText( // ini plugin. update pubspec.yaml
                                    "${txtTglBrkt.text} -> ${txtTglBalik.text}",
                                    maxLines: 1,
                                    minFontSize: 5,
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
                                    child: Text("Rp.1.200.000", style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                ),
                              )
                            ],
                          ),
                        


                          // Header Row (Simulating DataTable Columns)
                          // Row(
                          //   children: [
                          //     _buildHeaderCell('Bus /\nClass'),
                          //     _buildHeaderCell('Route'),
                          //     _buildHeaderCell('Passengers'),
                          //     _buildHeaderCell('Dates'),
                          //     _buildHeaderCell('Cost'),
                          //   ],
                          // ),
                          // SizedBox(height: 8.0),
                          
                          // // First Data Row
                          // Row(
                          //   children: [
                          //     _buildDataCell('Bus 1 / Class A'),
                          //     _buildDataCell('City A -> City B'),
                          //     _buildDataCell('50'),
                          //     _buildDataCell('2024-09-22\n2024-09-23'),
                          //     _buildDataCell('Rp. 100.000'),
                          //   ],
                          // ),
                          // Divider(), // Bottom border for first row
                          
                          // // klo mw buat borderbottom, pake divider
                          // // Second Data Row (without bottom border)
                          // // Row(
                          // //   children: [
                          // //     _buildDataCell('Bus 2 / Class B'),
                          // //     _buildDataCell('City C -> City D'),
                          // //     _buildDataCell('30'),
                          // //     _buildDataCell('2024-09-24\n2024-09-25'),
                          // //     _buildDataCell('Rp. 150.000'),
                          // //   ],
                          // // ),
                          // // // No Divider (no bottom border for second row)

                          // Row(
                          //   children: [
                          //     _buildDataCell(""),
                          //     _buildDataCell(""),
                          //     _buildDataCell("Rincian Biaya", modenya: "bold"),
                          //     _buildDataCell(""),
                          //     _buildDataCell("")
                          //   ],
                          // ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     _buildDataCell(""),
                          //     _buildDataCell(""),
                          //     _buildDataCell('Bis & \nKelas Bis', modenya: "bold"),
                          //     _buildDataCell('Damri'),
                          //     _buildDataCell('Executive'),
                          //   ],
                          // ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     _buildDataCell(''),
                          //     _buildDataCell(''),
                          //     _buildDataCell('Rute', modenya: "bold"),
                          //     _buildDataCell('Singkawang'),
                          //     _buildDataCell('Sambas'),
                          //   ],
                          // ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,

                          //   children: [
                          //     _buildDataCell(''),
                          //     _buildDataCell(''),
                          //     _buildDataCell(''),
                          //     _buildDataCell('Harga/Hari', modenya: "bold"),
                          //     _buildDataCell('Rp.120.000', modenya: "bold"),
                          //   ],
                          // ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,

                          //   children: [
                          //     _buildDataCell(''),
                          //     _buildDataCell(''),
                          //     _buildDataCell('Penumpang', modenya: "bold"),
                          //     _buildDataCell('${txtJlhPenumpang.text}'),
                          //     _buildDataCell('Orang'),
                          //   ],
                          // ),

                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,

                          //   children: [
                          //     _buildDataCell(''),
                          //     _buildDataCell(''),
                          //     _buildDataCell('Jangka Waktu', modenya: "bold"),
                          //     _buildDataCell('${txtJlhPenumpang.text}'),
                          //     _buildDataCell('Hari'),
                          //   ],
                          // ),

                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,

                          //   children: [
                          //     _buildDataCell(''),
                          //     _buildDataCell(''),
                          //     _buildDataCell(''),
                          //     _buildDataCell('Total Harga', modenya: "bold"),
                          //     _buildDataCell('Rp.120.000', modenya: "bold"),
                          //   ],
                          // ),
                          

                        ],
                      ),
                    ),
                  
                    SizedBox(height: 5,),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (builder) => MenuCheckout())
                        );
                      },
                      child: Text("Lanjut Ke Pembayaran"),
                    ),

                    SizedBox(height: 10,),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
    
  }
  
  // Helper method to build header cells
  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper method to build data cells
  // supaya bisa nullable, mesti dibungkus dalam object.
  Widget _buildDataCell(String text, {String? modenya}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: (modenya == "bold") ? 
          Text(text, style: TextStyle(fontWeight: FontWeight.bold),) 
          : Text(text),
      ),
    );
  }

  // Widget _buildDataCell(String text, {String? modenya, double? widthnya}){
  //   return SizedBox(
  //     width: 100,
  //     child: Padding(
  //       padding: EdgeInsets.only(
  //         top: 8, bottom: 8, 
  //         left: (screenWidth! <= 1000) ? 10: 60,
  //       ), 
  //       child: (modenya == "bold") ? Text(text, style: TextStyle(fontWeight: FontWeight.bold),) : Text(text),
  //     ),
  //   );
  // }


  Future<Object> _dialogBuilder(BuildContext context) async {
    //awalnya alertdialog, cmn kuganti berdasarkan rekomen AI
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25)
              ),
              width: MediaQuery.of(context).size.width * 0.95, // sini buat atur lebar dialog
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Center(
                      child: Text("Pilih Jasa Bis Yang Diinginkan"),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Scrollbar( // ini buat nunjukin scrollbar
                      thumbVisibility: true,
                      controller: _scrollController,
                      thickness: 5,
                      child: ListView.builder( //pakai builder. awalnya pake singlechildscrollview
                        controller: _scrollController,
                        itemCount: 1, // hitung peritem = 1 biji
                        itemBuilder: (context, index){
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 10, right: 10
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      busPilihan.text = "Damriku";
                                      txtKlsBis.text = "Executive";
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: IsiModalBis(kotaAsal: txtKotaAsal.text, kotaTujuan: txtKotaTujuan.text,),
                                ),
                                
                                                
                                SizedBox(height: 40,),

                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      busPilihan.text = "Damriku";
                                      txtKlsBis.text = "Executive";

                                      
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: IsiModalBis(kotaAsal: txtKotaAsal.text, kotaTujuan: txtKotaTujuan.text,),
                                ),

                                SizedBox(height: 40,),

                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      busPilihan.text = "Damriku";
                                      txtKlsBis.text = "Executive";

                                    });
                                    Navigator.pop(context);
                                  },
                                  child: IsiModalBis(kotaAsal: txtKotaAsal.text, kotaTujuan: txtKotaTujuan.text,),
                                ),
                                SizedBox(height: 40,),

                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      busPilihan.text = "Damriku";
                                      txtKlsBis.text = "Executive";

                                    });
                                    Navigator.pop(context);
                                  },
                                  child: IsiModalBis(kotaAsal: txtKotaAsal.text, kotaTujuan: txtKotaTujuan.text,),
                                ),

                                SizedBox(height: 20,)


                              ],
                            ),
                          );
                        }
                      )
                    ),
                  )
                ],
              )
            ),
          ),
        );
      },
    );
  }


  Future<void> showDatePickerDialog(BuildContext context, String? mode) async {
    String statusPp = "";
    DateTime? selectedDate;

    if(ppSwitch){
      statusPp = "Tanggal Pulang Pergi";
    }else{
      if(mode == "pergi"){
        statusPp = "Tanggal Pergi";
      }else{
        statusPp = "Tanggal Pulang";
      }
    }

    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Column(
              children: [
                Text("Pilih $statusPp", style: TextStyle(fontSize: 18),),

                SizedBox(height: 15,),
                
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black87,
                        width: 0.5
                      )
                    )
                  ),
                )
              ],
            ),
          ),
          content: Container(
            width: 300, // Set a fixed width
            height: 400, // Set a fixed height
            child: SfDateRangePicker(
              headerHeight: 50,
              showNavigationArrow: true,
              minDate: (mode == "pergi") ? DateTime.now() : DateTime.now().add(Duration(days: 1)),
              backgroundColor: Colors.white,
              headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: Colors.white,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  letterSpacing: 1,
                  color: Colors.black,
                )
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                selectedDate = args.value;
                var formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate!);
                
                if(ppSwitch){
                  txtTglBrkt.text = formattedDate;
                  txtTglBalik.text = formattedDate;
                }else{
                  if(mode == "pergi"){
                    txtTglBrkt.text = formattedDate;
                  }else{
                    txtTglBalik.text = formattedDate;
                  }
                }

                Navigator.of(context).pop();
                //print(formattedDate);
              },
            ),
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: const Text("OK")
          //   )
          // ],
        );
      }
    );
  }
}


// class buat isi modal
class IsiModalBis extends StatefulWidget {
  var kotaAsal;
  var kotaTujuan;

  IsiModalBis({super.key, this.kotaAsal, this.kotaTujuan});

  @override
  State<IsiModalBis> createState() => _IsiModalBisState();
}

class _IsiModalBisState extends State<IsiModalBis> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 20,),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 1),
                    child: Image.asset(
                      'assets/images/damrilogo.png',
                      height: 50,
                      width: 100,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 10,
                      right: 5
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20
                            ),
                            child: Text("Rp.300.000", style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(height: 10,),
                          Text("Hari Berikutnya", style: TextStyle(fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  )
                ),
              ],
            ),

            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    "19:52", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10

                    )
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black54, width: 1.0)
                      )
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "9h 5m",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10

                      )
                    ),
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black54, width: 1.0)
                      )
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 5
                      ),
                      child: Text(
                        "19:52", 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10

                        )
                      ),
                    ),
                  )
                ),
              ],
            ),
            SizedBox(height: 10,),

            Row(
              children: [
                Expanded(
                  child: Text("${widget.kotaAsal}", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 5
                      ),
                      child: Text("${widget.kotaTujuan}", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 15,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text("Damri, Executive", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("40 Kursi Tersedia", style: TextStyle(fontWeight: FontWeight.w200))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 5
                      ),
                      child: SizedBox(
                        height: 30,
                        width: 60,
                        child: ElevatedButton(
                          onPressed: () {}, 
                          
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            backgroundColor: Colors.green.shade200,
                            padding: EdgeInsets.zero
                          ),
                          child: Text("4,4 * ")
                        ),
                      )
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/bisdamri1.jpeg',
                        width: double.infinity,
                        height: 120,
                        
                      ),
                    )
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/bisdamri2.jpeg',
                        width: double.infinity,
                        height: 130,
                        
                      ),
                    )
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/bisdamri3.jpg',
                        width: double.infinity,
                        height: 120,
                        
                      ),
                    )
                  ),
                ),
              ]
            ),
          ],
        ),
      )
    );
  }
}
