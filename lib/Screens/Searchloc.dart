import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jtest/Seachpage.dart';

import '../dataservice.dart';
import '../view/additional_information.dart';

class searchLocation extends StatefulWidget {
  const searchLocation({Key? key}) : super(key: key);

  @override
  _searchLocationState createState() => _searchLocationState();
}

class _searchLocationState extends State<searchLocation> {

  final _cityTextController = TextEditingController();
  final _countryTextController = TextEditingController();
  final _stateTextController = TextEditingController();
  final _dataService = dataservice();

  int temp = 0;
  var loc = "Hello world";
  double wspeed = 0;
  int humid = 0;
  int presure = 0;
  int airq = 0;
  String imgurl = 'https://www.seekpng.com/png/full/133-1330400_weather-icon-png-image-transparent-background-weather-icon.png';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text("Welcome to Weather App"),
        centerTitle: true,
      ),
      body: Center(
          child: SingleChildScrollView(
            //scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //if (_response != null)
                Column(
                  children: [
                    SizedBox( height: 180, width: 180,
                      child :Image.network(imgurl),
                    ),
                    Text('${temp}',
                      style: TextStyle(fontSize: 40),
                    ),
                    Text('${loc}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                        height : 20.0
                    ),
                    Text(
                      "Addtional Information",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 20.0,
                    ),

                    //additional information starts from here
                    addtionalInformation(wspeed, presure, humid, airq)
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: 150,
                          child: TextField(
                              controller: _cityTextController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(labelText: 'City'),
                              textAlign: TextAlign.center
                          ),
                        ),
                      ),
                      Padding(
                        padding:   EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: 150,
                          child: TextField(
                              controller: _stateTextController,
                              decoration: InputDecoration(labelText: 'state'),
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.center
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: 150,
                          child: TextField(
                              controller: _countryTextController,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(labelText: 'Country'),
                              textAlign: TextAlign.center
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: _search, child: Text('Search')
            )
              ],
            ),
          )
      ),
      /*body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Text(
                "Welcome back",
                style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text("${loggedInUser.fname} ${loggedInUser.lname}",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              )),
              Text("${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),

              SizedBox(
                height: 15,
              ),
              ActionChip(label: Text("Logout"), onPressed: (){
                logout(context);
              }),
            ],
          ),
        ),
      ),*/
    );
  }
  void _search() async {
    final response = await _dataService.getWeather(_countryTextController.text , _stateTextController.text ,_cityTextController.text);
    //setState(() => _response = response );
    print(response.tempInfo.temperature);
    //temp = response.tempInfo.temperature;
    setState(() => temp = response.tempInfo.temperature);
    setState(() => imgurl = response.iconUrl);
    setState(() => loc = response.nearlocation.cit);
    setState(() => wspeed = response.windspeed.wspeed);
    setState(() => presure = response.pressure.prs);
    setState(() => humid = response.humidity.humid);
    setState(() => airq = response.airquality.airq);
  }
}
