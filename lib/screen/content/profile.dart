import 'package:bus_hub/screen/content/screen2.dart';
import 'package:flutter/material.dart';
import 'package:bus_hub/main.dart';
import '../function/ip_address.dart';


class SecondProfile extends StatelessWidget {
  Map<String, dynamic> data = {};

  SecondProfile({required this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profil Anda"),
          backgroundColor: Colors.blue[400],
          leading: IconButton(
            onPressed: () {
              // Untuk balik ke SecondScreen. harus nested pake ['usernya']['blabla']
              // krn sudah terlanjur
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => SecondScreen(
                    data: {
                      "usernya": data
                    },
                    indexScreen: 2,
                  )
                )
              );
            }, 
            icon: Icon(Icons.arrow_back)
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            // Untuk balik ke SecondScreen. harus nested pake ['usernya']['blabla']
            // krn sudah terlanjur
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(
                builder: (context) => SecondScreen(
                  data: {
                    "usernya": data
                  },
                  indexScreen: 2,
                )
              )
            );

            return false;
          },
          child: IsiMenuProfil(
            dataUser: data,
          ),
        )
      )
    );
  }
}


class IsiMenuProfil extends StatefulWidget {
  Map<String, dynamic> dataUser = {};
  IsiMenuProfil({required this.dataUser});

  @override
  _KontenProfil createState() => _KontenProfil();
}

class _KontenProfil extends State<IsiMenuProfil> {
  Map<String, dynamic> dataUser = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      dataUser = widget.dataUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: SizedBox(
        height: (screenHeight <= 700) ? screenHeight + 475 : screenHeight - 50,
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
                                child: dataUser['profile_picture'] != null
                                 ? Image.network('${myIpAddr()}/fotoprofile/${dataUser['profile_picture']}')
                                 : Image.asset('assets/images/profile.jpg'),
                              ),
                            );
                          }
                        );
                      },
                      child: dataUser['profile_picture'] != null 
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                            image:  DecorationImage(
                              image: NetworkImage('${myIpAddr()}/fotoprofile/${dataUser['profile_picture']}')
                            ),
                            border: Border.all(
                              color: Colors.blueGrey.shade100
                            )
                          ),
                          height: 200,
                          width: 200,
                        ) 
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage('assets/images/profile.jpg'), fit: BoxFit.contain
                            ),
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
              bottom: 45,
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
                        readOnly: true,
                        
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: '${dataUser['username']}',
                      ),
                      enabled: false,
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
                    padding: const EdgeInsets.only(left: 30, bottom: 20,  right : 30),
                    child: TextFormField(
                      readOnly: true,
                      
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      border: const UnderlineInputBorder(),
                      labelText: '${dataUser['no_hp'] ?? '-'}',
                    ),
                    enabled: false,
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
                      padding: const EdgeInsets.only(left: 30, bottom: 20,  right : 30),
                      child: TextFormField(
                        readOnly: true,
                        
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: '${dataUser['email']}',
                      ),
                      enabled: false,
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
                    padding: const EdgeInsets.only(left: 30, bottom: 20,  right : 30),
                    child: TextFormField(
                      readOnly: true,
                      
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      border: const UnderlineInputBorder(),
                      labelText: dataUser['jk'] == null 
                        ? '-'
                        : dataUser['jk'] 
                          ? 'Pria' 
                          : 'Wanita',
                    ),
                    enabled: false,
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
                      padding: const EdgeInsets.only(left: 30, bottom: 10,  right : 30),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: const UnderlineInputBorder(),
                          labelText: '${dataUser['tanggal_lahir']}',
                        ),
                        enabled: false,
                      ),
                    ),
                  ]
                )
              )
            )
           ]
          )
         )
        );
           
    
  }
}