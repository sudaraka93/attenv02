import 'dart:convert';
import 'package:flutter/widgets.dart';

import 'package:attenv02/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  bool timeinbtn = true;
  bool timeoutbtn = false;
  String name = "";

  void initState() {
    super.initState();
  }

  Future <String> loadPref()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return Future.delayed(Duration(seconds: 1),()async{
      return await sharedPreferences.getString("useFullName");
    });

  }


  logout()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.commit();
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
  }


  var locationMessege= "";

  void getCurrentLocation()async{
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition=await Geolocator.getLastKnownPosition();
    timeinbtn=!timeinbtn;
    timeoutbtn=!timeoutbtn;
    print(lastPosition);

    setState(() {
      locationMessege="$position.latitude,$position.longitude";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(255, 191, 68, 1),
        title:FutureBuilder(
          future: loadPref(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Text("${snapshot.data}");
            }else{
              return Text("Loading");
            }
          },
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              logout();
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover)),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Column(
                  children:<Widget>  [
                    Container(
                        child:DigitalClock(
                          digitAnimationStyle: Curves.elasticOut,
                          is24HourTimeFormat: false,
                          areaDecoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                          hourMinuteDigitTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                          ),
                        )
                    ),
                    Text("Position:$locationMessege",style:TextStyle(
                        color: Colors.black,
                        fontSize: 2.0,
                        fontWeight: FontWeight.bold)),
                    Visibility(
                      visible:timeinbtn,
                      child: FlatButton(onPressed:(){
                        getCurrentLocation();
                      },
                          color: Colors.orange,
                          child: Text("Time in",
                            style: TextStyle(
                              color: Colors.white,
                            ),)),
                    ),
                    Visibility(
                      visible: timeoutbtn,
                      child: FlatButton(onPressed:(){
                        getCurrentLocation();
                      },
                          color: Colors.orange,
                          child: Text("Time out",
                            style: TextStyle(
                              color: Colors.white,
                            ),)),
                    )
                  ],
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}