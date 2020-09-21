import 'package:contactica_app/utils/Constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => new _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Registration'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            child: new ListView(
              children: <Widget>[
                new Container(
                    padding: new EdgeInsets.all(20.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 200.0,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    )),
                new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                          hintText: 'User Name',
                          labelText: 'Enter your user name',
                          icon: new Icon(Icons.person),
                        ))),
                new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new TextFormField(
                        focusNode: _emailFocusNode,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        // Use email input type for emails.
                        validator: (_emailController) =>
                            EmailValidator.validate(_emailController)
                                ? null
                                : "Invalid email address",
                        decoration: new InputDecoration(
                            hintText: 'you@example.com',
                            labelText: 'E-mail Address',
                            icon: new Icon(Icons.email)))),
                new Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: new TextFormField(
                      controller: _passwordController,
                      obscureText: true, // Use secure text for passwords.
                      decoration: new InputDecoration(
                          hintText: 'Password',
                          labelText: 'Enter your password',
                          icon: new Icon(Icons.lock))),
                ),
                new Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: new TextFormField(
                      obscureText: true, // Use secure text for passwords.
                      controller: _confirmPasswordController,
                      decoration: new InputDecoration(
                          hintText: 'Confirm Password',
                          labelText: 'Enter your confirm password',
                          icon: new Icon(Icons.lock))),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 50.0,
                      width: 210.0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 40.0),
                      child: new RaisedButton(
                        child: new Text(
                          'Register',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () => _performLogin(),
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  _performLogin() async {
    if (_usernameController.text.length > 0 &&
        _passwordController.text.length > 0 &&
        _emailController.text.length > 0) {
      if (_passwordController.text == _confirmPasswordController.text) {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_emailController.text)) {
          await _makePostRequest(_usernameController.text,
              _passwordController.text, _emailController.text);
        } else {
          Fluttertoast.showToast(msg: "Invalid Email address");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Password mismatch",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Field error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  _makePostRequest(String uname, String pass, String email) async {
    var url = Constants.API_URL + "/api/v1/users/";

// Phone number need to added

    var response = await post(url, body: {
      "recaptcha_key": "secret_key",
      "username": uname.toString(),
      "password": pass.toString(),
      "email": email,
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Registration Completed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);

      // pop up twice to jump to the login page
      var count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    } else {
      Fluttertoast.showToast(
          msg: "Registration Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}
