import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Update extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() => UpdatePage();

}

class UpdatePage extends State<Update>
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
                    child: Icon(Icons.update,size: 30,color: Colors.white,)),
                title: Text("Update",style: TextStyle(fontSize: 30,color:Colors.white),),


            )
        );
    }

}