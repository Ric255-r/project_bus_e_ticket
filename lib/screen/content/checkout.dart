// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:bus_hub/screen/content/successCheckout.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MenuCheckout extends StatelessWidget {
  // Declare Variable utk Parameter/argument
  var totalBiaya;
  var id_bis;
  var tgl_pergi, tgl_balik, jlh_penumpang, hrg_tiket_perorg;

  // Jadikan ini sebagai argument. ambil dari variable di atas
  MenuCheckout({
    this.totalBiaya, 
    this.id_bis,
    this.tgl_pergi,
    this.tgl_balik,
    this.jlh_penumpang, 
    this.hrg_tiket_perorg
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Padding(
              padding: EdgeInsets.only(
                right: 60
              ),
              child: Text(
                "Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: StfulMenuCheckout(
          totalBiaya: totalBiaya,
          idBis: id_bis,
          tglPergi: tgl_pergi,
          tglBalik: tgl_balik,
          jlhPenumpang: jlh_penumpang,
          hrgTiketPerOrg: hrg_tiket_perorg
        ),
      )
    );
  }
}

class StfulMenuCheckout extends StatefulWidget {
  var totalBiaya;
  var idBis, tglPergi, tglBalik, jlhPenumpang, hrgTiketPerOrg;

  StfulMenuCheckout({
    this.totalBiaya, 
    this.idBis,
    this.tglPergi,
    this.tglBalik,
    this.jlhPenumpang,
    this.hrgTiketPerOrg
  });

  @override
  State<StfulMenuCheckout> createState() => _StfulMenuCheckoutState();
}

class _StfulMenuCheckoutState extends State<StfulMenuCheckout> {
  String paymentMethod = "Transfer";
  File? _imgFile;

  Future<void> _submitBukti(BuildContext context, {String? mode}) async {
    var dio = Dio();
    var storage = new FlutterSecureStorage();

    var jwt = await storage.read(key: "jwt");
    // final now = DateTime.now();
    // final parseNow = DateTime.parse("$now");

    // print(parseNow.minute);
    
    try {
      FormData? formData;

      if(mode == "cash"){
        // yg total_biaya ak jadikan array yg terdiri dari String Formatted di index 0, sama value real di index 1
        // ak malas mw buat parameter lg.
        formData = FormData.fromMap({
          // note. dk bole passing data berisi null. fastapi bkl baca 422 unprocessable entity
          //'buktiByr': "bayarCash",
          'total_harga': widget.totalBiaya[1],
          'id_bis': widget.idBis,
          'tgl_pergi': widget.tglPergi,
          'tgl_balik': widget.tglBalik,
          'jlh_penumpang': widget.jlhPenumpang,
          'hrg_tiket_perorg': widget.hrgTiketPerOrg,
        });
      }else{
        String fileName = _imgFile!.path.split("/").last;
        // yg total_biaya ak jadikan array yg terdiri dari String Formatted di index 0, sama value real di index 1
        // ak malas mw buat parameter lg.
        formData = FormData.fromMap({
          'buktiByr': await MultipartFile.fromFile(_imgFile!.path, filename: fileName),
          'total_harga': widget.totalBiaya[1],
          'id_bis': widget.idBis,
          'tgl_pergi': widget.tglPergi,
          'tgl_balik': widget.tglBalik,
          'jlh_penumpang': widget.jlhPenumpang,
          'hrg_tiket_perorg': widget.hrgTiketPerOrg,
        });
      }

      // salah bodo. pas url akhir aku kasih "/" jadi di API hrs menyesuaikan
      var response = await dio.post('${myIpAddr()}/checkout', 
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $jwt",
            'Content-Type': 'multipart/form-data'
          }
        )
        
      );

    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> _buatBukti() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imgFile = File(image.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var tinggi =  MediaQuery.of(context).size.height;
    var lebar = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        height: (tinggi <= 700) ? tinggi * 2 : tinggi + 300,
        width: lebar,
        color: Colors.blue[400],
        child: Stack(
          children: [
            Container(
              height: 150,
              margin: EdgeInsets.only(
                left: 20, right: 20, top: 20
              ),
              width: lebar,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20, right: 20
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 20
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.lock_clock,
                                  size: 40,
                                )
                              ],
                            )
                          )
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bayar Sebelum",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text("28 Desember 2024"),
                              ],
                            ),
                          )
                        ),
                      ],
                    ),

                    Divider(),
                    SizedBox(height: 10,),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Total Tagihan"
                          )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.totalBiaya[0],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )


                  ],
                ),
              ),

            ),

            Positioned(
              top: 150,
              child: Container(
                width: MediaQuery.of(context).size.width -40,
                height: 220,
                margin: EdgeInsets.only(
                  left: 20, right: 20, top: 30
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 30
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Metode Pembayaran",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/images/logobank.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("Bank Transfer")
                          ),
                          SizedBox(
                            //buat radio
                              width: 40,
                            // height: 40,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Radio<String>(
                                value: 'Transfer', 
                                groupValue: paymentMethod, 
                                onChanged: (String? value){
                                  setState(() {
                                    paymentMethod = value!;

                                    print(paymentMethod);
                                  });
                                }
                              ),
                            )
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/images/cash.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text("Cash")
                          ),
                          SizedBox(
                            //buat radio
                              width: 40,
                            // height: 40,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Radio<String>(
                                value: 'Cash', 
                                groupValue: paymentMethod, 
                                onChanged: (String? value){
                                  setState(() {
                                    paymentMethod = value!;

                                    print(paymentMethod);
                                  });
                                }
                              ),
                            )
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              ),
          
            ),

            Positioned(
              top: 410,
              child: Container(
                margin: EdgeInsets.only(
                  left: 20.0, right: 20.0
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: (_imgFile != null && paymentMethod == "Transfer") ? 350 : 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),

                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20, top: 20, right: 20
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Petunjuk Pembayaran",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                                
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      
                      Divider(),

                      if(paymentMethod == "Transfer")
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 20
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Untuk pembayaran silakan ditransfer ke rekening BCA 7345112979 an BENGKEL TEKNOLOGI INDONESIA. Harap melampirkan bukti transfer ya",
                                style: TextStyle(
                                  fontSize: 15,
                                  //fontWeight: FontWeight.bold
                                  
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ],
                        ),
                      ),


                      if(paymentMethod == "Transfer")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              _imgFile == null
                                  ? Text('No image selected.')
                                  : Image.file(_imgFile!, height: 100, width: 100,),
                              
                              // if(_imgFile == null)
                              SizedBox(height: 20,),

                              ElevatedButton(
                                onPressed: _buatBukti,
                                child: Text((_imgFile != null) ? "Ganti Foto Bukti?" : "Upload Bukti Bayar"),
                              ),
                            ],
                          ),
                        ],
                      ),


                      if(paymentMethod == "Cash")
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: 20
                        ),
                        child : Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Untuk pembayaran silahkan langsung menuju counter halte yang anda pilih, kemudian tunjukkan aplikasi ini ke mereka",
                                style: TextStyle(
                                  fontSize: 15,
                                  //fontWeight: FontWeight.bold
                                  
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            )
                          ],
                        ),
                      ),

                      if(paymentMethod == "Cash")
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _submitBukti(context, mode: "cash");

                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => MenuSuccess(
                                    totalHarga: widget.totalBiaya[0],
                                    mode: "cash",
                                  ))
                                );
                              }, 
                              child: Text("Menuju Kasir")
                            )
                          )
                        ],
                      ),
                    ],
                  ),
                )
              )
            ),

            if(_imgFile != null && paymentMethod == "Transfer")
            Positioned(
              top: 790,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  left: 20, right: 20
                ),
                //alignment: Alignment.centerRight,
                // height: 1,
                //width: 300,
                decoration: BoxDecoration(
                  //color: Colors.green[300],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Spacer(), // This will take up all available space

                        Padding(
                          padding: EdgeInsets.only(
                            right: 40
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _submitBukti(context);
                              
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => MenuSuccess(totalHarga: widget.totalBiaya[0],)
                                )
                              );
                            },
                            child: Text("Konfirmasi Pembayaran ->"),
                          ),
                        ),
                      ],
                    )                
                  ],
                ), 
              )
            )
          ],
        ),
      ),
    );
  }

  Future<Object> showAlertUpload(BuildContext context) async {
    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Column(
              children: [
                Text("Upload Bukti Bayar", style: TextStyle(fontSize: 18),),

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
                ),
              ],
            ),
          ),
          content: Container(
            width: 300, // Set a fixed width
            height: 400, // Set a fixed height
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: (_imgFile == null)
                  ? AssetImage('assets/images/cash.png')
                  : FileImage(_imgFile!) as ImageProvider,
                )
              ],
            )
          ),
        );
      }
    );
  }

}