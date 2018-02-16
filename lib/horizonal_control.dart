import 'package:flutter/material.dart';

class HorizontalControl extends StatefulWidget {
  final double width;

  HorizontalControl({this.width});

  @override
  HorizontalControlState createState() =>
      new HorizontalControlState(width: this.width);
}

class HorizontalControlState extends State<HorizontalControl> {
  double offsetX = 0.0;
  double startX;
  double maxOffset = 120.0;
  double width;
  double power = 0.0;
  double iconSize = 75.0;

  HorizontalControlState({this.width}) {
    maxOffset = width / 2 - iconSize / 1.5;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
              margin: new EdgeInsets.only(left: 10.0),
              padding: new EdgeInsets.all(10.0),
              color: Colors.white,
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text("Offset:",
                        style: Theme
                            .of(context)
                            .textTheme
                            .button
                            .apply(color: Colors.black)),
                    new Text(power.truncate().toString() + "%",
                        style: Theme
                            .of(context)
                            .textTheme
                            .button
                            .apply(color: Colors.black))
                  ])),
          new Container(
              color: Colors.blue,
              width: width,
              child: new Listener(
                  onPointerDown: (PointerEvent event) {
                    setState(() {
                      startX = event.position.dx;
                    });
                  },
                  onPointerMove: (PointerEvent event) {
                    setState(() {
                      offsetX = event.position.dx - startX;
                      if (offsetX > maxOffset) offsetX = maxOffset;
                      if (offsetX < -maxOffset) offsetX = -maxOffset;
                      power = (offsetX / maxOffset) * 100.0;
                    });
                  },
                  onPointerUp: (PointerEvent event) {
                    setState(() {
                      offsetX = 0.0;
                      power = 0.0;
                    });
                  },
                  child: new Container(
                      transform:
                          new Matrix4.translationValues(offsetX, 0.0, 0.0),
                      child: new Icon(Icons.swap_horizontal_circle,
                          color: Colors.black, size: iconSize))))
        ]);
  }
}