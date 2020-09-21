import 'dart:convert';

import 'package:alertify/alertify.dart';
import 'package:contactica_app/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:popup_menu/popup_menu.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  PopupMenu menu;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();

  @override
  void initState() {
    super.initState();

    menu = PopupMenu(items: [
      // MenuItem(title: 'Copy', image: Image.asset('assets/copy.png')),
      // MenuItem(title: 'Home', image: Icon(Icons.home, color: Colors.white,)),
      MenuItem(
          title: 'Mail',
          image: Icon(
            Icons.mail,
            color: Colors.white,
          )),
      MenuItem(
          title: 'Power',
          image: Icon(
            Icons.power,
            color: Colors.white,
          )),
      MenuItem(
          title: 'Setting',
          image: Icon(
            Icons.settings,
            color: Colors.white,
          )),
      MenuItem(
          title: 'PopupMenu',
          image: Icon(
            Icons.menu,
            color: Colors.white,
          ))
    ], onClickMenu: onClickMenu, onDismiss: onDismiss, maxColumn: 1);
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    print('Menu is closed');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    final emailField = TextFormField(
      controller: _usernameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Contactica Username",
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
        onPressed: ResetPasswordService,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        child: Text("Password Reset",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    // curl --request POST \   --url http://18.222.239.66:5000/api/v1/users/me/reset-password \   --header 'authorization: Bearer 6eFD8YSpuDLz1Ycv4EwwG5CJtoHRcJ'

    return Scaffold(
        appBar: AppBar(
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
                    SizedBox(
                      height: 35.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  _makeResetPasswordRequest(var username) async {
    var url = Constants.API_URL + "/api/v1/users/me/reset-password";

    var response = await post(url,
        body: {
          "username": username,
          "client_id": "documentation",
          "secret_token": "afas\$df2267fsdfgnbbtj"
        },
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Alertify(
              content:
                  'The reset link has been sent to your registered email address',
              context: context,
              isDismissible: true,
              title: 'Success',
              alertType: AlertifyType.success,
              buttonText: 'OK',
              animationType: AnimationType.outToIn)
          .show();
    } else {
      Alertify(
              content: 'There has been a problem with your request',
              context: context,
              isDismissible: true,
              title: 'Failed',
              alertType: AlertifyType.error,
              buttonText: 'OK',
              animationType: AnimationType.outToIn)
          .show();
    }
  }

  void ResetPasswordService() {
    _makeResetPasswordRequest(_usernameController.text.toString());
  }
}
