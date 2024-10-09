// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Kebijakan extends StatefulWidget {
  const Kebijakan({super.key, required this.title});
  final String title;

  @override
  State<Kebijakan> createState() => _KebijakanState();
}

class _KebijakanState extends State<Kebijakan> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 150,
                        left: 20,
                        bottom: 40,
                        right: 20,
                      ),
                      child: Stack(
                        children: [
                          // Main container for content
                          Container(
                            width: width - 40,
                            height: height - 280,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),

                          // Title section (Kebijakan Privasi)
                          Container(
                            padding: EdgeInsets.only(top: 30, left: 70),
                            child: Stack(
                              children: [
                                Container(
                                  child: Text(
                                    'Kebijakan Privasi',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 210),
                                  child: Icon(
                                    Icons.privacy_tip,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Section 1: Pengumpulan Informasi
                          Container(
                            padding: EdgeInsets.only(top: 80, left: 20),
                            child: Text('1. Pengumpulan Informasi'),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 100, left: 35),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Kami ',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: 'mengumpulkan informasi pribadi Anda saat Anda mendaftar di situs kami, memesan produk, atau mengisi formulir.',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          // Arrow icon
                          Container(
                            padding: EdgeInsets.only(top: 97, left: 45),
                            child: Icon(
                              Icons.arrow_right,
                              size: 20,
                            ),
                          ),
                          // Additional content under "Pengumpulan Informasi"
                          Container(
                            padding: EdgeInsets.only(top: 145, left: 35),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '     ', // Indent space
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: 'Informasi ini mencakup nama, alamat email, nomor telepon, dan informasi lainnya yang relevan.',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          // Arrow icon
                          Container(
                            padding: EdgeInsets.only(top: 142, left: 45),
                            child: Icon(
                              Icons.arrow_right,
                              size: 20,
                            ),
                          ),

                          // Section 2: Penggunaan Informasi
                          Container(
                            padding: EdgeInsets.only(top: 190, left: 20),
                            child: Text('2. Penggunaan Informasi'),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 210, left: 35),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '     ', // Indent space
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: 'Informasi yang kami kumpulkan digunakan untuk memproses pesanan Anda, meningkatkan layanan kami, dan mengirimkan informasi promosi yang mungkin menarik bagi Anda.',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          // Arrow icon
                          Container(
                            padding: EdgeInsets.only(top: 207, left: 45),
                            child: Icon(
                              Icons.arrow_right,
                              size: 20,
                            ),
                          ),

                          // Section 3: Perlindungan Informasi
                          Container(
                            padding: EdgeInsets.only(top: 270, left: 20),
                            child: Text('3. Perlindungan Informasi'),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 290, left: 35),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '     ', // Indent space
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: 'Kami berkomitmen untuk melindungi informasi pribadi Anda. Kami menerapkan berbagai langkah keamanan untuk menjaga kerahasiaan dan integritas data Anda.',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          // Arrow icon
                          Container(
                            padding: EdgeInsets.only(top: 287, left: 45),
                            child: Icon(
                              Icons.arrow_right,
                              size: 20,
                            ),
                          ),

                          // Section 4: Pembagian Informasi
                          Container(
                            padding: EdgeInsets.only(top: 350, left: 20),
                            child: Text('4. Pembagian Informasi'),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 370, left: 35),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '     ', // Indent space
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: 'Kami tidak akan menjual, memperdagangkan, atau menyewakan informasi pribadi Anda kepada pihak ketiga tanpa persetujuan Anda, kecuali jika diwajibkan oleh hukum.',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          // Arrow icon
                          Container(
                            padding: EdgeInsets.only(top: 367, left: 45),
                            child: Icon(
                              Icons.arrow_right,
                              size: 20,
                            ),
                          ),

                          // Section 5: Hak Pengguna
                          Container(
                            padding: EdgeInsets.only(top: 430, left: 20),
                            child: Text('5. Hak Pengguna'),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 450, left: 35),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '     ', // Indent space
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: 'Anda memiliki hak untuk mengakses, memperbarui, atau menghapus informasi pribadi Anda yang kami miliki. Silakan hubungi kami jika Anda ingin menggunakan hak-hak ini.',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          // Arrow icon
                          Container(
                            padding: EdgeInsets.only(top: 447, left: 45),
                            child: Icon(
                              Icons.arrow_right,
                              size: 20,
                            ),
                          ),

                          // Section 6: Perubahan Kebijakan
                          Container(
                            padding: EdgeInsets.only(top: 510, left: 20),
                            child: Text('6. Perubahan Kebijakan'),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 530, left: 35),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '     ', // Indent space
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: 'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Setiap perubahan akan diumumkan di situs kami, dan kami mendorong Anda untuk meninjau kebijakan ini secara berkala.',
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          // Arrow icon
                          Container(
                            padding: EdgeInsets.only(top: 527, left: 45),
                            child: Icon(
                              Icons.arrow_right,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
