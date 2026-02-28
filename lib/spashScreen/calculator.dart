import 'dart:async';
import 'package:emulator/calculator/calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpashScreenCalculator extends StatefulWidget
{

  @override
  State<SpashScreenCalculator> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreenCalculator>
{
  @override
  void initState()
  {
    super.initState();
    Timer(Duration(seconds: 2), ()
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Calculator(title: 'hello',)));
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
          Image.asset("assets/icon/calculator.jpg", width: 100, height: 100,)
        ]
    );
  }
}