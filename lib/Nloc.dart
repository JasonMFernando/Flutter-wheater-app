import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
class Nloc{
  Future<weatherResponse> Getnearweather() async{
    var request = http.Request('GET', Uri.parse('http://api.airvisual.com/v2/nearest_city?key=e6e06351-93b5-425b-9504-ae8da18640d5'));
    http.StreamedResponse response = await request.send();
    var jsonvalue = "";

    if (response.statusCode == 200) {
      jsonvalue =(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
    final json = jsonDecode(jsonvalue);
    return weatherResponse.fromJson(json);
  }
}