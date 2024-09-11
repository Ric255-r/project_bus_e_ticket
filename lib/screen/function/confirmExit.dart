import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// future adalah syntax function buat async await
Future<bool> showPopUpExit(BuildContext context) async {
  print("Hai ini dari menu ${context.toString()}");
  
  return await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: const Text('Keluar Aplikasii?'),
      content: const Text('Apakah Yakin Ingin Keluar?'),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false), 
          child: Text('No')
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Close the dialog
            SystemNavigator.pop(); // Close the application
          }, 
          child: Text('Yes')
        )
      ],
    )
  )??false; //if showDialouge had returned null, then return false
}