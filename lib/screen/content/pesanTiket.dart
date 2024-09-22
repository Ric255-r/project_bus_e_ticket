import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart'; //buat convert date

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
        height: (screenHeight <= 700) ? screenHeight + 800 : screenHeight * 1.5,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              color: Colors.blue[400],
              height: 300,
              child:  Center(
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
                  height: (screenHeight <= 700) ? screenHeight + 50 : screenHeight - 400,
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
              top: (screenHeight <= 700) ? screenHeight + 350 : screenHeight - 120,
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
                    )
                  ],
                ),
                
                child: Column(
                  children: [
                    SizedBox(height: 20,),

                    Text("Detail Pemesanan"),

                    SizedBox(height: 10,),

                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row (Simulating DataTable Columns)
                          Row(
                            children: [
                              _buildHeaderCell('Bus / Class'),
                              _buildHeaderCell('Route'),
                              _buildHeaderCell('Passengers'),
                              _buildHeaderCell('Dates'),
                              _buildHeaderCell('Cost'),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          
                          // First Data Row
                          Row(
                            children: [
                              _buildDataCell('Bus 1 / Class A'),
                              _buildDataCell('City A -> City B'),
                              _buildDataCell('50'),
                              _buildDataCell('2024-09-22\n2024-09-23'),
                              _buildDataCell('Rp. 100.000'),
                            ],
                          ),
                          Divider(), // Bottom border for first row

                          // Second Data Row (without bottom border)
                          Row(
                            children: [
                              _buildDataCell('Bus 2 / Class B'),
                              _buildDataCell('City C -> City D'),
                              _buildDataCell('30'),
                              _buildDataCell('2024-09-24\n2024-09-25'),
                              _buildDataCell('Rp. 150.000'),
                            ],
                          ),
                          // No Divider (no bottom border for second row)

                          Row(
                            children: [
                              _buildDataCell('Bus 2 / Class B'),
                              _buildDataCell('City C -> City D'),
                              _buildDataCell('30'),
                              _buildDataCell('2024-09-24\n2024-09-25'),
                              _buildDataCell('Rp. 150.000'),
                            ],
                          ),
                        ],
                      ),
                    ),
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
  Widget _buildDataCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(text),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();

  Future<void> _dialogBuilder(BuildContext context) async {
    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          scrollable: true,
          title: Center(
            child: const Text("Jasa Bis Tersedia"),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Scrollbar( // ini buat nunjukin scrollbar
              thumbVisibility: true,
              controller: _scrollController,
              child: ListView.builder( //pakai builder. awalnya pake singlechildscrollview
                controller: _scrollController,
                itemCount: 1, // hitung peritem = 1 biji
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      IsiModalBis(kotaAsal: txtKotaAsal.text, kotaTujuan: txtKotaTujuan.text,),
                      IsiModalBis(kotaAsal: txtKotaAsal.text, kotaTujuan: txtKotaTujuan.text,),
                      IsiModalBis(kotaAsal: txtKotaAsal.text, kotaTujuan: txtKotaTujuan.text,),
                      IsiModalBis(kotaAsal: txtKotaAsal.text, kotaTujuan: txtKotaTujuan.text,),
                      IsiModalBis(kotaAsal: txtKotaAsal.text, kotaTujuan: txtKotaTujuan.text,),

                    ],
                  );
                }
              )
            )
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge
              ),
              onPressed: (){
                Navigator.of(context).pop("disable"); // ini return result
              }, 
              child: const Text("Disable"),
              
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop("Enable"); // ini return result
              },
            ),
          ],
        );
      }
    ).then((hasil) {
      if(hasil == "disable"){
        print("User Click Disable");
      }else if(hasil == "Enable"){
        print("User Click Enable");
      }else{ // kondisi klo user keluar dr modal tanpa pilih apapun
        print("User g pilih apa2");
      }
    });
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
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: 35
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              color: Colors.black12,
              height: 110,
              width: 110,
            ),
          ),
        ),
        SizedBox(width: 10,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Damri", 
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 5,),
            Text(
              "${widget.kotaAsal} -> ${widget.kotaTujuan}"
            ),
            SizedBox(height: 5,),
            MaterialButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              onPressed: () {
                bodyPesanTiketKey.currentState?.ubahTextBis("Damriku"); // akses fungsi di kls lain.

                Navigator.of(context).pop();
              },
              child: Text("Pergi Ke Sini"),
            ),
          ],
        ),
      ],
    );
  }
}
