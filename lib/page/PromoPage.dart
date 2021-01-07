// Flutter code sample for

// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold]. The [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.
//
// ![A screenshot of the Scaffold widget with a bottom navigation bar and docked floating action button](https://flutter.github.io/assets-for-api-docs/assets/material/scaffold_bottom_app_bar.png)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../animation/FadeAnimation.dart';
import '../model/Promotion.dart';
import '../model/ServiceObject.dart';
import '../page/ServiceInfoPage.dart';

class PromoPageWidget extends StatefulWidget {
  PromoPageWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PromoPageWidgetState createState() => _PromoPageWidgetState(title);
}

class _PromoPageWidgetState extends State<PromoPageWidget> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String title;

  _PromoPageWidgetState(this.title); // Constructor

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Promotional Page"),
        ),
        body: new ListView(
          children: <Widget>[HomePage(null)],
        ));
  }
}

class HomePage extends StatefulWidget {
  HomePage(this.title);

  final Promotion title;

  @override
  _HomePageState createState() => _HomePageState(title);
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int totalPage = 1;

  Promotion t;

  _HomePageState(Promotion title) {
    this.t = title;
  }

  void _onScroll() {}

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    )..addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      )),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          makePage(page: 1, image: t.image_url, title: t.title, description: '')
        ],
      ),
    );
  }

  Widget makePage({image, title, description, page}) {
    return Container(
      decoration: BoxDecoration(
          image:
              DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, stops: [
          0.3,
          0.9
        ], colors: [
          Colors.black.withOpacity(.9),
          Colors.black.withOpacity(.2),
        ])),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    FadeAnimation(
                        2,
                        Text(
                          page.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )),
                    Text(
                      '/' + totalPage.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeAnimation(
                          1,
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                height: 1.2,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.5,
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 3),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 15,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 15,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 15,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 3),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 15,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                              ),
                              Text(
                                '4.0',
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                '(2300)',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          2,
                          Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Text(
                              description,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.7),
                                  height: 1.9,
                                  fontSize: 15),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          2.5,
                          InkWell(
                              onTap: _ServiceTriggered,
                              child: Text(
                                'READ MORE',
                                style: TextStyle(color: Colors.white),
                              ))),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }

  _ServiceTriggered() {
    //final ServiceObject serviceData;
    //  print("Hello");

    ServiceObject _s = new ServiceObject();
    _s.title = t.title;
    _s.image_url = t.image_url;
    _s.type = "0";
    _s.description = t.description;
    _s.contact = t.contact_info;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ServiceInfoPage(
                  serviceData: _s,
                )) //ServiceItemPage(serviceData: data[i])),
        );
  }
}
