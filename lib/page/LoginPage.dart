import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/page/MenuPage.dart';
import 'package:flutter_app/utils/Constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OnboardingScreen.dart';
import 'ResetPasswordPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      controller: _usernameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: _passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xfffd5c63),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: loginService,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final forgotPasswordButon = Material(
        child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPasswordPage()),
        );
      },
      child: new Container(
          alignment: Alignment.center,
          height: 20.0,
          color: Colors.white,
          child: new Text("Forgot Password?",
              style: new TextStyle(
                  fontSize: 17.0,
                  background: Paint()..color = Colors.white,
                  color: Colors.redAccent))),
    ));

    final createNewAccount = Material(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        },
        child: new Container(
            alignment: Alignment.center,
            height: 20.0,
            color: Colors.white,
            child: new Text("Create A New Account",
                style: new TextStyle(
                    fontSize: 17.0,
                    background: Paint()..color = Colors.white,
                    color: Colors.redAccent))),
      ),
    );

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Contactica"),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 125.0),
                        SizedBox(
                          height: 200.0,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 45.0),
                        emailField,
                        SizedBox(height: 25.0),
                        passwordField,
                        SizedBox(
                          height: 35.0,
                        ),
                        loginButon,
                        SizedBox(
                          height: 15.0,
                        ),
                        forgotPasswordButon,
                        SizedBox(
                          height: 25.0,
                        ),
                        createNewAccount
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  loginService() async {
    var userName = _usernameController.text;
    var passCode = _passwordController.text;

    if (userName.length > 0 && passCode.length > 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  height: 125.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                new Text("Performing Login"),
              ],
            ),
          );
        },
      );
      await _makePostRequest(userName, passCode);
    }
  }

  Future getCredential() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var UserToken = sharedPreferences.getString('access_token');
    return UserToken;
  }

  _makePostRequest(var uname, var pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Constants.API_URL + "/auth/oauth2/token?grant_type=password";

    var response = await post(url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "username": uname,
          "password": pass,
          "client_id": "documentation"
        },
        encoding: Encoding.getByName("utf-8"));

    Map userMap = jsonDecode(response.body);

    if (userMap.containsKey("access_token")) {
      //   print("This is before shared pref"+userMap["access_token"]);
      prefs.setString("access_token", userMap["access_token"]);
      prefs.setString("user_name", uname);

      url = Constants.API_URL + "/api/v1/users/me";
      Map<String, String> headers = {
        'authorization': 'Bearer ' + userMap["access_token"]
      };
      var response = await get(url, headers: headers);
      print(response.body.toString());
      Map user = jsonDecode(response.body);
      prefs.setString("user_id", user["id"].toString());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuPage()),
      );
    } else {
      Navigator.of(context).pop();

      Fluttertoast.showToast(
          msg: "Authentication Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}
