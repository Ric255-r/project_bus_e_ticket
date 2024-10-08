import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bus_hub/main.dart';


class SecondUbahProfile extends StatelessWidget {
  const SecondUbahProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Ubah Profil"),
        backgroundColor: Colors.blue[400],),
        body: IsiMenuUbahProfil(),
      )
    );
  }
}


class IsiMenuUbahProfil extends StatefulWidget {
  @override
  _KontenUbahProfil createState() => _KontenUbahProfil();
}

class _KontenUbahProfil extends State<IsiMenuUbahProfil> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: (screenHeight <= 700) ? screenHeight + 485 : screenHeight,
        child: Stack(
          children: [
            // Bagian Carousel
            Container(
              color: Colors.blue[400],
              height: 300,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 70,
                        left: 20,
                        right: 20
                      ),
                    child:GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                        return Dialog(
                            child: InteractiveViewer(
                            child: Image.asset('assets/images/profile.jpg'),
                            ),
                        );
                          }
                        );
                      },
                      child: Container(

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                          image: const DecorationImage(image:
                          AssetImage('assets/images/profile.jpg'), fit: BoxFit.contain),
                          border: Border.all(
                            color: Colors.blueGrey.shade100
                          )
                        ),
                        height: 200,
                        width: 200,
                      )
                    )
                  )
                  )
                ]
              )
            ),
            Positioned(
              top: 255,
              left: 20,
              right: 20,
              bottom: 75,
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
                height: screenHeight,
                width: MediaQuery.of(context).size.width, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, top: 20),
                            child: Text('Nama Lengkap'),
                            
                          )
                        )
                      ],
                    ),
                  
                    Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30, top: 20, right : 30),
                    child: TextFormField(
                      readOnly: false,
                      initialValue: 'Asep Budiman',
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    enabled: true,
                    
                  ),
                  ),

                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, top: 20),
                      child: Text('No HP'),
                      )
                      ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30, bottom: 20, right : 30),
                    child: TextFormField(
                      readOnly: false,
                      initialValue: '-',
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    enabled: true,
                  ),
                  ),

                  const Row(
                    children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, bottom: 20),
                            child: Text('Email'),
                            
                          )
                        )
                      ],
                    ),
                  
                    Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30, bottom:20, right : 30),
                    child: TextFormField(
                      readOnly: false,
                      initialValue: '-',
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    enabled: true,
                  ),
                  ),

                  const Row(
                    children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, bottom: 20),
                            child: Text('Jenis Kelamin'),
                            
                          )
                        )
                      ],
                    ),
                  
                    Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30, bottom: 20, right : 30),
                    child: TextFormField(
                      readOnly: false,
                      initialValue: '-',
                    decoration: InputDecoration(
                      enabledBorder:  OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    enabled: true,
                  ),
                  ),


                  const Row(
                    children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, bottom: 20),
                            child: Text('Tanggal Lahir'),
                            
                          )
                        )
                      ],
                    ),
                  
                    Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30, bottom: 20, right : 30),
                    child: TextFormField(
                      readOnly: false,
                      initialValue: '-',
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    enabled: true,
                  ),
                  ),

                  ]
                  )
              )
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 870,
                      left: 20,
                      right: 20
                    ),
                    child: MaterialButton(
                      height: 50,
                      onPressed: () {

                      },
                      child: Text('Simpan', style: TextStyle(color: Colors.white),),
                      minWidth: 200,
                      color: Colors.blue[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                    )
                  )
                )
              ],
            ),
          ]
        )
      )
    );
  }
}