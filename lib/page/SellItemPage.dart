import 'dart:io';

import '../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';

class SellItemPage extends StatefulWidget {
  @override
  _SellItemScreenState createState() => new _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();

  File _image;

  final picker = ImagePicker();

  String _serviceName;
  String _serviceDescription;
  String _serviceContact;
  String _serviceType;

  Future getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sell Item'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            child: new ListView(
              children: <Widget>[
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _image == null
                                    ? NetworkImage(
                                        "http://www.noemiaalugueis.com.br/assets/images/no-image.png",
                                      )
                                    : FileImage(
                                        _image,
                                      ))),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.green,
                            ),
                            child: InkWell(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onTap: getImage),
                          )),
                    ],
                  ),
                ),
                /* new Container(
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
                    )), */
                new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                          hintText: 'Service Name',
                          labelText: 'Enter the service name',
                          icon: new Icon(Icons.person),
                        ))),
                new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                          hintText: 'Service Description',
                          labelText: 'Enter the service description',
                          icon: new Icon(Icons.person),
                        ))),
                new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                          hintText: 'Service Contact',
                          labelText: 'Enter Contact number or Email Address',
                          icon: new Icon(Icons.person),
                        ))),
                new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                          hintText: 'Service Type',
                          labelText:
                              'Please pick the service type from the dropdown',
                          icon: new Icon(Icons.person),
                        ))),

                /*  new Container(
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
                ), */
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

  Future<StreamedResponse> upload(File imageFile, var accesstoken) async {
    var stream = new ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uploadURL = Constants.API_URL + "/api/v1/item/upload_images";
    var uri = Uri.parse(uploadURL);
    var request = new MultipartRequest("POST", uri);
    var multipartFile = new MultipartFile('image_file', stream, length,
        filename: imageFile.path);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'authorization': 'Bearer ' + accesstoken
    };
    request.headers.addAll(headers);
    request.files.add(multipartFile);
    var response = await request.send();
    return response;
  }
}
