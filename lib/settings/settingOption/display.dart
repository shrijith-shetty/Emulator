import 'package:emulator/settings/settings.dart';
import 'package:flutter/material.dart';

class DisplayClass extends StatefulWidget
{
    const DisplayClass({super.key});

    @override
    State<StatefulWidget> createState() => DisplayPage();
}

class DisplayPage extends State<DisplayClass>
{
    String title = "First item";
    String item1 = "First item";
    String item2 = "First item";
    String item3 = "First item";
    double brightness = 0.4;
    String value = "";
    @override

    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: InkWell(
                    onTap: ()
                    {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                    }, child: Icon(Icons.display_settings_outlined, color: Colors.white, size: 30)),
                title: Text("Display", style: TextStyle(fontSize: 30, color: Colors.white))
            ),
            body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        children: [
                            Text("Brightness",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black
                                )
                            ),
                            Slider(
                                value: brightness,
                                max: 100,
                                min: 0,
                                divisions: 1,
                                onChanged: (brightness)
                                {
                                    setState(()
                                        {
                                            brightness += brightness;
                                        });
                                }
                            ),
                            Text("Choose Text", style: TextStyle(fontSize: 20)),
                            InkWell(
                                onTap: ()
                                {
                                    PopupMenuButton<>(onSelected: (value)
                                        {
                                            // Text(value, style: TextStyle(fontSize: 20));
                                        }, itemBuilder: (BuildContext context) => [
                                            const PopupMenuItem(child: Text("Settings")),
                                            const PopupMenuItem(child: Text("Settings")),
                                            const PopupMenuItem(child: Text("Settings")),

                                        ]);
                                },
                                child: Text("Current Text is \"bold\"", style: TextStyle(fontSize: 20)))
                        ]
                    )
                )
            )
        );
    }

}