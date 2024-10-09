// import 'package:bus_hub/screen/menu/Profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bus_hub/main.dart';


class SecondUbahPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Ubah Password"),
        backgroundColor: Colors.blue[400],),
        body: IsiMenuUbahPass(),
      )
    );
  }
}



class MenuUbahPassword extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IsiMenuUbahPass(),
      )
    );
  }
}

class IsiMenuUbahPass extends StatefulWidget {
  @override
  _KontenMenuUbahPass createState() => _KontenMenuUbahPass();
}

class _KontenMenuUbahPass extends State<IsiMenuUbahPass> {

  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: (screenHeight <= 700) ? screenHeight + 400 : screenHeight - 200,
        child: Stack(
          children: [
            Container(
              color: Colors.blue[400],
              height: 300,
              child: const Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 40,
                        bottom: 100,
                        left: 20,
                        right: 20
                      ),
                    )
                  )
                ]
              )
            ),
            Container(
             padding: EdgeInsets.only(left: 105, top: 30),
             decoration: BoxDecoration(
              color: Colors.blue[400],
              borderRadius: BorderRadius.circular(8),
             ),
             child: Icon(Icons.lock, color: Colors.white, size: 200,),   
            ),
        Positioned(
              top: 255,
              left: 20,
              right: 20,
              bottom: 120,
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
                            child: Text('Masukkan Password Lama', style: TextStyle(fontSize: 14),),
                          )
                        )
                      ],
                    ),
                  Container(
                    width: 530,
                    height: 70,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30, top: 20, right: 30),
                    child: TextFormField(
                      readOnly: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      
                      hintText: 'Password Lama', hintStyle: TextStyle(fontSize: 14)
                    ),
                    enabled: true,
                  ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, top: 20),
                      child: Text('Masukkan Password Baru', style: TextStyle(fontSize: 14),),
                      )
                      ),

                  Container(
                    width: 530,
                    height: 70,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30, right: 30, top : 10, bottom: 10),
                    child: TextFormField(
                      readOnly: false,
                      
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Password Baru', hintStyle: TextStyle(fontSize: 14)
                    ),
                    enabled: true,
                  ),
                  ),

                const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, top: 10),
                      child: Text('Konfirmasi Password Baru', style: TextStyle(fontSize: 14),),
                      )
                      ),

                  Container(
                    width: 530,
                    height: 70,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    child: TextFormField(
                      readOnly: false,
                      
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Konfirmasi Password Baru',  hintStyle: TextStyle(fontSize: 14)
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
                              top: 610,
                              left: 20,
                              right: 20,
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