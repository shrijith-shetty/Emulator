import 'dart:async';

import 'package:emulator/camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpashScreenCamera extends StatefulWidget
{

    @override
    State<SpashScreenCamera> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreenCamera>
{
    @override
    void initState()
    {
        super.initState();
        Timer(Duration(seconds: 2), ()
            {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CameraPage()));
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
                // SizedBox(height: 0,),
                // Text("assets/icon/camera.jpg", style: TextStyle(fontSize: 42, color: Colors.orange))
              Image.asset("assets/icon/camera.jpg", width: 100, height: 100,)
            ]
        );
    }
}