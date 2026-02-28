import 'dart:async';
import 'package:emulator/Gallery/gallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpashScreenGallery extends StatefulWidget
{

  @override
  State<SpashScreenGallery> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreenGallery>
{
  @override
  void initState()
  {
    super.initState();
    Timer(Duration(seconds: 2), ()
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Gallery()));
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
          Image.asset("assets/icon/gallery.jpg", width: 100, height: 100,)

        ]
    );
  }
}