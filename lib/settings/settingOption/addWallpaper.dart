import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Addwallpaper extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() =>
    _AddWallPaper();
}

class _AddWallPaper extends State<Addwallpaper>
{
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: CupertinoColors.black,
                leading: Icon(Icons.wallpaper_rounded, color: Colors.white, size: 30),
                title: Text("Wallpaper", style: TextStyle(fontSize: 30, color: Colors.white))
            ),
            body: Container(
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Center(child: Text("Current Wallpaper", style: TextStyle(fontSize: 30))),
                        InkWell(
                            onTap: ()
                            {

                            },
                            child: Image.asset("assets/Gallery/flower-8559381_1280.jpg",
                                width: 200,
                                height: 200
                            )

                        ),
                        SizedBox(height: 100)

                    ]
                )

            )
        );
    }

}