import 'package:flutter/material.dart';

class panduan extends StatelessWidget {
  const panduan({super.key});

  @override
  Widget build(BuildContext context) {
    return const Panduanbepergian(title: "Panduan Bepergian");
  }
}

class Panduanbepergian extends StatefulWidget {
  const Panduanbepergian({super.key, required this.title});
  final String title;

  @override
  State<Panduanbepergian> createState() => _Panduanbepergian();
}

class _Panduanbepergian extends State<Panduanbepergian> {
  Widget _buildAppStep({required String imagePath, required String desc}) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFAEC6CF).withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerRule({required String imagePath, required String desc}) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFAEC6CF),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[400],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Card 2: Panduan Penggunaan Aplikasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ]),
                child: Column(
                  children: [
                    const Text(
                      'Panduan Penggunaan Aplikasi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAppStep(
                          imagePath: 'assets/images/tiketbis2.png',
                          desc: 'Pesan Tiket Melalui Menu Pesan Tiket',
                        ),
                        _buildAppStep(
                          imagePath: 'assets/images/bayar.png',
                          desc: 'Lakukan Pembayaran',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAppStep(
                          imagePath: 'assets/images/haltebis.png',
                          desc: 'Cek Halte Terdekat Melalui Menu Halte Terdekat',
                        ),
                        _buildAppStep(
                          imagePath: 'assets/images/kunjungan.png',
                          desc: 'Kunjungi Halte Tepat Waktu dan Berangkat',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Card 3: Panduan Pelanggan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ]),
                child: Column(
                  children: [
                    const Text(
                      'Panduan Pelanggan BusHub',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCustomerRule(
                          imagePath: 'assets/images/sabuk.png',
                          desc: 'Gunakan SeatBelt',
                        ),
                        _buildCustomerRule(
                          imagePath: 'assets/images/rokok.png',
                          desc: 'Dilarang Merokok',
                        ),
                        _buildCustomerRule(
                          imagePath: 'assets/images/lari.png',
                          desc: 'Dilarang Berlari',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
