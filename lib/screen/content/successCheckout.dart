import 'package:bus_hub/screen/content/halteTerdekat.dart';
import 'package:bus_hub/screen/content/screen2.dart';
import 'package:flutter/material.dart';

class MenuSuccess extends StatelessWidget {
  const MenuSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        child: Text("Hai"), 
        onWillPop: () async {
          // Navigate ke main menu
          Navigator.pushAndRemoveUntil(
            context, 
            //sementara rutenya ke halteterdekat dlu. mau passing data
            MaterialPageRoute(builder: (context) => Halteterdekat()), 
            (Route<dynamic> route) => false
          );
          return false; // mencegah aksi default backbutton
        }
      )
    );
  }
}