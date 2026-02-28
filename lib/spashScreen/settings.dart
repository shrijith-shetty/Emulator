import 'dart:async';
import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpashScreenSettings extends StatefulWidget
{

  @override
  State<SpashScreenSettings> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreenSettings>
{
  @override
  void initState()
  {
    super.initState();
    Timer(Duration(seconds: 2), ()
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Settings()));
    });
  }
  @override
  Widget build(BuildContext context)
  {
    // TODO: implement build
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(Icons.calculate, color: Colors.orange, size: 200),
          // // SizedBox(height: 0,),
          // Text("assets/icon/setting.jpg", style: TextStyle(fontSize: 42, color: Colors.orange))
          Image.asset("assets/icon/download.jpg", width: 100, height: 100,)

        ]
    );
  }
}