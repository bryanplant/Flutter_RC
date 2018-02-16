import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class RCAppBar extends StatefulWidget {
  final String title;
  final double height;

  RCAppBar({this.title, this.height});

  @override
  RCAppBarState createState() =>
      new RCAppBarState(title: this.title, height: this.height);
}

class RCAppBarState extends State<RCAppBar> {
  final String title;
  final double height;
  List<PopupMenuItem<String>> devices = new List<PopupMenuItem>();

  static const bluetooth = const MethodChannel('com.bryanplant/bluetooth');

  bool lightOn = false;
  Color lightColor = Colors.white;

  bool btConnected = false;
  Color btColor = Colors.white;

  RCAppBarState({this.title, this.height});

  @override
  initState() {
    super.initState();
    _getPairedDevices();
  }

  Future<Null> _getPairedDevices() async {
    try {
      List<String> names = await bluetooth.invokeMethod('init');
      names.forEach((s) {
        devices.add(new PopupMenuItem(child: new Text(s), value: s));
      });

      setState(() {});
    } catch (e) {
      print('failed... $e');
    }
  }

  Future<Null> _connectDevice(String name) async {
    bool isConnected = await bluetooth.invokeMethod('connect', name);

    if (isConnected) {
      setState(() {
        btConnected = true;
        btColor = Colors.blue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: this.height,
      color: Colors.black,
      child: new Row(
        children: <Widget>[
          new IconButton(
              icon: new Icon(
                  Icons.lightbulb_outline, color: lightColor, size: 30.0),
              padding: new EdgeInsets.only(left: 5.0),
              onPressed: _lightPressed),
          new PopupMenuButton(
              icon: new Icon(
                  btConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                  color: btColor, size: 30.0),
              itemBuilder: (_) {
                return devices;
              },
              onSelected: (String s) {
                _connectDevice(s);
              }
          ),
          new Text(
              title, style: new TextStyle(fontSize: 20.0, color: Colors.white))
        ],
      ),
    );
  }

  void _lightPressed() {
    setState(() {
      bluetooth.invokeMethod("write", "a");
      lightOn = !lightOn;
      lightColor = lightOn ? Colors.blue : Colors.white;
    });
  }
}