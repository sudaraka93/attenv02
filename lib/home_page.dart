import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/widgets.dart';
import 'package:attenv02/login_page.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:attenv02/slide_digital_clock.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  var locationMessege= "";
  var Timein="Test Time in";
  var Timeout="Test Time Out";
  // bool timeinbtn = true;
  // bool timeoutbtn = false;
  String name = "";

  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    print("disposed");
    super.dispose();
  }

  Future<void> _showTimeinAproval() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time In Confirmation'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Text('Aprove The Time In '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aproved'),
              onPressed: () {
                timeInPush();
                sendtimein();
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTimeOutAproval() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time Out Confirmation'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Text('Aprove The Time In '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aproved'),
              onPressed: () {
                timeOutPush();
                sendtimeout();
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    print(lastPosition);
    print(now);

    setState(() {
      locationMessege="$position.latitude,$position.longitude,$now";
    });
  }

  void timeInPush()async{
    String now =await new DateFormat.yMd().add_Hm().format(new DateTime.now());
    setState(() {
      Timein="$now";
    });
  }

  sendtimein()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    double lat;
    double lon;
    var jsonResponse = null;
    var sid= sharedPreferences.getString("sid");

    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    lat = position.longitude;
    lon = position.latitude;

    var coord = "$lon,$lat";
    Map data = {
      'coord': '$coord',
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'sid':'$sid',
    };
    var response = await http.post("http://solajapan.xyz/api/attendance/checkin",body:jsonEncode(data),headers:headers
    );
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse['err']==0){
        var date = DateTime.fromMicrosecondsSinceEpoch(jsonResponse['data']['time_in'] * 1000);
        print(date);
      }
    }else{
      print("did not retireve the user info");
    }
  }

  sendtimeout()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    double lat;
    double lon;
    var jsonResponse = null;
    var sid= sharedPreferences.getString("sid");

    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    lat = position.longitude;
    lon = position.latitude;

    var coord = "$lon,$lat";
    Map data = {
      'coord': '$coord',
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'sid':'$sid',
    };
    var response = await http.post("http://solajapan.xyz/api/attendance/checkout",body:jsonEncode(data),headers:headers
    );
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse['err']==0){
        var date = DateTime.fromMicrosecondsSinceEpoch(jsonResponse['data']['time_out'] * 1000);
        print(date);
      }
    }else{
      print("did not retireve the user info");
    }
  }


  void timeOutPush()async{
    String now =await new DateFormat.yMd().add_Hm().format(new DateTime.now());
    setState(() {
      Timeout="$now";
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

  Container  timeText(){
    return Container(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$Timein",style:TextStyle(
                color: Colors.greenAccent,
                fontSize: 15.0)
            ),
            SizedBox(
              width:20,
            ),
            Text("$Timeout",style:TextStyle(
                color: Colors.redAccent,
                fontSize: 15.0))
          ],
        )
    );
  }

  Container  button(){
    return Container(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(onPressed:(){
              _showTimeinAproval();
            },
                color: Colors.orange,
                child: Text("Time in",
                  style: TextStyle(
                    color: Colors.white,fontSize:20
                  ),)),
            FlatButton(onPressed:(){
              _showTimeOutAproval();
            },
                color: Colors.orange,
                child: Text("Time out",
                  style: TextStyle(
                    color: Colors.white,fontSize:20
                  ),)),
          ],
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
                image: AssetImage("assets/bg.jpg"), fit: BoxFit.fill)),
          child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget>  [
                    SizedBox(height:60),
                    Container(
                      decoration:BoxDecoration(
                        color: Color.fromRGBO(255, 191, 68, 1),
                      ),
                        child: Padding(padding:EdgeInsets.only(top:20,bottom:20),child: clock())),
                    Container(
                        decoration:BoxDecoration(
                            color: Colors.white
                        ),
                        child: Padding(padding:EdgeInsets.only(top:20,bottom:20),child: timeText())),
                    SizedBox(height:60),
                    button()
                  ],
                ),
              ],
            ),
      ),
    );
  }
}