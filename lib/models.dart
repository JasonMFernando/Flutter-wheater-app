/*
{
    "status": "success",
    "data": {
        "city": "Negombo",
        "state": "Western",
        "country": "Sri Lanka",
        "location": {
            "type": "Point",
            "coordinates": [
                79.8358,
                7.2083
            ]
        },
        "current": {
            "weather": {
                "ts": "2022-03-31T06:00:00.000Z",
                "tp": 30,
                "pr": 1011,
                "hu": 66,
                "ws": 3.62,
                "wd": 219,
                "ic": "03d"
            },
            "pollution": {
                "ts": "2022-03-31T06:00:00.000Z",
                "aqius": 21,
                "mainus": "p2",
                "aqicn": 7,
                "maincn": "p2"
            }
        }
    }
}
*/

class weatherResponse{
  final TemperatureInfo tempInfo;
  final Weatherinfo weatherinfo;
  final Citylocation nearlocation;
  final Getwindspeed windspeed;
  final Getpressure pressure;
  final Gethumidity humidity;
  final Getairquality airquality;
  String get iconUrl{
    return 'https://www.airvisual.com/images/${weatherinfo.icon}.png';
  }


  //weatherResponse({  required this.tempInfo , required this.weatherinfo , required this.nearlocation , required this.windspeed , required this.pressure , required this.humidity , required this.airquality});
  weatherResponse({  required this.tempInfo , required this.weatherinfo , required this.nearlocation , required this.windspeed , required this.pressure , required this.humidity  , required this.airquality});
  factory weatherResponse.fromJson(Map<String  , dynamic> json){
    var dataJson = json['data']['current']['weather'];
    final dataInfo = TemperatureInfo.fromJson(dataJson);
    final weatherinfo = Weatherinfo.fromJson(dataJson);

    final ws = Getwindspeed.fromJson(dataJson);
    final pr = Getpressure.fromJson(dataJson);
    final hu = Gethumidity.fromJson(dataJson);
    dataJson = json['data']['current']['pollution'];
    final aqius = Getairquality.fromJson(dataJson);
    dataJson = json['data'];
    final nlocation = Citylocation.fromJson(dataJson);
    //return weatherResponse( tempInfo: dataInfo, weatherinfo: weatherinfo , nearlocation: nlocation , windspeed: ws , pressure: pr , humidity: hu , airquality: aqius);
    return weatherResponse( tempInfo: dataInfo, weatherinfo: weatherinfo , nearlocation: nlocation, windspeed: ws , pressure: pr , humidity: hu , airquality: aqius);
  }
}

class TemperatureInfo{
  final temperature;
  TemperatureInfo({required this.temperature});

  factory TemperatureInfo.fromJson(Map<String  , dynamic> json){
    final temperature = json['tp'];
    return TemperatureInfo(temperature: temperature);
  }
}

class Weatherinfo{
  final String icon;

  Weatherinfo({required this.icon});

  factory Weatherinfo.fromJson(Map<String , dynamic> json){
    var icon = json['ic'];
    if (icon[2] == 'n'){
      icon = icon[0] + icon[1] + 'd';
    }
    return Weatherinfo(icon: icon);
  }
}

class Citylocation{
  final String cit;

  Citylocation({required this.cit});
  factory Citylocation.fromJson(Map<String , dynamic> json){
    var cit = json['city'];
    return Citylocation(cit: cit);
  }
}


class Getwindspeed{
  final double wspeed;

  Getwindspeed({required this.wspeed});

  factory Getwindspeed.fromJson(Map<String , dynamic> json){
    var wspeed = 0.0;
    if (json['ws'] != 0) {
      wspeed = json['ws'];
    }
    return Getwindspeed(wspeed: wspeed);
  }
}

class Getpressure{
  final int prs;

  Getpressure({required this.prs});

  factory Getpressure.fromJson(Map<String , dynamic> json){
    var prs = json['pr'];
    return Getpressure(prs: prs);
  }
}


class Gethumidity{
  final int humid;

  Gethumidity({required this.humid});

  factory Gethumidity.fromJson(Map<String , dynamic> json){
    var humid = json['hu'];
    return Gethumidity(humid: humid);
  }
}
class Getairquality{
  final int airq;

  Getairquality({required this.airq});

  factory Getairquality.fromJson(Map<String , dynamic> json){
    var airq = json['aqius'];
    return Getairquality(airq: airq);
  }
}