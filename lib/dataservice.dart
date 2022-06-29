import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class dataservice{
  Future<weatherResponse> getWeather(String countryvalue , String statevalue ,String city) async {

    var request = http.Request('GET', Uri.parse('http://api.airvisual.com/v2/city?city=' + city+'&state=' + statevalue + '&country='+ countryvalue +'&key=e6e06351-93b5-425b-9504-ae8da18640d5'));
    http.StreamedResponse response = await request.send();
    var thing = "";
    if (response.statusCode == 200) {
      thing = await response.stream.bytesToString();
      print(thing);
      //print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
    final json = jsonDecode(thing);
    //return weatherResponse.fromJson(json);
    return weatherResponse.fromJson(json);
  }
}