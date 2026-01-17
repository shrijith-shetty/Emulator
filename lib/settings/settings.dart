import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() => _SettingsPage();

}

class _SettingsPage extends State<Settings>
{
    final List<String> names = ["Display", "WallPaper", "Password", "About Phone", "System Update"];
    final List<IconData> appIcons = [
        Icons.display_settings,
        Icons.wallpaper,
        Icons.password_outlined,
        Icons.phone_android,
        Icons.security_update
    ];
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: CupertinoColors.black,
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text("Settings", style: TextStyle(fontSize: 30, color: Colors.white)
                )
            ),
            body: Container(
                color: CupertinoColors.black,

                child: ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                        return Container(
                            height: 80,
                            width: double.infinity,
                            color: CupertinoColors.black,
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                    child: Row(children: [
                                            Icon(
                                                appIcons[index],
                                                color: Colors.white,
                                                size: 30
                                            )
                                            ,
                                            SizedBox(width: 20),
                                            Text(names[index], style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white))

                                        ]))
                            )
                        );
                    })
            )
        );
    }

}