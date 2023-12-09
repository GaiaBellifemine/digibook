import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';
import 'package:flutter_map/flutter_map.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  MapController controller=new MapController();



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text("Mappa"),
          backgroundColor: Color.fromRGBO(77, 49, 71, 10),
        ),
        body: new Center(child: Text("Questa é la mappa")),
    );
  }
}
