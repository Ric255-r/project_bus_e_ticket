import 'package:bus_hub/screen/content/halteTerdekat.dart';
import 'package:bus_hub/screen/content/screen2.dart';
import 'package:bus_hub/screen/function/me.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MenuSuccess extends StatelessWidget {
  const MenuSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TampilanSukses(),
      )
    );
  }
}

class TampilanSukses extends StatefulWidget {
  const TampilanSukses({super.key});

  @override
  State<TampilanSukses> createState() => _TampilanSuksesState();
}

class _TampilanSuksesState extends State<TampilanSukses> {
  var storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var myJwt = await storage.read(key: 'jwt');

        // Tarik Datanya kek gini
        Map<String, dynamic> data = {
          "usernya": await getMyData(myJwt)
        };

        // ini buat cegah biru2 pas di context 
        if(context.mounted){
          // Navigate ke main menu
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(
              builder: (context) => SecondScreen(data: data,)
            ), 
            (Route<dynamic> route) => false
          );
        }

        return false; // mencegah aksi default backbutton
      },
      child: Text("Hai"),
    );
  }
}