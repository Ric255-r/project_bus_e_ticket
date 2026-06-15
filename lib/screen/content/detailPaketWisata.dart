// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers
// file rio
import 'dart:ffi';
import 'dart:convert';

import 'package:bus_hub/screen/function/ip_address.dart';
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
  var formatRp = NumberFormat.currency(locale: "id_ID", symbol: "Rp. ", decimalDigits: 2);

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
    var height = MediaQuery.of(context).size.height;

    // Harus di konversi dlu, krna key jsonnya pake single quotes bkn double quotes
    var detailBenefit = widget.data['detailpaket'];
    detailBenefit = detailBenefit.replaceAll("'", '"');

    // Now decode the JSON
    List<dynamic> jsonData = jsonDecode(detailBenefit);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Image Section
            Container(
              height: (height - 430.0).clamp(200.0, height),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Hero(
                  tag: widget.herotag,
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Image.network(
                      '${myIpAddr()}/fotoPaket/${widget.data['gbrpaket']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Package Information Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['nama_paket'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${widget.data['subjudulpaket']} hanya ${formatRp.format(double.parse(widget.data['harga_paket']))}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Destinasi Wisata :',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: jsonData.map<Widget>((items) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.stop_rounded, size: 10, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                items['benefit'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Journey Details Button Section
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: munculsingkawang
                      ? const BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        )
                      : BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: InkWell(
                  onTap: tooglemunculsingkawang,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.business),
                      const SizedBox(width: 10),
                      const Text('Rincian Perjalanan',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      Icon(
                          munculsingkawang
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
                          size: 30),
                    ],
                  ),
                ),
              ),
            ),

            // Expanded Journey Details Section (if expanded)
            if (munculsingkawang)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Route Start
                        const Text('Dari',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.business_center, size: 15),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(widget.data['rute_awal'],
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),

                        // Route End
                        const Text('Ke',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.business_center, size: 15),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(widget.data['rute_akhir'],
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),

                        // Bus Service
                        const Text('Jasa Bis',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.directions_bus, size: 15),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(widget.data['nama_bis'],
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),

                        // Departure Date
                        const Text('Tanggal Berangkat',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 15),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(widget.data['tgl_brkt'],
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),

                        // Return Date
                        const Text("Tanggal Balik",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 15),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(widget.data['tgl_balik'],
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                        const SizedBox(height: 10),

                        // Jumlah Penumpang
                        const Text('Jumlah Penumpang',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.people, size: 15),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text('${widget.data['jlhpenumpang']} Orang',
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Spacer at the end
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
