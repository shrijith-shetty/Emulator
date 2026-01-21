import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Addwallpaper extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() =>
    _AddWallPaper();
}

class _AddWallPaper extends State<Addwallpaper>
{
    List<String> imageList = [
        "bird-8570950_1280.jpg",
        "bird-9163532_1280.jpg",
        "bird-9207453_1280.jpg",
        "cows-9099843_1280.jpg",
        "dahlia-8209085_1280.jpg",
        "desert-2435404_1280.jpg",
        "donkey-9035452_1280.jpg",
        "flower-8559381_1280.jpg",
        "full-moon-7471483_1280.jpg",
        "goat-9017896_1280.jpg",
        "grass-9130658_1280.jpg",
        "grass-9197163_1280.jpg",
        "horse-3114412_1280.jpg",
        "horse-7993645_1280.jpg",
        "istockphoto-844226534-2048x2048.webp",
        "istockphoto-1301592082-1024x1024.jpg",
        "leaves-8319393_1280.jpg",
        "lion-tamarin-9171365_1280.jpg",
        "mantis-8226119_1280.jpg",
        "mountain-range-9842371_1280.webp",
        "mountains-540115_1280.jpg",
        "nature-9710930_1280.webp",
        "polar-lights-5858656_1280.jpg",
        "prairie-dog-9569847_1280.webp",
        "reed-9540853_1280.webp",
        "sea-6543041_1280.jpg",
        "starfishes-1351559_1280.jpg",
        "sunflowers-3792914_1280.jpg",
        "water-3021652_1280.jpg",
        "wave-7726187_1280.jpg"
    ];
    String currentWallpaper = "assets/Gallery/flower-8559381_1280.jpg";
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
                    onTap: ()
                    {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                    }
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
                                    isDismissible: true,
                                    enableDrag: true,
                                    builder: (BuildContext context)
                                    {
                                        return SizedBox(

                                            height: 400,
                                            width: double.infinity,
                                            child: GridView.builder(
                                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(

                                                    maxCrossAxisExtent: 150,
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10

                                                ),
                                                itemCount: imageList.length,
                                                itemBuilder: (context, index)
                                                {
                                                    return InkWell(
                                                        onTap: ()
                                                        {
                                                            currentWallpaper = "assets/Gallery/${imageList[index]}";

                                                            setState(()
                                                                {
                                                                    Navigator.pop(context);
                                                                });
                                                        },
                                                        child: Image.asset("assets/Gallery/${imageList[index]}", fit: BoxFit.cover));
                                                }
                                            )
                                        );
                                    });
                            },
                            child: InkWell(

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                      width: 200,
                                      height: 150,
                                      // color: Colors.blue,
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(35)
                                      //     // boxShadow:
                                      // ),
                                      child: Image.asset(currentWallpaper,
                                          fit: BoxFit.cover
                                      )
                                  ),
                                )
                            )
                        ),
                        SizedBox(height: 100)

                    ]
                )

            )
        );
    }

}

