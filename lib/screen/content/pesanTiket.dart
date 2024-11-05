import 'dart:async';

import 'package:bus_hub/screen/content/checkout.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart'; //buat convert date
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';


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

// ignore: must_be_immutable
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
  double tarifBis = 0.0;
  String id_bis = "";
  var dio = Dio();

  void ubahTextBis(String value){
    setState(() {
      changeUbahTextBis = value;
      busPilihan.text = value;
    });
  }

  bool showErrorText = false;
  bool showDetailHarga = false;
  bool showErrorDetailHarga = false;

  Timer? _timerErr;
  void fnShowErrorText(){
    setState(() {
      showErrorText = true;
    });

    //bikin timer utk switch kondisinya lagi slama 3 detik;
    _timerErr = Timer(Duration(seconds: 3), () {
      setState(() {
        showErrorText = false;
      });
    });
  }

  Timer? _timer;
  void fnShowErrorDetailHarga(){
    setState(() {
      showErrorDetailHarga = true;
    });

    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        showErrorDetailHarga = false;
      });
    });
  }

  List<String> kota = [];
  List<String> idKota = [];
  List<dynamic> arrayRespBis = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // kalo lewat initstate, ga perlu panggil pake keyword "await"
    // penjelasan AI : 
    // In the initState method, you don’t use await directly 
    //because initState itself cannot be marked as async. 
    //The initState method is a synchronous method, 
    //and marking it as async would change its return type to Future<void>, 
    //which is not allowed for lifecycle methods in Flutter
    apiKota();
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

    // timer harus di dispose juga
    _timer?.cancel();
    _timerErr?.cancel();

    super.dispose();
  }


  Future<void> apiKota() async{
    try {
      var response = await dio.get("${myIpAddr()}/kota");
      var respBis = await dio.get("${myIpAddr()}/listbis");

      //krn select * return dlm array, maka declare dlu dlm bentuk array
      List<dynamic> responseBis = respBis.data;
      List<dynamic> responseData = response.data;

      // List<String> arrIdKota = [];
      List<String> arrNamaKota = [];

      for(var kota in responseData){
        // arrIdKota.add(kota['id_kota']);
        arrNamaKota.add(kota['nama_kota']);
      }

      // print(respBis.data);

      setState(() {
        kota = arrNamaKota;
        // idKota = arrIdKota;
        arrayRespBis = responseBis;
      });
    } catch (e) {
      print(e);
      
      setState(() {
        kota = [];
        // idKota = [];
        arrayRespBis = [];
      });
    }
  }

  //  ga bs langsung tarik spt ini. mesti lewat initstate krn async function;
  //List<String> kota = tarikKota('kota');

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

    var showBisPilihan;
    
    if(widget.existsHalteStless != null){
      // busPilihan.text = widget.existsHalteStless!;
      // ini buat if kalo dia pencet lewat menu halte, maka ada modif tampilan sedikit
      showBisPilihan = widget.existsHalteStless!;
    }

    if(changeUbahTextBis != ""){
      busPilihan.text = changeUbahTextBis;
    }

    var selectedCity;
    var selectedCityTujuan;

    var totalBiaya = 0.0;

    if(txtJlhPenumpang.text != ""){
      if(!ppSwitch){
        totalBiaya = (tarifBis * double.parse(txtJlhPenumpang.text)) * 2;
      }else{
        totalBiaya = tarifBis * double.parse(txtJlhPenumpang.text);
      }
    }
    
    final String formattedTarifBis = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp. ",
      decimalDigits: 0
    ).format(tarifBis);

    final String formattedTotalBiaya = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp. ",
      decimalDigits: 0,
    ).format(totalBiaya);

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
                    ),

                    SizedBox(height: 30,),

                    if(showBisPilihan != null)
                    Text(
                      "Bus Pilihan : $showBisPilihan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    )

                  ],
                ),
              )
            ),
            
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
                  height: (screenHeight <= 700) ? screenHeight + 50 : (screenHeight >= 900) ? screenHeight - 200 : screenHeight - 70,
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
                            showDetailHarga = false;
                            txtKotaAsal.text = (newValue == null) ? "" : newValue;
                            busPilihan.text = "";
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
                            showDetailHarga = false;
                            txtKotaTujuan.text = (newValue == null) ? "" : newValue;
                            busPilihan.text = "";
                          });
                        }
                      ),
                      const SizedBox(height: 20,),

                      Text(
                        (showBisPilihan != null) ? "Pilih Jadwal" : "Jasa Bis"
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            if(txtKotaAsal.text.isEmpty || txtKotaTujuan.text.isEmpty){
                              fnShowErrorText();
                            }else{
                              if(showBisPilihan != null){
                                _dialogBuilder(context, txtBusPilihan: showBisPilihan);
                              }else{
                                _dialogBuilder(context);
                              }

                              showDetailHarga = false;
                            }
                          },
                          child: IgnorePointer( //mencegah textfield interactive
                            child: TextField(
                              readOnly: true,
                              controller: busPilihan,
                              decoration: InputDecoration(
                                hintText: (showBisPilihan != null) ? "Pilih Jadwal": "Bus Pilihan",
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w200
                                ),
                                prefixIcon: const Icon(
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
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
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
                            child:  Text("Pergi Saja?", textAlign: TextAlign.right,)
                          )
                        ],
                      ),
                      Container(
                        child: Stack(
                          children: [
                            TextField(
                              controller: txtTglBrkt,
                              onTap: () {
                                setState(() {
                                  txtTglBrkt.text = "";
                                  txtTglBalik.text = ""; //supaya pas on tap ini hilang jg
                                  showDetailHarga = false;
                                });
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
                                        txtTglBalik.text = "";
                                        showDetailHarga = false;
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
                                setState(() {
                                  txtTglBalik.text = "";
                                  showDetailHarga = false;
                                });
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
                                  padding: const EdgeInsets.only(
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
                                      ),
                                      onChanged: (String? value) {
                                        setState(() {
                                          showDetailHarga = false;
                                        });
                                      },
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
                                    readOnly: true,
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

                            if(txtKotaAsal.text != "" && txtKotaTujuan.text != "" && busPilihan.text != "" 
                              && txtTglBrkt.text != "" && txtJlhPenumpang.text != "" && txtKlsBis.text != ""){
                                
                              if(!ppSwitch && txtTglBalik.text == ""){
                                fnShowErrorDetailHarga();
                              }else{
                                showDetailHarga = true;
                              }
                            }else{
                              showDetailHarga = false;
                              fnShowErrorDetailHarga();
                            }

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
                      ),

                      if(showErrorDetailHarga)
                      AnimatedOpacity(
                        opacity: showErrorDetailHarga ? 1.0 : 0.0, 
                        duration: Duration(milliseconds: 200),
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Harap Mengisi Semua data sebelum di Check Harga",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),


          
            SizedBox(height: 20,),

            if(isCheckHarga && showDetailHarga)
            Positioned(
              top: (screenHeight <= 700) ? screenHeight + 320 : screenHeight + 80,
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

                    const Text(
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
                              const Expanded(
                                flex: 1,
                                child: Text("Jenis & Kelas Bis")
                              ),
                              Expanded(
                                flex: 1,
                                child: Align( // tambah align biar bs kekanan
                                  alignment: Alignment.centerRight, 
                                  child: AutoSizeText(
                                    "${busPilihan.text} / ${txtKlsBis.text}",
                                    maxLines: 1,
                                    minFontSize: 7,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 3,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
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
                                    minFontSize: 7,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 3,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text("Biaya Bis")
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("$formattedTarifBis / Orang"),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 3,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
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
                              const Expanded(
                                flex: 1,
                                child: Text("Tanggal Booking")
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: AutoSizeText( // ini plugin. update pubspec.yaml
                                    //"${txtTglBrkt.text} / ${txtTglBalik.text}",
                                    (ppSwitch) ? txtTglBrkt.text : "${txtTglBrkt.text} / ${txtTglBalik.text}",
                                    maxLines: 1,
                                    minFontSize: 5,
                                  ),
                                ),
                              )
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Jenis Tiket ${!ppSwitch ? "(x2)" : "(x1)"}")
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: AutoSizeText( // ini plugin. update pubspec.yaml
                                    (ppSwitch) ? "Pergi" : "Pulang Pergi",
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
                              const Expanded(
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
                                    child: Text(formattedTotalBiaya, style: TextStyle(fontWeight: FontWeight.bold),)
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
                          context, 
                          MaterialPageRoute(
                            builder: (builder) => MenuCheckout(
                            // yg total_biaya ak jadikan array yg terdiri dari String Formatted di index 0, sama value real di index 1
                            // ak malas mw buat parameter lg.
                              totalBiaya: [formattedTotalBiaya, totalBiaya],
                              id_bis: id_bis,
                              tgl_pergi: txtTglBrkt.text,
                              tgl_balik: txtTglBalik.text,
                              jlh_penumpang: int.parse(txtJlhPenumpang.text),
                              hrg_tiket_perorg: totalBiaya / int.parse(txtJlhPenumpang.text),
                            )
                          )
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


  Future<Object> _dialogBuilder(BuildContext context, {String? txtBusPilihan}) async {
    // kalau pilih lewat menu halte
    List<dynamic>? arrWhereBisLike;
    if(txtBusPilihan != null){
      var dio = Dio();

      try {
        var response = await dio.get('${myIpAddr()}/listbis/$txtBusPilihan');

        setState(() {
          arrWhereBisLike = response.data;
        });
      } catch (e) {
        print("Error dialog builder ${e}");
      }
    }

    // ini kalo di pilih lewat menu pesan tiket
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
                      child: Text(
                        (txtBusPilihan != null) ? "Pilih Jadwal Bis Anda" : "Pilih Jasa Bis Yang Diinginkan"
                      ),
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
                              left: 10, right: 10,
                            ),
                            // arrWhereBisLike itu isinya query where like.
                            // ini kalo dia akses pakai menu pesan tiket
                            child: (arrWhereBisLike == null) ? Column(
                              // cek dan filter dlu dalam bentuk list apakah hasil dari kondisi empty atau nda
                              children: arrayRespBis.where((item) {
                                return item['kota_awal'] == txtKotaAsal.text && item['kota_akhir'] == txtKotaTujuan.text;
                              }).toList().isNotEmpty ? 
                                // kalo nd empty maka filter ulang utk dijadikan map.
                                arrayRespBis.where((item) => 
                                  item['kota_awal'] == txtKotaAsal.text && item['kota_akhir'] == txtKotaTujuan.text
                                ).map((item) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        id_bis = item['id_bis'];
                                        busPilihan.text = item['nama_bis'];
                                        txtKlsBis.text = item['nama_kelas'];
                                        tarifBis = item['harga'];
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 10
                                      ),
                                      child: IsiModalBis(
                                        kotaAsal: txtKotaAsal.text, 
                                        kotaTujuan: txtKotaTujuan.text, 
                                        harga: "Rp. ${(item['harga']).round()}",
                                        lama_tempuh: item['lama_tempuh_jam'],
                                        waktu_berangkat: item['waktu_berangkat'],
                                        waktu_sampai: item['waktu_sampai'],
                                        nama_bis: item['nama_bis'],
                                        logojasatravel: item['logojasatravel'],
                                      ),
                                    ),
                                  );
                                }).toList() : [Text("No Data")]

                              
                              // kode lama
                              // arrayRespBis.map((item) {
                              //   var stop = false;
                              //   if( (item['kota_awal'] == txtKotaAsal.text && item['kota_akhir'] == txtKotaTujuan.text) 
                              //     || (item['kota_akhir'] == txtKotaAsal.text && item['kota_asal'] == txtKotaTujuan.text)
                              //   ){
                              //     return InkWell(
                              //       onTap: () {
                              //         setState(() {
                              //           busPilihan.text = item['nama_bis'];
                              //           txtKlsBis.text = item['nama_kelas'];
                              //         });
                              //         Navigator.pop(context);
                              //       },
                              //       child: IsiModalBis(
                              //         kotaAsal: txtKotaAsal.text, 
                              //         kotaTujuan: txtKotaTujuan.text, 
                              //         harga: item['harga'],
                              //         lama_tempuh: item['lama_tempuh_jam'],
                              //         waktu_berangkat: item['waktu_berangkat'],
                              //         waktu_sampai: item['waktu_sampai'],
                              //       ),
                              //     );
                              //   }else{
                              //     return Text("No Data");
                              //   }
                              // }).toList(),
                            ) : Column(
                              // ini kondisi kalo arrWhereBisLike ada isinya. akses pakai menu halte terdekat
                              // cek dan filter dlu dalam bentuk list apakah hasil dari kondisi empty atau nda
                              children: arrWhereBisLike!.where((item) {
                                return item['kota_awal'] == txtKotaAsal.text && item['kota_akhir'] == txtKotaTujuan.text;
                              }).toList().isNotEmpty ? 
                                // kalo nd empty maka filter ulang utk dijadikan map.
                                arrWhereBisLike!.where((item) => 
                                  item['kota_awal'] == txtKotaAsal.text && item['kota_akhir'] == txtKotaTujuan.text
                                ).map((item) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        id_bis = item['id_bis'];
                                        busPilihan.text = item['nama_bis'];
                                        txtKlsBis.text = item['nama_kelas'];
                                        tarifBis = item['harga'];
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 10
                                      ),
                                      child: IsiModalBis(
                                        kotaAsal: txtKotaAsal.text, 
                                        kotaTujuan: txtKotaTujuan.text, 
                                        harga: "Rp. ${(item['harga']).round()}",
                                        lama_tempuh: item['lama_tempuh_jam'],
                                        waktu_berangkat: item['waktu_berangkat'],
                                        waktu_sampai: item['waktu_sampai'],
                                        nama_bis: item['nama_bis'],
                                        logojasatravel: item['logojasatravel']
                                      ),
                                    ),
                                  );
                                }).toList() : [Text("No Data")]

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
                  txtTglBalik.text = "";
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
// ignore: must_be_immutable
class IsiModalBis extends StatefulWidget {
  var kotaAsal;
  var kotaTujuan;
  var harga;
  var waktu_berangkat;
  var waktu_sampai;
  var lama_tempuh;
  var nama_bis;
  var kapasitas_penumpang;
  var logojasatravel;


  IsiModalBis({
    super.key, 
    this.kotaAsal, 
    this.kotaTujuan, 
    this.harga, 
    this.waktu_berangkat,
    this.waktu_sampai,
    this.lama_tempuh,
    this.nama_bis,
    this.logojasatravel
  });

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
                    child: widget.logojasatravel == null 
                    ? Image.asset(
                        'assets/images/nologo.png',
                        height: 50,
                        width: 100,
                        alignment: Alignment.centerLeft,
                    ) 
                    : Image.network(
                      '${myIpAddr()}/fotoLogoBis/${widget.logojasatravel}',
                        height: 50,
                        width: 100,
                        alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
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
                            child: Text("${widget.harga}", style: TextStyle(fontWeight: FontWeight.bold),),
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
                Expanded(
                  flex: 1,
                  child: Text(
                    "${widget.waktu_berangkat}", 
                    style: const TextStyle(
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
                    child: AutoSizeText(
                      "${widget.lama_tempuh}",
                      maxLines: 1,
                      minFontSize: 5,
                      maxFontSize: 10,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
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
                        "${widget.waktu_sampai}", 
                        style: const TextStyle(
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
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text("${widget.nama_bis}", style: TextStyle(fontWeight: FontWeight.bold)),
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
