import 'package:flutter/material.dart';

class LocationAccessScreen extends StatefulWidget {
  LocationAccessScreen({Key key}) : super(key: key);

  @override
  _LocationAccessScreen createState() => _LocationAccessScreen();
}

class _LocationAccessScreen extends State<LocationAccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Error"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/9_Location Error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: Container(
                decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 13),
                  blurRadius: 25,
                  color: Color(0xFFD27E4A).withOpacity(0.17),
                ),
              ],
            )
                /* child: FlatButton(
                color: Color(0xfffd5c63),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {},
                child: Text(
                  "Zip code".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ), */
                ),
          ),
        ],
      ),
    );
  }
}
