// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers
// file rio
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class paketsingkawang extends StatefulWidget {
  const paketsingkawang({super.key, required this.herotag, required this.data});
  final String herotag;
  final Map<String, dynamic> data;

  @override
  State<paketsingkawang> createState() => _paketsingkawang();
}

class _paketsingkawang extends State<paketsingkawang> {
  var formatRp =
      NumberFormat.currency(locale: "id_ID", symbol: "Rp. ", decimalDigits: 2);

  bool _isfavorite = false;
  bool munculsingkawang = false;

  void _tooglefavorite() {
    setState(() {
      _isfavorite = !_isfavorite;
    });
  }

  void tooglemunculsingkawang() {
    setState(() {
      munculsingkawang = !munculsingkawang;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Image Section
            Row(
              children: [
                Container(
                  width: width,
                  height: height - 431.428,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Hero(
                      tag: widget.herotag,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 0),
                        child: AspectRatio(
                          aspectRatio: 4 / 5,
                          child: Image.asset(
                            'assets/images/pekkongril.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Package Information Section
            Row(
              children: [
                Stack(
                  children: [
                    // Package Name
                    Container(
                      padding: EdgeInsets.only(top: 30, left: 20),
                      child: Text(
                        widget.data['nama_paket'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    // Subtitle and Price
                    Container(
                      padding: EdgeInsets.only(top: 60, left: 20),
                      child: Text(
                        '${widget.data['subjudulpaket']} hanya ${formatRp.format(widget.data['harga_paket'])}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),

                    // Destination Title
                    Container(
                      padding: EdgeInsets.only(top: 90, left: 20),
                      child: Text(
                        'Destinasi Wisata :',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),

                    // Destination List
                    Padding(
                      padding: EdgeInsets.only(top: 110),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.data['detailpaket'].map<Widget>((items) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 2, left: 35),
                                  child: Row(
                                    children: [
                                      Icon(Icons.stop_rounded, size: 10, color: Colors.grey),
                                      SizedBox(width: 10), // Space between icon and text
                                      Text(
                                        items['benefit'],
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Journey Details Button Section
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Container(
                    height: 40,
                    width: width - 40.428,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Stack(
                      children: [
                        // Icon
                        Container(
                          padding: EdgeInsets.only(top: 2, left: 90),
                          child: Icon(Icons.business),
                        ),

                        // Text
                        Container(
                          padding: EdgeInsets.only(left: 130, top: 5),
                          child: Text('Rincian Perjalanan'),
                        ),

                        // Drop Down Icon
                        Container(
                          padding: EdgeInsets.only(left: 260, top: 0),
                          child: GestureDetector(
                            onTap: tooglemunculsingkawang,
                            child: Icon(Icons.arrow_drop_down_rounded, size: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Expanded Journey Details Section (if expanded)
            if (munculsingkawang)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                  child: Container(
                    width: width - 40.428,
                    height: height - 461.428,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Route Start
                        Container(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text('Dari', style: TextStyle(fontSize: 13)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30, left: 10),
                          child: Icon(Icons.business_center, size: 15),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 40),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 11,
                            endIndent: 11,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 30),
                          child: Text(widget.data['rute_awal'], style: TextStyle(fontSize: 12)),
                        ),

                        // Route End
                        Container(
                          padding: EdgeInsets.only(top: 60, left: 10),
                          child: Text('Ke', style: TextStyle(fontSize: 13)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 80, left: 10),
                          child: Icon(Icons.business_center, size: 15),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 90),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 11,
                            endIndent: 11,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 80, left: 30),
                          child: Text(widget.data['rute_akhir'], style: TextStyle(fontSize: 12)),
                        ),

                        // Bus Service
                        Container(
                          padding: EdgeInsets.only(top: 110, left: 10),
                          child: Text('Jasa Bis', style: TextStyle(fontSize: 13)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 130, left: 10),
                          child: Icon(Icons.business_center, size: 15),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 140),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 11,
                            endIndent: 11,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 130, left: 30),
                          child: Text(widget.data['nama_bis'], style: TextStyle(fontSize: 12)),
                        ),

                        // Departure Date
                        Container(
                          padding: EdgeInsets.only(top: 160, left: 10),
                          child: Text('Tanggal Berangkat', style: TextStyle(fontSize: 13)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 180, left: 10),
                          child: Icon(Icons.date_range, size: 15),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 190),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 11,
                            endIndent: 11,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 180, left: 30),
                          child: Text(widget.data['tgl_brkt'], style: TextStyle(fontSize: 12)),
                        ),

                        // Return Date
                        Container(
                          padding: EdgeInsets.only(top: 210, left: 10),
                          child: Text("Tanggal Balik", style: TextStyle(fontSize: 13)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 230, left: 10),
                          child: Icon(Icons.date_range, size: 15),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 240),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 11,
                            endIndent: 11,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 230, left: 30),
                          child: Text(widget.data['tgl_balik'], style: TextStyle(fontSize: 12)),
                        ),

                        // Jumlah Penumpang
                        Container(
                          padding: EdgeInsets.only(top: 260, left: 10),
                          child: Text('Jumlah Penumpang', style: TextStyle(fontSize: 13)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 280, left: 10),
                          child: Icon(Icons.business_center, size: 15),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 290),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 11,
                            endIndent: 11,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 280, left: 30),
                          child: Text('${widget.data['jlhpenumpang']} Orang', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Spacer at the end
            Row(
              children: [
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
