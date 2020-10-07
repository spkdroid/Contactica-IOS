import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import '../model/MenuPageObj.dart';
import '../model/Promotion.dart';
import '../model/Service.dart';
//import 'package:contactica_app/page/KeywordServicePage.dart';
import '../page/LoginPage.dart';
//import '../page/PromoPage.dart';
//import 'package:contactica_app/page/ServiceMapPage.dart';
import '../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'AddItemPage.dart';
import 'ServicePage.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var userName;
  var profilePicture;
  List<Service> serviceTypes;
  List<Promotion> promotionTypes;
  String _image_url;
  final _keywordController = TextEditingController();
  List data;
  Future<MenuPageObj> menu;

  @override
  void initState() {
    menu = _getUserInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int getColorHexFromStr(String colorStr) {
      colorStr = "FF" + colorStr;
      colorStr = colorStr.replaceAll("#", "");
      int val = 0;
      int len = colorStr.length;
      for (int i = 0; i < len; i++) {
        int hexDigit = colorStr.codeUnitAt(i);
        if (hexDigit >= 48 && hexDigit <= 57) {
          val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
        } else if (hexDigit >= 65 && hexDigit <= 70) {
          // A..F
          val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
        } else if (hexDigit >= 97 && hexDigit <= 102) {
          // a..f
          val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
        } else {
          throw new FormatException(
              "An error occurred when converting a color");
        }
      }
      return val;
    }

    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Welcome'),
              backgroundColor: Colors.redAccent,
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Colors.redAccent,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 15.0),
                            Row(
                              children: <Widget>[
                                SizedBox(width: 15.0),
                                /*
                      GestureDetector(
                          onTap: changeProfilePicture,
                          child:
                          Container(
                            alignment: Alignment.topLeft,
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2.0),
                                image: DecorationImage(
                                    image: NetworkImage(profilePicture))),

                          )),*/
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    icon: Icon(Icons.lock),
                                    onPressed: _performLogout,
                                    color: Colors.white,
                                    iconSize: 30.0,
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        120.0),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: Icon(Icons.plus_one),
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           AddItemPageWidget(
                                      //               title: "Sell Service")),
                                      // );
                                    },
                                    color: Colors.white,
                                    iconSize: 30.0,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                            SizedBox(height: 50.0),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: FutureBuilder(
                                future: menu,
                                builder: (context, data) {
                                  if (!data.hasData) {
                                    return Text("Hello",
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold));
                                  } else {
                                    MenuPageObj m = data.data;
                                    return Text(
                                      'Hello ' + m.username,
                                      style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                'What service do you like today?',
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 25.0),
                            Row(children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: InkWell(
                                      onTap: _launchMaps,
                                      child: Image.asset(
                                        "assets/pins.png",
                                        fit: BoxFit.contain,
                                        height: 100,
                                        width: 100,
                                      )))
                            ]),
                            SizedBox(height: 25.0),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(5.0),
                                child: TextFormField(
                                    controller: _keywordController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: InkWell(
                                            onTap: _PerformSearch,
                                            child: Icon(Icons.search,
                                                color: Color(getColorHexFromStr(
                                                    '#FEDF62')),
                                                size: 30.0)),
                                        contentPadding: EdgeInsets.only(
                                            left: 15.0, top: 15.0),
                                        hintText: 'Search',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Quicksand'))),
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Buy',
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder(
                      future: menu,
                      builder: (context, data) {
                        if (!data.hasData) {
                          return Text("Hello");
                        } else {
                          MenuPageObj m = data.data;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                    child: ListTile(
                                  leading: Image.network(
                                      m.service[0].serviceImage,
                                      width: 75,
                                      height: 50,
                                      fit: BoxFit.fill),
                                  title: Text(m.service[0].serviceName),
                                  onTap: () => serviceTriggered(
                                      m.service[0].serviceName, context),
                                )),
                                Card(
                                    child: ListTile(
                                        leading: Image.network(
                                            m.service[1].serviceImage,
                                            width: 75,
                                            height: 50,
                                            fit: BoxFit.fill),
                                        title: Text(m.service[1].serviceName),
                                        onTap: () => serviceTriggered(
                                            m.service[1].serviceName,
                                            context))),
                                Card(
                                    child: ListTile(
                                        leading: Image.network(
                                            m.service[2].serviceImage,
                                            width: 75,
                                            height: 50,
                                            fit: BoxFit.fill),
                                        title: Text(m.service[2].serviceName),
                                        onTap: () => serviceTriggered(
                                            m.service[2].serviceName, context)))
                              ]);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Promo',
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder(
                        future: menu,
                        builder: (context, data) {
                          if (!data.hasData) {
                            return Text("Hello");
                          } else {
                            MenuPageObj m = data.data;
                            return Container(
                                margin: EdgeInsets.symmetric(vertical: 20.0),
                                height: 200.0,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    promoCard(m.promo[0]),
                                    promoCard(m.promo[1]),
                                    promoCard(m.promo[2])
                                  ],
                                ));
                          }
                        })
                  ],
                ),
              ),
            )));
  }

  final userNameText = new Text("Welcome User",
      style: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          fontFamily: 'Open Sans',
          fontSize: 40));

  static Future<String> getSortingOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_key") ?? 'name';
  }

  setText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(await prefs.get("access_key"));

    Fluttertoast.showToast(
        msg: await prefs.get("access_key") + "Hello",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  serviceTriggered(String s, BuildContext context) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lat", position.latitude.toString());
    prefs.setString("long", position.longitude.toString());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServicePage(title: s)),
    );
  }

  Future getCredential() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var UserToken = sharedPreferences.getString('access_token');
    return UserToken;
  }

  Future getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userName = sharedPreferences.getString('user_name');
    return userName;
  }

  Future getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString('user_id');
    return userId;
  }

  Future<MenuPageObj> _getUserInformation() async {
    var userId = await getUserId();
    var url = Constants.API_URL +
        "/api/v1/item/user/" +
        userId.toString() +
        "/home_page";
    SharedPreferences p = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      'authorization': 'Bearer ' + p.get("access_token")
    };

    var response = await get(url, headers: headers);

    print(response.toString());

    Map userMap = jsonDecode(response.body);
    print(userMap);
    String profile = "";
    String username = "";
    List<Service> service = new List();
    List<Promotion> promotion = new List();
    if (userMap.containsKey("profile")) {
      profile = userMap["profile"]["profile_picture"];
      username = userMap["profile"]["username"];
      var s = userMap["service_type"];
      for (int i = 0; i < 3; i++) {
        if (s[i]["name"] != null && s[i]["image_url"] != null) {
          Service sample = new Service(s[i]["name"], s[i]["image_url"]);
          service.add(sample);
        }
      }

      var promo = userMap["promo"];
      print(promo);

      for (int i = 0; i < 3; i++) {
        Promotion p = new Promotion(promo[i]["title"], promo[i]["image_url"],
            promo[i]["description"], promo[i]["contact_infor"]);
        promotion.add(p);
      }
    } else {
      profile = "";
      username = "";
    }
    return new MenuPageObj(username, profile, service, promotion);
  }

  Widget promoCard(Promotion image) {
    return AspectRatio(
        aspectRatio: 2.62 / 3,
        child: InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomePage(image)),
            // );
          },
          child: (image.image_url != null)
              ? Container(
                  margin: EdgeInsets.only(right: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(image.image_url)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            stops: [
                              0.1,
                              0.9
                            ],
                            colors: [
                              Colors.black.withOpacity(.8),
                              Colors.black.withOpacity(.1)
                            ])),
                  ),
                )
              : Container(),
        ));
  }

  File _image;

  Future changeProfilePicture() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });

    requestMethod();
  }

  Future<Response> requestMethod() async {
    //startLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var streamResponse = await upload(_image, prefs.getString('access_token'));
    var accesstoken = prefs.getString('access_token');
    final respStr = await streamResponse.stream.bytesToString();
    var usermap = jsonDecode(respStr);
    String username = await getUserName();
    var url = Constants.API_URL + "/api/v1/users/2";

    setState(() {
      _image_url = usermap["url"].toString();
    });

    var body = json.encode([
      {
        "op": "replace",
        "path": "/avatar",
        "value":
            "https://c4.wallpaperflare.com/wallpaper/804/413/253/grand-theft-auto-v-wallpaper-preview.jpg"
        //_image_url
      }
    ]);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'authorization': 'Bearer ' + accesstoken
    };

    final response = await post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Success"),
              content: new Text("Profile picture updated"),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      var count = 0;
                      Navigator.pop(context);
                    },
                    child: new Text("Ok"))
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Alert"),
              content: new Text("Profile Picture update failed"),
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

  Future<StreamedResponse> upload(File imageFile, var accessToken) async {
    var stream = new ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uploadURL = Constants.API_URL + "/api/v1/item/upload_images";
    var uri = Uri.parse(uploadURL);
    var request = new MultipartRequest("POST", uri);
    var multipartFile = new MultipartFile('image_file', stream, length,
        filename: imageFile.path);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'authorization': 'Bearer ' + accessToken
    };
    request.headers.addAll(headers);
    request.files.add(multipartFile);
    var response = await request.send();
    return response;
  }

  void _PerformSearch() async {
    print("Key word based search triggered");
    // _makeKeyWordBasedSearch();

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lat", position.latitude.toString());
    prefs.setString("long", position.longitude.toString());

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
    //           KeywordServicePage(title: _keywordController.text)),
    // );
  }

  void _launchMaps() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ServiceMapPage()),
    // );
  }

  void _launchMyItems() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ServiceMapPage()),
    // );
  }

  _performLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', null);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Logout"),
            content: new Text(
                "Are you sure you want to logout from Contactica Application"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: new Text("Ok")),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("Cancel")),
            ],
          );
        });
  }
}
