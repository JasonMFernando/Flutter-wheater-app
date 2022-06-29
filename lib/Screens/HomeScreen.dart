import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jtest/Screens/LoginScreen.dart';
import 'package:jtest/Seachpage.dart';
import 'package:jtest/model/user_model.dart';
import 'package:jtest/view/additional_information.dart';
import 'Searchloc.dart';

import '../Nloc.dart';
import '../dataservice.dart';
 
class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  

  final _cityTextController = TextEditingController();
  final _countryTextController = TextEditingController();
  final _stateTextController = TextEditingController();
  final _dataService = dataservice();
  final _neardata = Nloc();
  int temp = 0;
  var loc = "Hello world";
  double wspeed = 0;
  int humid = 0;
  int presure = 0;
  int airq = 0;
  String imgurl = 'https://www.seekpng.com/png/full/133-1330400_weather-icon-png-image-transparent-background-weather-icon.png';


  User? user = FirebaseAuth.instance.currentUser;
  Usermodel loggedInUser = Usermodel();

  /*@override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .get()
    .then((value){
      this.loggedInUser = Usermodel.fromMap(value.data());
    });
  }*/

  @override
  void initState(){
    super.initState();
    getloca();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text("Welcome to Weather App"),
        centerTitle: true,
      ),
      body: Center(
        child : Stack(
        children: [
          Image.asset('lib/images/background.jpg',
          //Image.network('https://forum.xda-developers.com/proxy.php?image=http%3A%2F%2Fuploads.tapatalk-cdn.com%2F20160227%2Fccd9e38d6372a8546c4a568e7e569891.jpg&hash=a1fc5585a3abe3a5ef46f2a6c3a98b38',
        fit: BoxFit.cover,
          width: 500 , height:750,
        ),
          SingleChildScrollView(
          //scrollDirection: Axis.horizontal,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //if (_response != null)
            Column(
              children: [
                Image.network(imgurl),
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
            /*Center(
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
            ),*/
            ElevatedButton(child: Text('Search weather'),
              onPressed:() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> searchLocation()));
              },
            )
          ],
        ),
    )
  ]
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
    )
    );
  }

  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  void getloca() async {
    final response = await _neardata.Getnearweather();
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
