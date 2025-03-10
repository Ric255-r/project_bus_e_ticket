import 'package:bus_hub/screen/function/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';

Future<Map<String, dynamic>> getMyData(jwt) async {
  Map<String, dynamic> responseData; 
  var dio = Dio();

  try {
    var response = await dio.get('${myIpAddr()}/user',
      options: Options(
        headers: {
          "Authorization" : "Bearer $jwt"
        }
      )
    );

    responseData = response.data;

    return responseData;
  } catch (e) {
    return {
      "Error Bagian User": e
    };
  }
}