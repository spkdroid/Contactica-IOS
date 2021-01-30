import 'dart:convert';
import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:async/async.dart';
import '../model/ServiceObject.dart';
import '../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:input_sheet/components/IpsCard.dart';
import 'package:input_sheet/components/IpsLabel.dart';
import 'package:input_sheet/components/IpsPhoto.dart';
import 'package:input_sheet/components/IpsValue.dart';
import 'package:input_sheet/input_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ServiceInfoPage.dart';

class AddItemPageWidget extends StatefulWidget {
  AddItemPageWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddItemPageWidgetState createState() => _AddItemPageWidgetState(title);
}

class _AddItemPageWidgetState extends State<AddItemPageWidget> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String title;

  var _image_url;

  String _serviceName;
  String _serviceDescription;
  String _serviceContact;
  String _serviceType;

  _AddItemPageWidgetState(this.title); // Constructor

  final _serviceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: new ListView(
            children: <Widget>[
              Center(
                  child: _image != null
                      ? IpsPhoto(
                          file: _image,
                          onClick: () {
                            //Your sheet implementation
                          })
                      : IpsPhoto(file: null)),
              IpsCard(
                label: IpsLabel("Service Name"),
                value: IpsValue(_serviceName ?? "Touch to edit..."),
                onClick: () => InputSheet(
                  context,
                  label: "Service Name",
                  cancelText: "Cancel",
                  doneText: "Confirm",
                ).text(
                  placeholder: "Type here...",
                  value: _serviceName,
                  onDone: (dynamic value) => setState(() {
                    _serviceName = value;
                  }),
                ),
              ),
              IpsCard(
                label: IpsLabel("Service Description"),
                value: IpsValue(_serviceDescription ?? "Touch to edit..."),
                onClick: () => InputSheet(
                  context,
                  label: "Service Description",
                  cancelText: "Cancel",
                  doneText: "Confirm",
                ).longtext(
                  placeholder: "Type here...",
                  value: _serviceDescription,
                  onDone: (dynamic value) => setState(() {
                    _serviceDescription = value;
                  }),
                ),
              ),
              IpsCard(
                label: IpsLabel("Contact Information"),
                value: IpsValue(_serviceContact ?? "Touch to edit..."),
                onClick: () => InputSheet(
                  context,
                  label: "Contact Information Phone or Email",
                  cancelText: "Cancel",
                  doneText: "Confirm",
                ).text(
                  placeholder: "Type here...",
                  value: _serviceContact,
                  onDone: (dynamic value) => setState(() {
                    _serviceContact = value;
                  }),
                ),
              ),
              IpsCard(
                label: IpsLabel("Service Type"),
                value: IpsValue(_serviceType ?? "Touch to edit..."),
                onClick: () => InputSheet(
                  context,
                  label: "Contact Information Phone or Email",
                  cancelText: "Cancel",
                  doneText: "Confirm",
                ).options(
                  options: {
                    'food': 'Food',
                    'snow_removal': 'Snow Removal',
                    'plumber': 'Plumber'
                  },
                  value: _serviceType,
                  onDone: (dynamic value) => setState(() {
                    _serviceType = value;
                  }),
                ),
              ),

              /*
              new TextFormField(
                  controller: _serviceController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the name of the service',
                    labelText: 'Service Name',
                  )),
              new TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'description about the service',
                  labelText: 'Description',
                ),
              ),
              new TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  hintText: 'Enter your phone or email',
                  labelText: 'Contact',
                ),
              ), */
              SizedBox(
                height: 35.0,
              ),
              /*
              CustomRadioButton(
                buttonColor: Theme.of(context).canvasColor,
                buttonLables: ["Food", "Snow Removal", "Plumber"],
                buttonValues: ["food", "snow_removal", "plumber"],
                radioButtonValue: (value) => title = value,
                //print(value),
                selectedColor: Theme.of(context).accentColor,
              ), */
              ArgonButton(
                height: 50,
                width: 350,
                borderRadius: 5.0,
                color: Color(0xFF7866FE),
                child: Text(
                  "Submit",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                loader: Container(
                  padding: EdgeInsets.all(10),
                  child: SpinKitRotatingCircle(
                    color: Colors.redAccent,
                    // size: loaderWidth ,
                  ),
                ),
                onTap: (startLoading, stopLoading, btnState) {
                  startLoading();
                  requestMethod();
                  //  sleep(const Duration(seconds: 10));
                  stopLoading();
                },
              ),
              SizedBox(
                width: 50.0,
                height: 50.0,
              )
            ],
          )),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Click Image',
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future getCredential() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userToken = sharedPreferences.getString('access_token');
    return userToken;
  }

  Future<Response> requestMethod() async {
    //startLoading();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: [
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

    var streamResponse = await upload(_image, prefs.getString('access_token'));

    var serviceName = _serviceController.text;
    var serviceDesc = _descriptionController.text;
    var serviceContact = _contactController.text;
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

    print(_serviceName);
    print(_serviceDescription);
    print(_serviceType);
    print(_serviceContact);

    var body = json.encode({
      "title": _serviceName,
      "description": _serviceDescription,
      "category": _serviceType,
      "type": 0,
      "image_url": _image_url,
      "contact_infor": _serviceContact,
      "latitude": lat,
      "longitude": log
    });

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'authorization': 'Bearer ' + accesstoken
    };

    final response = await post(url, body: body, headers: headers);
    final responseJson = json.decode(response.body);

    if (response.statusCode == 200) {
      Navigator.of(context).pop();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ServiceInfoPage(
                serviceData: ServiceObject(
                    title: _serviceName,
                    description: _serviceDescription,
                    image_url: _image_url,
                    contact: _serviceContact,
                    type: "3"))),
      );

      /*
       showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Success"),
              content: new Text("The service has been added to Contactica"),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      var count = 0;
                      Navigator.popUntil(context, (route) {
                       return count++ == 2;
                      });
                    },
                    child: new Text("Ok"))
              ],
            );
          }); */
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
