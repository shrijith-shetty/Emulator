import 'dart:ui';

import 'package:emulator/camera/camera.dart';
import 'package:emulator/settings/settingOption/aboutphone.dart';
import 'package:emulator/settings/settingOption/display.dart';
import 'package:emulator/settings/settingOption/addWallpaper.dart';
import 'package:emulator/settings/settingOption/password.dart';
import 'package:emulator/settings/settingOption/update.dart';
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
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 30, color: Colors.white)
                )
            ),
            body: Container(
                color: CupertinoColors.black,
                child: ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (context, index)
                    {
                        return ListTile(
                            tileColor: CupertinoColors.black,
                            leading: Icon(
                                appIcons[index],
                                color: Colors.white,
                                size: 30
                            ),
                            title: Text(
                                names[index],
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                )
                            ),
                            onTap: ()
                            {
                                if (names[index] == "WallPaper")
                                {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Addwallpaper()));
                                }
                                if (names[index] == "Display")
                                {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayClass()));
                                }
                                if (names[index] == "Password")
                                {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Password()));
                                }if (names[index] == "About Phone")
                                {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPhone()));
                                }if (names[index] == "System Update")
                                {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Update()));
                                }
                            }
                        );
                    }
                )
            )
        );
    }
}