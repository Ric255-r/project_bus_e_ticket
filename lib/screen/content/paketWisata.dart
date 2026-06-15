import 'dart:async';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'checkout.dart';
import 'detailPaketWisata.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class paketwisata1 extends StatefulWidget {
  const paketwisata1({super.key, required this.title});
  final String title;
  @override
  State<paketwisata1> createState() => _paketwisata1();
}

class _paketwisata1 extends State<paketwisata1> {
  var dio = Dio();
  var formatRp = NumberFormat.currency(
    locale: "id_ID",
    decimalDigits: 0,
    symbol: "Rp. "
  );

  List<dynamic>? isiData;
  Timer? _timer;
  var isLoadingImage = true;
  bool hasError = false;
  String errorMessage = '';

  Future<void> tarikPaketWisata() async {
    if (mounted) {
      setState(() {
        hasError = false;
        errorMessage = '';
      });
    }
    try {
      var response = await dio.get('${myIpAddr()}/cekpaket');
      if (mounted) {
        setState(() {
          isiData = response.data;
        });
      }
    } catch (e) {
      print('Error di $e');
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tarikPaketWisata().then((_) {
      _timer = Timer(const Duration(milliseconds: 350), () {
        if (mounted) {
          setState(() {
            isLoadingImage = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToDetail(Map<String, dynamic> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => paketsingkawang( 
          herotag: 'idhero${items['id_paket']}',
          data: {
            "id_paket": items['id_paket'],
            "nama_paket": items['nama_paket'],
            "harga_paket": items['harga_paket'],
            "id_bis": items['id_bis'],
            "rute_awal": items['rute_awal'],
            "rute_akhir": items['rute_akhir'],
            "tgl_brkt": items['tgl_brkt'],
            "tgl_balik": items['tgl_balik'],
            "gbrpaket": items['gbrpaket'],
            "subjudulpaket": items['subjudulpaket'],
            "nama_bis": items['nama_bis'],
            "detailpaket": items['detailpaket'],
            "jlhpenumpang": items['jlhpenumpang']
          }
        )
      )
    );
  }

  void _navigateToCheckout(Map<String, dynamic> items) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (builder) => MenuCheckout(
          totalBiaya: [formatRp.format(double.parse(items['harga_paket'])), double.parse(items['harga_paket'])],
          id_bis: items['id_bis'],
          tgl_pergi: items['tgl_brkt'],
          tgl_balik: items['tgl_balik'],
          jlh_penumpang: items['jlhpenumpang'],
          hrg_tiket_perorg: double.parse(items['harga_paket']) / int.parse(items['jlhpenumpang']),
          id_paket: items['id_paket']
        )
      )
    );
  }

  Widget _buildPackageItem(Map<String, dynamic> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          GestureDetector(
            onTap: () => _navigateToDetail(items),
            child: Hero(
              tag: 'idhero${items['id_paket']}',
              child: Container(
                width: 90,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  image: DecorationImage(
                    image: isLoadingImage 
                      ? const AssetImage('assets/images/loading.gif')
                      : NetworkImage('${myIpAddr()}/fotoPaket/${items['gbrpaket']}') as ImageProvider,
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  items['nama_paket'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
                const SizedBox(height: 4),
                Text(
                  items['subjudulpaket'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12
                  )
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(80, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        backgroundColor: Colors.blue[100]
                      ),
                      onPressed: () => _navigateToCheckout(items),
                      child: const Text(
                        'Pesan',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      )
                    ),
                    Expanded(
                      child: Text(
                        formatRp.format(double.parse(items['harga_paket'])),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.blue
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Header Section
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.blue[400],
              child: Center(
                child: Container(
                  width: 300,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 10,
                      )
                    ]
                  ),
                  child: Center(
                    child: Text(
                      'Paket Wisata',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]
                      )
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Packages List
            if (hasError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal Memuat Paket Wisata',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Silakan periksa koneksi internet Anda atau pastikan server backend berjalan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: tarikPaketWisata,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
            else if (isiData != null)
              Column(
                children: isiData!.map<Widget>((items) => _buildPackageItem(items)).toList(),
              )
            else
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
