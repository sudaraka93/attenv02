import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attenv02/home_page.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences sharedPreferences;
  bool rememberMe = false;
  Size deviceSize;
  var error =" ";
// ********************INPUT COLLECTION CONTROLER*********************
  final TextEditingController userController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }
// ********************CHECK LOGIN STATUS*************************
  checkLoginStatus() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("sid") == null) {
      print("Not Logged in");
    }else{
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
      print(sharedPreferences.getString("sid"));
      print("Logged in");
    }
  }

// ********************REMBER ME CONDITION*************
  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;

    if (rememberMe) {
      // TODO: Here goes your functionality that remembers the user.
    } else {
      // TODO: Forget the user
    }
  });




  // **************** SIGN IN FUNCTION ***************
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
        getUserInfo();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
      }
      // else{
      //   var failed="Username Password Incorrect";
      //   setState(() {
      //     error="$failed";
      //   });
      // }
    }
    else {
      print(response.body);
      return json.decode(response.body);
    }
  }


// ****************************GET USER INFO***********************************
  getUserInfo()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    var sid= sharedPreferences.getString("sid");

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'sid':'$sid',
    };

    var response = await http.get("http://solajapan.xyz/api/user/logged-info",
      headers:headers,
    );
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if(jsonResponse['err']==0){
        sharedPreferences.setString("useFullName", jsonResponse['data']['fullname']);
        sharedPreferences.setInt("useid", jsonResponse['data']['id']);
        sharedPreferences.setInt("useRoleid", jsonResponse['data']['role_id']);

        print(sharedPreferences.getString("useFullName"));
        print(sharedPreferences.getInt("useid"));
        print(sharedPreferences.getInt("useRoleid"));

      }
    }else{
      print("did not retireve the user info");
    }
  }


  // ***********MAIN UI BUILDER*******************
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

  // ********************UI ELEMENT LOGO***********************:
    Container logoCircle(){
      deviceSize = MediaQuery.of(context).size;
        return Container(
          width: deviceSize.width*0.6,height:deviceSize.height*0.6,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 7), // changes position of shadow
                    ),
                  ],
                color: Color.fromRGBO(238, 238, 238, 1),
                shape: BoxShape.circle,

                ),
            child: Opacity(
              opacity:0.7,
                  child:Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/logo.png"),
                        )
                    ),
                  ),
        ),
              );
    }

    // *****************UI COMPONET TEXTFILED BOXES*****************
      Container logofield(){
        return Container(
          height: deviceSize.height*0.40,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
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
                    color: Color.fromRGBO(255, 191, 68, 1),
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
                    color:Color.fromRGBO(255, 191, 68, 1),
                    // color:Color.fromRGBO(228, 146, 25, 1),
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