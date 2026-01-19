import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget
{
    const Gallery({super.key});

    @override
    State<StatefulWidget> createState() =>
    GalleryPage();
}

class GalleryPage extends State<Gallery>
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
    late int itemCount = imageList.length;
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.grey,

                title: Row(
                    children: [
                        Icon(Icons.image),
                        Text("Gallry")
                    ]
                )
            ),

            body: Container(
                width: double.infinity,
                height: double.infinity,
                color: CupertinoColors.black,

                child: GridView.builder(

                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(

                        maxCrossAxisExtent: 150,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10
                    ),
                    itemCount: imageList.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                        return Image.asset("assets/Gallery/${imageList[index]}", fit: BoxFit.cover);
                    }
                )
            )
        );
    }

}