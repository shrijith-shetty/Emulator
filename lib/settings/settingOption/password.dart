import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() => PasswordPage();

}

class PasswordPage extends State<Password>
{
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: InkWell(
                    onTap:
                    ()
                    {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Settings()));
                    },
                    child: Icon(Icons.password_outlined)),
                title: Text("Password",style: TextStyle(fontSize: 30),),


            )
        );
    }

}