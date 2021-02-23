import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:attenv02/login_page.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  var locationMessege= "";
  bool timeinbtn = true;
  bool timeoutbtn = false;
  String name = "";

  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    print("disposed");
    super.dispose();
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
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
  }

  void getCurrentLocation()async{
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition=await Geolocator.getLastKnownPosition();
    String now =await new DateFormat.yMd().add_Hm().format(new DateTime.now());
    timeinbtn=!timeinbtn;
    timeoutbtn=!timeoutbtn;
    print(lastPosition);
    print(now);

    setState(() {
      locationMessege="$position.latitude,$position.longitude,$now";
    });
  }

  Container  clock(){
    return Container(
        child: DigitalClock(
          digitAnimationStyle: Curves.elasticOut,
          is24HourTimeFormat: false,
          areaDecoration: BoxDecoration(
            color: Colors.transparent,
          ),
          hourMinuteDigitTextStyle: TextStyle(
            color: Colors.blueGrey,
            fontSize: 50,
          ),
          amPmDigitTextStyle: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold),
        )
    );
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
                        child: clock(),
                    ),

                    Text("Position:$locationMessege",style:TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
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