import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool lockInBackground = true;

  String dis = "0";

  @override
  initState() {
    super.initState();
    getServiceDistance().then((result) {
      print("result: $result");
      setState(() {
        dis = result.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings UI')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Filter by Distrance',
            tiles: [
              SettingsTile(
                  title: "Service Distance",
                  subtitle: dis.toString() + " KM",
                  leading: Icon(Icons.language),
                  onTap: () async => showMaterialNumberPicker(
                        context: context,
                        title: "Pick your service distance",
                        maxNumber: 50,
                        minNumber: 1,
                        selectedNumber: await getServiceDistance(),
                        onChanged: (value) => updateService(
                            value), //setState(() =>  serviceDistance = value),
                      ) //_showDialog
                  ),
              SettingsTile(
                  title: 'Environment',
                  subtitle: 'Production',
                  leading: Icon(Icons.cloud_queue)),
            ],
          )
        ],
      ),
    );
  }

  Future getServiceDistance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("distance")) {
      return int.parse(prefs.get("distance"));
    } else {
      return 5;
    }
  }

  Future<void> updateServiceDistance(String distance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("distance", distance);
    setState(() {
      dis = distance;
    });
  }

  updateService(int value) {
    updateServiceDistance(value.toString());
  }

  getDistance() {
    return getServiceDistance();
  }
}
