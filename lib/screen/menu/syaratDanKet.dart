import 'package:flutter/material.dart';
import 'package:bus_hub/main.dart';


class SecondSK extends StatelessWidget {
  const SecondSK({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(
              left: 40
            ),
            child: Text(
              "Syarat Dan Ketentuan"
            ),
          ),
          backgroundColor: Colors.blue[400],
          foregroundColor: Colors.white,
        ),
        body: IsiMenuSK(),
      )
    );
  }
}


class IsiMenuSK extends StatefulWidget {
  @override
  _KontenSK createState() => _KontenSK();
}

class _KontenSK extends State<IsiMenuSK> {
  List<String> teks1 = [
    'Pemesanan tiket dapat dilakukan maksimal 1 bulan hingga hari-H sebelum tanggal keberangkatan, tergantung pada kebijakan dan ketersediaan tiket dari vendor',
    'Pembayaran harus dilakukan melalui metode yang tersedia di aplikasi.'
  ];

  List<String> teks2 = [
    'Pengguna dapat membatalkan pembelian atau pemesanan dan akan mendapatkan pengembalian dana secara penuh apabila waktu keberangkatan belum dalam jangka 1 minggu sebelum keberangkatan.',
    'Pengguna dapat menghubungi Kontak CS untuk Pembatalan pada riwayat transaksi. Biaya tambahan mungkin dikenakan untuk perubahan atau pembatalan tiket.'
  ];

  List<String> teks3 = [
    'Pihak Bus_hub mempunyai kewenangan untuk melakukan pemblokiran akun terhadap pengguna yang sengaja melakukan transaksi bersifat spam, jahil, maupun palsu.',
    'Pengguna bertanggung jawab atas semua aktivitas yang dilakukan melalui akun mereka.',
    'Pengguna harus menjaga kerahasiaan informasi akun mereka dan segera melaporkan jika terjadi penyalahgunaan.'
  ];

  List<String> teks4 = [
    'Data pribadi pengguna akan digunakan sesuai dengan kebijakan privasi yang berlaku.',
    'Pengguna setuju untuk memberikan informasi yang akurat dan lengkap saat melakukan pemesanan.'
  ];

  List<String> teks5 = [
    'bus_hub tidak bertanggung jawab atas kerugian yang dialami oleh pengguna dikarenakan bertransaksi diluar aplikasi.',
    'bus_hub berhak untuk mengubah syarat dan ketentuan ini kapan saja tanpa pemberitahuan sebelumnya.'
  ];

  List<String> teks6 = [
    'Syarat dan ketentuan ini diatur oleh hukum yang berlaku di negara tempat bus_hub beroperasi.',
    'Segala sengketa yang timbul akan diselesaikan melalui jalur hukum yang berlaku.'
  ];


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight + 400,
        child: Stack(
          children: [
            // Bagian Carousel
            Container(
              color: Colors.blue[400],
              height: 330,
              child: const Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 100,
                        left: 20,
                        right: 20
                      )
                    )
                  )
                ]
              )

            ),
             Positioned(
              top:20,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3)
                    )
                  ]
                ),
                height: screenHeight + 360,
                width: MediaQuery.of(context).size.width,
                child : Padding(
                  padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                    top: 10
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          "Dengan menggunakan aplikasi ini, Anda menyetujui syarat dan ketentuan yang berlaku. \n \n1. Pemesanan dan Pembayaran \n", 
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: teks1.map((item) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\u2022", style: TextStyle(fontSize: 30),
                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                              ],
                            );
                          }).toList(),
                          
                        ),
                        SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("2. Perubahan dan Pembatalan \n", textAlign: TextAlign.left,),  
                        ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: teks2.map((item) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\u2022", style: TextStyle(fontSize: 30),
                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                              ],
                            );
                          }).toList(),
                          
                        ),
                        SizedBox(height: 20,),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("3. Tanggung Jawab Pengguna \n", textAlign: TextAlign.left,),  
                        ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: teks3.map((item) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\u2022", style: TextStyle(fontSize: 30),
                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                              ],
                            );
                          }).toList(),
                          
                        ),
                        
                         SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("4. Penggunaan Data Pribadi \n", textAlign: TextAlign.left,),  
                        ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: teks4.map((item) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\u2022", style: TextStyle(fontSize: 30),
                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                              ],
                            );
                          }).toList(),
                          
                        ),

                        
                        SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("5. Batasan Tanggung Jawab \n", textAlign: TextAlign.left,),  
                        ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: teks5.map((item) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\u2022", style: TextStyle(fontSize: 30),
                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                              ],
                            );
                          }).toList(),
                          
                        ),
                        SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("6. Hukum yang Berlaku \n", textAlign: TextAlign.left,),  
                        ),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: teks6.map((item) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\u2022", style: TextStyle(fontSize: 30),
                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                              ],
                            );
                          }).toList(),
                          
                        )
                      ],
                    ),
                    
                  ),
              ),     
             ),
            )
          ]
        ),
      )
    );
  }
}