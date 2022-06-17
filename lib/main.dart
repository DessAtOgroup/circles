import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubbling circles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Circles, that jump'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Circle {
  double x = 10;
  double y = 10;
  double dx = 30;
  double dy = 30;
  late double radius;
  Color? color;

  Circle(double inV, double this.radius) {
    color = Colors.black;
    dx = inV;
    dy = inV;
  }

  void CheckDirection(inContext) {
    var scr = MediaQuery.of(inContext).size;
    double hmax = scr.height;
    double wmax = scr.width;
    dx = (x + dx + radius * 2 > wmax || x + dx < 0) ? -dx : dx;
    dy = (y + dx + radius * 2 > hmax || y + dx < 0) ? -dy : dy;
    x += dx;
    y += dy;
  }

  Widget kurkle() {
    return Container(
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black), //TODO сам проблемс виз колорс

      width: radius * 2,
      height: radius * 2,
    );
  }
}

class SetOfCircles {
  var itsaMap = {};

  SetOfCircles(@required int inCount) {
    inCount = (inCount < 0) ? 0 : inCount;
    for (int i = 0; i < inCount; i++) {
      var r = Random();
      Circle c =
          Circle(r.nextInt(20) + 5.toDouble(), r.nextInt(30) + 90.toDouble());
      itsaMap[c] = c.kurkle();
    }
  }

  List<Widget> getPositioned() {
    List<Widget> rez = [];
    itsaMap.forEach((key, value) {
      rez.add(Positioned(
        child: value,
        top: key.y,
        left: key.x,
      ));
    });
    return rez;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  SetOfCircles _setOfCircles = SetOfCircles(5);

  void incrementCounter() {
    setState(() {
      _setOfCircles.itsaMap.forEach((key, value) {
        key.CheckDirection(context);
      });
    });
  }

  void startTimer() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      incrementCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(children: _setOfCircles.getPositioned()),
      floatingActionButton: FloatingActionButton(
        onPressed: startTimer,
        tooltip: 'Increment',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
