import 'package:emulator/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class DisplayClass extends StatefulWidget
{
    const DisplayClass({super.key});

    @override
    State<StatefulWidget> createState() => DisplayPage();
}

class DisplayPage extends State<DisplayClass>
{
    double brightness = 0.4;
    int count = 0;
    @override

    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: InkWell(
                    onTap: ()
                    {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings()
                            )
                        );
                    },
                    child: Icon(
                        Icons.display_settings_outlined,
                        color: Colors.white,
                        size: 30
                    )
                ),
                title: Text(
                    "Display",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white
                    )
                )
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
                                min: 0,
                                max: 100,
                                divisions: 100,
                                onChanged: (value)
                                async
                                {
                                    setState(()
                                        {
                                            brightness = value;
                                        });
                                    await ScreenBrightness.instance.setSystemScreenBrightness(value/100);
                                }
                            ),
                            Text("Choose Text", style: TextStyle(fontSize: 20)),
                            PopupMenuItem(
                                // onTap: (),
                                child: Text("Current Text is \"bold\"", style: TextStyle(fontSize: 20)
                                )
                            )
                        ]
                    )
                )
            )
        );
    }

}