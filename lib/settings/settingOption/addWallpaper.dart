import 'package:emulator/settings/settings.dart';
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
                leading: InkWell(
                    child: Icon(
                        Icons.wallpaper_rounded,
                        color: Colors.white,
                        size: 30
                    ),
                  onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Settings()));
                  },
                ),
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
                                showModalBottomSheet(context: context,
                                    builder: (BuildContext context)
                                    {
                                        return SizedBox(
                                            height: 400,
                                            width: double.infinity,
                                            child: Builder(builder: builder)
                                        );
                                    });
                            },
                            child: Image.asset("assets/Gallery/flower-8559381_1280.jpg",
                                width: 200,
                                height: 150
                            )
                        ),
                        SizedBox(height: 100)

                    ]
                )

            )
        );
    }

}

