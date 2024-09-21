import 'package:flutter/material.dart';

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

  BodyPesanTiket({this.existsHalteStless});

  @override
  State<BodyPesanTiket> createState() => _BodyPesanTiketState();
}

class _BodyPesanTiketState extends State<BodyPesanTiket> {
  TextEditingController txtbox1 = TextEditingController();
  TextEditingController txtbox2 = TextEditingController();
  TextEditingController txtbox3 = TextEditingController();
  TextEditingController txtbox4 = TextEditingController();
  TextEditingController txtbox5 = TextEditingController();
  TextEditingController busPilihan = TextEditingController();


  bool ppSwitch = false;

  @override
  void dispose() {
    txtbox1.dispose();
    txtbox2.dispose();
    txtbox3.dispose();
    txtbox4.dispose();
    txtbox5.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if(widget.existsHalteStless != null){
      busPilihan.text = widget.existsHalteStless!;
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: (screenHeight <= 700) ? screenHeight + 200 : screenHeight,
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
                  height: screenHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // buat ratakiri
                    children: [
                      Text("Dari"),

                      Container(
                        child: TextField(
                          controller: txtbox1,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan KOta Asal',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w200
                            ),
                            prefixIcon: Icon(
                              Icons.location_city,
                              size: 28.0,
                            ),
                          )
                        ),
                      ),
                      const SizedBox(height: 20,),

                      const Text("Ke"),
                      Container(
                        child: TextField(
                          controller: txtbox2,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan KOta Tujuan',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w200
                            ),
                            prefixIcon: Icon(
                              Icons.location_city,
                              size: 28.0,
                            ),
                          )
                        ),
                      ),
                      const SizedBox(height: 20,),


                      const Text("Jasa Bis"),
                      Container(
                        child: InkWell(
                          onTap: () {
                            _dialogBuilder(context);
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
                        child: TextField(
                          controller: txtbox3,
                          decoration: InputDecoration(
                            hintText: 'Input Tgl Berangkat',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w200
                            ),
                            prefixIcon: const Icon(
                              Icons.account_box,
                              size: 28.0,
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(
                                right: 10
                              ),
                              child: Switch(
                                value: ppSwitch, 
                                onChanged: (bool value){
                                  setState(() {
                                    ppSwitch = value;
                                  });
                                }
                              ),
                            )
                          )
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
                              controller: txtbox3,
                              decoration: const InputDecoration(
                                hintText: 'Input Tgl Berangkat',
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
                                Text("Bla"),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 10
                                  ),
                                  child: Container(
                                    child: TextField(
                                      controller: txtbox4,
                                      decoration: const InputDecoration(
                                        hintText: 'Kota Asal',
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
                                Text("Bla"),
                                
                                Container(
                                  child: TextField(
                                    controller: txtbox5,
                                    decoration: const InputDecoration(
                                      hintText: 'Kota Asal',
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

                        },
                        minWidth: MediaQuery.of(context).size.width,
                        child: Text("Simpan"),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                      )
                    ],
                  ),
                ),
              )
            )
          ],
        ),
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
                      IsiModalBis(),
                      IsiModalBis(),
                      IsiModalBis(),
                      IsiModalBis(),
                      IsiModalBis(),
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
                Navigator.of(context).pop();
              }, 
              child: const Text("Disable"),
              
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}

class IsiModalBis extends StatefulWidget {
  const IsiModalBis({super.key});

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
              "Sekitar 10km"
            ),
            SizedBox(height: 5,),
            MaterialButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => Pesantiket(existsHalte: "Damri")
                  )
                );
              },
              child: Text("Pergi Ke Sini"),
            ),
          ],
        ),
      ],
    );
  }
}