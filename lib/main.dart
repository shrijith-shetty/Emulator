import 'dart:io';

import 'package:emulator/Gallery/gallery.dart';
import 'package:emulator/calculator/calculator.dart';
import 'package:emulator/camera/camera.dart';
import 'package:emulator/database/wallpaper_storage.dart';
import 'package:emulator/settings/settingOption/addWallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main()
{
    runApp(
        ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            builder: (context, child)
            {
                return const MyApp();
            }
        )
    );
}

class MyApp extends StatelessWidget
{
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) 
    {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const MyHomePage(title: "Emulator")
        );
    }
}

class MyHomePage extends StatefulWidget
{
    const MyHomePage({super.key, required this.title});
    final String title;

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
    final StoreCurrentWallPaper _wallpaper = StoreCurrentWallPaper();

    bool isWallpaper = false;
    String currentWallpaper = "";

    // ================= LOAD WALLPAPER =================

    Future<void> loadWallpaper() async
    {
        String? path = await _wallpaper.getWallpaper();

        if (!mounted) return;

        if (path != null && path.isNotEmpty) 
        {
            setState(()
                {
                    currentWallpaper = path;
                    isWallpaper = true;
                });
        } else 
        {
            setState(()
                {
                    isWallpaper = false;
                });
        }
    }

    @override
    void initState() 
    {
        super.initState();
        loadWallpaper();
    }

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.grey,
                title: const Text(
                    "Emulator",
                    style: TextStyle(fontSize: 30)
                )
            ),
            body: Stack(
                children: [
                    // ================= WALLPAPER =================
                    !isWallpaper
                        ? Container(color: Colors.green)
                        : SizedBox.expand(
                            child: Image.file(
                                File(currentWallpaper),
                                fit: BoxFit.cover
                            )
                        ),

                    // ================= ICONS =================
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Wrap(
                            spacing: 20,
                            children: [
                                design("a"),
                                design("b"),
                                design("c"),
                                design("d")
                            ]
                        )
                    )
                ]
            )
        );
    }

    // ================= ICON DESIGN =================

    Widget design(String text) 
    {
        late String iconImage;

        if (text == 'a') 
        {
            iconImage = 'assets/icon/calculator.jpg';
        } else if (text == 'b') 
        {
            iconImage = 'assets/icon/download.jpg';
        } else if (text == 'c') 
        {
            iconImage = 'assets/icon/camera.jpg';
        } else 
        {
            iconImage = 'assets/icon/gallery.jpg';
        }

        return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
                width: 50,
                height: 50,
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async
                        {
                            if (text == 'a') 
                            {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Calculator(title: 'jai')
                                    )
                                );
                            }

                            else if (text == 'b') 
                            {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Addwallpaper()
                                    )
                                );

                                // 🔥 THIS IS THE IMPORTANT PART
                                if (result == true) 
                                {
                                    await loadWallpaper(); // reload wallpaper instantly
                                }
                            }

                            else if (text == 'c') 
                            {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CameraPage()
                                    )
                                );
                            }

                            else if (text == 'd') 
                            {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Gallery()
                                    )
                                );
                            }
                        },
                        child: Center(
                            child: Image.asset(
                                iconImage,
                                width: 49,
                                height: 49,
                                fit: BoxFit.cover
                            )
                        )
                    )
                )
            )
        );
    }
}