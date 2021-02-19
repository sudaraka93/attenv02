import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences sharedPreferences;
  String name = " ";
  bool rememberMe = false;
  Size deviceSize;

  final TextEditingController userController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // checkLoginStatus();
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;

    if (rememberMe) {
      // TODO: Here goes your functionality that remembers the user.
    } else {
      // TODO: Forget the user
    }
  });

  signIn(String user, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'username': user,
      'password': pass,
      "remember":1
    };

    var jsonResponse = null;

    var response = await http.post("http://solajapan.xyz/api/user/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      if(jsonResponse['err'] == 0) {
        setState(() {
        });
        print (jsonResponse['data']['sid']);
        sharedPreferences.setString("sid", jsonResponse['data']['sid']);
        // getUserInfo();
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {

      });
      print(response.body);
      return json.decode(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          resizeToAvoidBottomInset: false,
            body:Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/bg.jpg"),
                          fit: BoxFit.cover)),
                child: SingleChildScrollView(
                  child:Column(
                    children: [
                      Align(
                        alignment:Alignment.center,
                        child:logoCircle(),
                      ),
                      Align(
                        alignment:Alignment.bottomCenter,
                        child:logofield(),
                      ),
                    ],
                  ),
                ),
                    ),
                  ),
    );
  }

  // Widget background() {
  //   return Container(
  //       height: double.infinity,
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage('assets/bg.jpg'),
  //             fit: BoxFit.cover,
  //           )));
  // }

    Container logoCircle(){
      deviceSize = MediaQuery.of(context).size;
        return Container(
          width: deviceSize.width*0.6,height:deviceSize.height*0.6,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 10,
                      blurRadius: 5,
                      offset: Offset(0, 7), // changes position of shadow
                    ),
                  ],
                color: Color.fromRGBO(238, 238, 238, 1),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                )
                )
              );
    }
      Container logofield(){
        return Container(
          height: deviceSize.height*0.40,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 10,
                blurRadius: 5,
                offset: Offset(0, 7), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color:Color.fromRGBO(238, 238, 238, 1),
          ),
          child:Column(
            children: [
              SizedBox(height:10,),
              Padding(padding: EdgeInsets.only(left: 10, right:10, top:0),
                child:Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.orange,
                    ),
                  child:Padding(padding:EdgeInsets.only(left:10,right:10),
                    child:TextFormField (
                      controller: userController,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle_rounded, color: Colors.white),
                        hintText: "Username",
                        border:InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height:15,),
              Padding(padding: EdgeInsets.only(left: 10, right:10, top:0),
                child:Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.orange,
                  ),
                  child:Padding(padding:EdgeInsets.only(left:10,right:10),
                    child: TextField(controller: passwordController,
                      cursorColor: Colors.white,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Colors.white),
                        hintText: "Password",
                        border:InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white30),
                      ),
                    ),
                  ),
                ),
              ),
            Padding(padding: EdgeInsets.only(left: 10, right:10, top:0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      value: rememberMe,
                      onChanged: _onRememberMeChanged
                  ),
                  Text("Remember Me"),
                ],
              )),
            Padding(padding: EdgeInsets.only(left: 10, right:10, top:0),
                child:Container(

                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  margin: EdgeInsets.only(top: 15.0),
                  child: RaisedButton(
                    onPressed: userController.text == "" || passwordController.text == "" ? null : () {
                      signIn(userController.text, passwordController.text);
                    },
                    elevation: 0.0,
                    color: Colors.yellow,
                    child: Text("Sign In", style: TextStyle(color: Colors.white)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  ),
                )
              )
            ],
          ),
        );
      }


}