import 'dart:async';
import 'dart:convert';

import '../animation/fab/speed_dial.dart';
import '../animation/fab/speed_dial_child.dart';
import '../model/ServiceObject.dart';
import '../page/ServiceInfoPage.dart';
import '../utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'SettingsPage.dart';

//import 'SettingsPage.dart';

class ServicePage extends StatefulWidget {
  ServicePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ServicePageState createState() => new _ServicePageState(title);
}

class _ServicePageState extends State<ServicePage> {
  String title;

  _ServicePageState(this.title); //constructor

  //curl --request GET \   --url 'http://18.222.239.66:5000/api/v1/item/user/1?category=snow_removal' \   --header 'authorization: Bearer DDEM3AX4xGvsxvT1s25lhGdw8SIpTT' \   --header 'content-type: multipart/form-data; boundary=---011000010111000001101001'
  String url = Constants.API_URL +
      '/api/v1/item/search'; //'https://randomuser.me/api/?results=15';
  List data;

  Future<ServiceObject> makeRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accesstoken = prefs.getString('access_token');
    String token = "Bearer " + accesstoken;
    var lat = prefs.get('lat');
    var log = prefs.get('long');

    var response = await http.get(
        Uri.encodeFull(url +
            "?latitude=" +
            lat.toString() +
            "&longitude=" +
            log.toString() +
            "&category=" +
            title +
            "&radius=5"),
        headers: {
          "Authorization": token,
          "Content-Type": "multipart/form-data"
        });

    var item = await getType();
    var code = (item == "Buy") ? "1" : "0";

    setState(() {
      var extract = json.decode(response.body);
      print(response.body);
      data = (extract as List)
          .map((data) => new ServiceObject.fromJson(data))
          .where((i) => (i.getCode() == code))
          .toList();
    });
  }

  Future getType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var UserToken = sharedPreferences.getString('doubleValue');
    return UserToken;
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: RefreshIndicator(
          onRefresh: _refresh,
          child: new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, i) {
                return new ListTile(
                  title: new Text(data[i].getTitle()),
                  //data[i]["name"]["first"]),
                  subtitle: new Text(data[i].getDescription()),
                  //data[i]["phone"]),
                  dense: false,
                  leading: new CircleAvatar(
                    backgroundImage: new NetworkImage(data[i].getImage()),
                    maxRadius: 20,
                  ),
                  trailing: new Text(data[i].getType()),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServiceInfoPage(
                                  serviceData: data[i],
                                )) //ServiceItemPage(serviceData: data[i])),
                        );
                  },
                );
              })),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => null,
        onClose: () => _refresh(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.filter_list),
              backgroundColor: Colors.red,
              label: 'Preference',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SettingsPage() //ServiceItemPage(serviceData: data[i])),
                            ))
                  }),
        ],
      ),
    );
  }

  Future<void> _refresh() {}
}
