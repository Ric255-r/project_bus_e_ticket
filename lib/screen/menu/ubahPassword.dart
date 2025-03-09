// import 'package:bus_hub/screen/menu/Profile.dart';
import 'package:bus_hub/screen/content/screen2.dart';
import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:bus_hub/screen/function/me.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:bus_hub/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


// class SecondUbahPass extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(title: Text("Ubah Password"),
//         backgroundColor: Colors.blue[400],),
//         body: IsiMenuUbahPass(),
//       )
//     );
//   }
// }



class MenuUbahPassword extends StatelessWidget{
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

class IsiMenuUbahPass extends StatefulWidget {
  @override
  _KontenMenuUbahPass createState() => _KontenMenuUbahPass();
}

class _KontenMenuUbahPass extends State<IsiMenuUbahPass> {
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmNewPass = TextEditingController();
  var dio = Dio();
  var storage = FlutterSecureStorage();

  Future<void> updatePass(BuildContext context) async {
    try {
      if(newPass.text != confirmNewPass.text){
        // Fluttertoast.showToast(
        //   msg: "",
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.BOTTOM,
        //   timeInSecForIosWeb: 10,
        //   textColor: Colors.white,
        //   fontSize: 16.0
        // );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Konfirmasi Password Baru Tidak Cocok")
          )
        );
      }else{
        if(oldPass.text.isEmpty){
          // Fluttertoast.showToast(
          //   msg: "Isi Password Lama Dahulu",
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 10,
          //   textColor: Colors.white,
          //   fontSize: 16.0
          // );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Isi Password Lama Dahulu")
            )
          );
        }else{
          var jwt = await storage.read(key: 'jwt');
          var dataUser = await getMyData(jwt);

          var response = await dio.put('${myIpAddr()}/changePass', 
            data: {
              'oldPass': oldPass.text,
              'newPass': newPass.text
            },
            options: Options(
              headers: {
                "Authorization": "Bearer $jwt",
                "Content-Type": "application/json"
              }
            )
          );

          if(response.statusCode == 200){
            if(context.mounted){
              // Ku Sudah terlanjur untuk rute ke screen2.
              // untuk fetch datanya harus lapis object lagi / nested, jadi kaya ['usernya']['bla']
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => SecondScreen(
                    data: {
                      "usernya": dataUser,
                    },
                    indexScreen: 2,
                    alertMessage: "Password Berhasil Diganti",
                    
                  )
                )
              );
            }
          }
        }
      }
    } catch (e) {
      if (e is DioException){
        if(e.response?.statusCode == 401){
          // Fluttertoast.showToast(
          //   msg: "Password Lama Tidak Cocok",
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 10,
          //   textColor: Colors.white,
          //   fontSize: 16.0
          // );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Password Lama Tidak Cocok")
            )
          );
        }
      }

      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    oldPass.dispose();
    newPass.dispose();
    confirmNewPass.dispose();
  }
  
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
              bottom: 140,
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
                      obscureText: true,
                      controller: oldPass,
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
                      controller: newPass,
                      obscureText: true,
                      
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
                      obscureText: true,
                      controller: confirmNewPass,
                      
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
                                updatePass(context);
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