import 'dart:async';
import 'package:emulator/browser/index.dart';
import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpashScreenBroswer extends StatefulWidget {
  @override
  State<SpashScreenBroswer> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreenBroswer> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(key: widgetKey)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon(Icons.calculate, color: Colors.orange, size: 200),
        // // SizedBox(height: 0,),
        // Text("assets/icon/setting.jpg", style: TextStyle(fontSize: 42, color: Colors.orange))
        Image.asset("assets/icon/broswer.webp", width: 100, height: 100),
      ],
    );
  }
}
