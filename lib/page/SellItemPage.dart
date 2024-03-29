import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/model/DropDownFormField.dart';
import 'package:flutter_app/model/ServiceObject.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetsheet/sweetsheet.dart';
import '../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'ServiceInfoPage.dart';

class SellItemPage extends StatefulWidget {
  @override
  _SellItemScreenState createState() => new _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemPage> {
  final _servicenameController = TextEditingController();
  final _servicedescriptionController = TextEditingController();
  final _servicecontactController = TextEditingController();

  File _image;

  var _image_url;

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
                        controller: _servicenameController,
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
                        controller: _servicedescriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                          hintText: 'Service Description',
                          labelText: 'Enter the service description',
                          icon: new Icon(Icons.info),
                        ))),
                new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: new TextFormField(
                        controller: _servicecontactController,
                        keyboardType: TextInputType.text,
                        // Use email input type for emails.
                        decoration: new InputDecoration(
                          hintText: 'Service Contact',
                          labelText: 'Enter Contact number or Email Address',
                          icon: new Icon(Icons.contact_page),
                        ))),
                new Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: DropDownFormField(
                    titleText: 'Service Type',
                    hintText: 'Pick your service',
                    value: _serviceType,
                    onSaved: (value) {
                      setState(() {
                        _serviceType = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _serviceType = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Food",
                        "value": "food",
                      },
                      {
                        "display": "Snow Removal",
                        "value": "snow_removal",
                      },
                      {
                        "display": "Plumber",
                        "value": "plumber",
                      }
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
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
                          'Add Service',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: () => requestMethod(),
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

  Future getCredential() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('access_token');
    return userToken;
  }

  Future<Response> requestMethod() async {
    // All the variables for adding the service information
    var _serviceName = _servicenameController.text;
    var _serviceDesc = _servicedescriptionController.text;
    var _serviceContact = _servicecontactController.text;
    // _image

    print(_serviceName);
    print(_serviceDesc);
    print(_serviceContact);
    print(_serviceType);
    //  print(_image.absolute.path);

    if (_serviceName.isNotEmpty &&
        _serviceDesc.isNotEmpty &&
        _serviceContact.isNotEmpty &&
        _serviceType != null &&
        _image != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 125.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                new CircularProgressIndicator(),
                new Text("Please wait"),
              ],
            ),
          );
        },
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position.latitude);
      print(position.longitude);
      prefs.setString("lat", position.latitude.toString());
      prefs.setString("long", position.longitude.toString());

      var streamResponse =
          await upload(_image, prefs.getString('access_token'));

      //var _serviceType = _serviceType;
      var accesstoken = prefs.getString('access_token');
      var userId = prefs.getString('user_id');
      final respStr = await streamResponse.stream.bytesToString();

      var usermap = jsonDecode(respStr);

      var url = Constants.API_URL + "/api/v1/item/user/" + userId.toString();

      setState(() {
        _image_url = usermap["url"];
      });

      var lat = prefs.get('lat').toString();
      var log = prefs.get('long').toString();

      //  if (title == "Sell Service") title = "food";

      var body = json.encode({
        "title": _serviceName,
        "description": _serviceDesc,
        "category": _serviceType,
        "type": 0,
        "image_url": _image_url,
        "contact_infor": _serviceContact,
        "latitude": lat,
        "longitude": log
      });

      print(body);

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'authorization': 'Bearer ' + accesstoken
      };

      final response = await post(url, body: body, headers: headers);
      final responseJson = json.decode(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        Navigator.of(context).pop();

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ServiceInfoPage(
                  serviceData: ServiceObject(
                      title: _serviceName,
                      description: _serviceDesc,
                      image_url: _image_url,
                      contact: _serviceContact,
                      type: "3"))),
        );
      } else {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Alert"),
                content: new Text("There has been a problem with the request"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text("Ok"))
                ],
              );
            });
      }
      return response;
    } else {
      new SweetSheet().show(
          context: context,
          description: Text(
            'Form Issue: Please correct your form information to add your service',
            style: TextStyle(color: Color(0xff2D3748)),
          ),
          color: CustomSheetColor(
            main: Colors.white,
            accent: Color(0xfffd5c63), //Color(0xff5A67D8),
            icon: Color(0xfffd5c63),
          ),
          icon: Icons.local_shipping,
          positive: SweetSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            title: 'OK',
          ));
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
