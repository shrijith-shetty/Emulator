import 'package:device_info_plus/device_info_plus.dart';
import 'package:emulator/settings/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AboutPhone extends StatefulWidget
{
    const AboutPhone({super.key});

    @override
    State<AboutPhone> createState() => _AboutPhoneState();
}

class _AboutPhoneState extends State<AboutPhone>
{
    List<String> text = ["loading..."];

    @override
    void initState()
    {
        // text.clear();
        super.initState();
        loadInfo();
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: InkWell(
                    onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>Settings())),
                    child: const Icon(
                        Icons.phone_iphone_outlined,
                        size: 30,
                        color: Colors.white
                    )
                ),

                title: const Text(
                    'About Phone',
                    style: TextStyle(fontSize: 20, color: Colors.white)
                )
            ),
            body: Container(
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                    itemCount: text.length,
                    itemBuilder: (context, int index)
                    {
                        return ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(15),
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(

                                    height: 40,
                                    width: 800,
                                    color: Colors.black,
                                    child: Center(
                                        child: Text(
                                            text[index].toString(),
                                            style: const TextStyle(fontSize: 16, color: Colors.white)
                                        )
                                    )
                                )
                            )
                        );
                    }
                )
            )
        );
    }

    Future<void> loadInfo() async
    {
        final deviceInfo = DeviceInfoPlugin();

        // WEB
        if (kIsWeb)
        {
            final androidInfo = await deviceInfo.androidInfo;
            int count = 0;
            setState(()
                {
                    text.insert(count++, androidInfo.brand);
                    text.insert(count++, androidInfo.manufacturer);
                    text.insert(count++, androidInfo.model);
                    text.insert(count++, androidInfo.device);
                    text.insert(count++, androidInfo.product);
                    // text.insert(count++, androidInfo.version as String);
                    // text.insert(count++, androidInfo.totalDiskSize as String);
                });
            return;
        }

        switch (defaultTargetPlatform)
        {
            case TargetPlatform.android:
                final androidInfo = await deviceInfo.androidInfo;
                int count = 0;
                setState(()
                    {
                        text.insert(count++, androidInfo.brand);
                        text.insert(count++, androidInfo.manufacturer);
                        text.insert(count++, androidInfo.model);
                        text.insert(count++, androidInfo.device);
                        text.insert(count++, androidInfo.product);
                        // text.insert(count++, androidInfo.version as String);
                        // text.insert(count++, androidInfo.totalDiskSize as String);
                    });
                break;

            case TargetPlatform.iOS:
                final androidInfo = await deviceInfo.androidInfo;
                int count = 0;
                setState(()
                    {
                        text.insert(count++, androidInfo.brand);
                        text.insert(count++, androidInfo.manufacturer);
                        text.insert(count++, androidInfo.model);
                        text.insert(count++, androidInfo.device);
                        text.insert(count++, androidInfo.product);
                        // text.insert(count++, androidInfo.version as String);
                        // text.insert(count++, androidInfo.totalDiskSize as String);
                    });
                break;

            case TargetPlatform.windows:
                final androidInfo = await deviceInfo.androidInfo;
                int count = 0;
                setState(()
                    {
                        text.insert(count++, androidInfo.brand);
                        text.insert(count++, androidInfo.manufacturer);
                        text.insert(count++, androidInfo.model);
                        text.insert(count++, androidInfo.device);
                        text.insert(count++, androidInfo.product);
                        // text.insert(count++, androidInfo.version as String);
                        // text.insert(count++, androidInfo.totalDiskSize as String);
                    });
                break;

            default:
            setState(()
                {
                    text.insert(0, "Unsupported");
                });
        }
    }
}
