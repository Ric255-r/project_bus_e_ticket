import 'package:flutter/material.dart';

class Menu2 extends StatelessWidget {
  final Map<String, dynamic> getDataNya;

  Menu2({required this.getDataNya});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(title: Text('Second Screen')),
      body: Text('Hai ini dari ${getDataNya['usernya']['email']}'),
    );
  }
}