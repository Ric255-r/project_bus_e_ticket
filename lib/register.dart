import 'package:flutter/material.dart';

class MenuRegister extends StatelessWidget {
  const MenuRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: IsiRegister(),
      )
    );
  }
}

class IsiRegister extends StatefulWidget {
  const IsiRegister({super.key});

  @override
  State<IsiRegister> createState() => _regis();
}

//kode rio
class _regis extends State<IsiRegister> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print(width);
    print(height);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue, Color(0xFFD8BFD8)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 130),
                child: Container(
                  width: width - 100,
                  height: height - 330,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Logo
                      Positioned(
                        top: 25,
                        left: 110,
                        child: Container(
                          width: 80,
                          child: Image.asset('assets/images/tayo.png'),
                        ),
                      ),

                      // Form title
                      Positioned(
                        top: 100,
                        left: 65,
                        child: Text(
                          'Form Registrasi',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Nama Lengkap Field
                      Positioned(
                        top: 150,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Nama Lengkap',
                            ),
                          ),
                        ),
                      ),

                      // Masukkan Email Field
                      Positioned(
                        top: 220,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Masukkan Email',
                            ),
                          ),
                        ),
                      ),

                      // Masukkan Password Field
                      Positioned(
                        top: 290,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Masukkan Password',
                            ),
                          ),
                        ),
                      ),

                      // Ulangi Password Field
                      Positioned(
                        top: 360,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Ulangi Password',
                            ),
                          ),
                        ),
                      ),

                      // Daftar Button
                      Positioned(
                        top: 430,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          width: width - 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Sudah Punya Akun? Text
                      Positioned(
                        top: 500,
                        left: 40,
                        child: SizedBox(
                          height: 20,
                          child: Row(
                            children: [
                              Text('Sudah punya Akun?'),

                              Text(
                                ' Login Sekarang',
                                style: TextStyle(color: Colors.blue[700]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
