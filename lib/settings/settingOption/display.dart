import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class DisplayClass extends StatefulWidget
{
    const DisplayClass({super.key});

    @override
    State<DisplayClass> createState() => DisplayPage();
}

class DisplayPage extends State<DisplayClass>
{
    double brightness = 0.4;

    @override
    void initState()
    {
        super.initState();
        _loadCurrentBrightness();
    }

    Future<void> _loadCurrentBrightness() async
    {
        try
        {
            double current =
                await ScreenBrightness.instance.system;
            setState(()
                {
                    brightness = current;
                });
        } catch (e)
        {
            debugPrint("Error getting brightness: $e");
        }
    }

    Future<void> _setBrightness(double value) async
    {
        try
        {
            await ScreenBrightness.instance
                .setApplicationScreenBrightness(value);
        } catch (e)
        {
            debugPrint("Brightness error: $e");
        }
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: ()
                    {
                        Navigator.pop(context);
                    }
                ),
                title: const Text(
                    "Display",
                    style: TextStyle(fontSize: 24, color: Colors.white)
                )
            ),
            body: Column(
              children: [
                Expanded(
                    child: Center(
                        child: SizedBox(
                            height: 300,
                            child: RotatedBox(
                                quarterTurns: -1, // Makes slider vertical
                                child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                        trackHeight: 10,
                                        activeTrackColor: Colors.blue,
                                        inactiveTrackColor: Colors.grey.shade300,
                                        thumbColor: Colors.blue,
                                        overlayColor: Colors.blue.withOpacity(0.2),
                                        thumbShape:
                                        const RoundSliderThumbShape(enabledThumbRadius: 14.0),
                                        overlayShape:
                                        const RoundSliderOverlayShape(overlayRadius: 28.0),
                                        valueIndicatorColor: Colors.blue,
                                        valueIndicatorTextStyle:
                                        const TextStyle(color: Colors.white),
                                        showValueIndicator: ShowValueIndicator.always
                                    ),
                                    child: Slider(
                                        value: brightness,
                                        min: 0.0,
                                        max: 1.0,
                                        divisions: 100,
                                        label: "${(brightness * 100).toInt()}%",
                                        onChanged: (value)
                                        {
                                            setState(()
                                                {
                                                    brightness = value;
                                                });
                                            _setBrightness(value);
                                        }
                                    )
                                )
                            )
                        )
                    )
                ),
              ],
            )
        );
    }
}