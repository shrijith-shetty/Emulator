import 'dart:io';
import 'package:emulator/Gallery/gallery.dart';
import 'package:emulator/animationLockScreen/LockScreenAnimation.dart';
import 'package:emulator/browser/index.dart';
import 'package:emulator/browser/tabView.dart';
import 'package:emulator/calculator/calculator.dart';
import 'package:emulator/camera/camera.dart';
import 'package:emulator/login_page.dart';
import 'package:emulator/settings/settings.dart';
import 'package:emulator/spashScreen/broswer.dart';
import 'package:emulator/spashScreen/calculator.dart';
import 'package:emulator/spashScreen/camera.dart';
import 'package:emulator/spashScreen/gallery.dart';
import 'package:emulator/spashScreen/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'database/wallpaper_storage.dart';

void main()
{
    runApp(
        ScreenUtilInit(
            designSize: const Size(360, 690),
            builder: (_, __) => const MyApp()
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
            home: HomePage()
        );
    }
}

class MyHomePage extends StatefulWidget
{
    const MyHomePage({super.key});

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
    final StoreCurrentWallPaper _storage = StoreCurrentWallPaper();
    String currentWallpaper = "";

    @override
    void initState()
    {
        super.initState();
        _loadWallpaper();
    }

    Future<void> _loadWallpaper() async
    {
        final path = await _storage.getWallpaper();
        if (!mounted) return;

        setState(()
            {
                currentWallpaper = path ?? "";
            });
    }

    /// 🔥 Always reload after returning
    Future<void> _openSettings() async
    {
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SpashScreenSettings())
        );

        await _loadWallpaper(); // always reload
    }

    @override
    Widget build(BuildContext context)
    {
        final size = MediaQuery.of(context).size;

        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                    "Emulator",
                    style: TextStyle(color: Colors.white, fontSize: 26)
                )
            ),
            body: Stack(
                children: [

                    /// 🔥 FORCE FULL SCREEN WALLPAPER
                    SizedBox(
                        width: size.width,
                        height: size.height,
                        child: currentWallpaper.isEmpty
                            ? Container(color: Colors.black)
                            : Image.file(
                                File(currentWallpaper),
                                fit: BoxFit.cover,   // 🔥 auto zoom + crop
                                width: size.width,
                                height: size.height
                            )
                    ),

                    /// 🔥 Slight dark overlay
                    Container(
                        width: size.width,
                        height: size.height,
                        color: Colors.black.withOpacity(0.25)
                    ),

                    /// 🔥 APPS ON TOP
                    SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Wrap(
                                spacing: 25,
                                runSpacing: 25,
                                children: [
                                    _appIcon(
                                        context,
                                        'assets/icon/calculator.jpg',
                                        () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                SpashScreenCalculator())
                                        )
                                    ),
                                    _appIcon(
                                        context,
                                        'assets/icon/download.jpg',
                                        _openSettings
                                    ),
                                    _appIcon(
                                        context,
                                        'assets/icon/camera.jpg',
                                        () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => SpashScreenCamera())
                                        )
                                    ),
                                    _appIcon(
                                        context,
                                        'assets/icon/gallery.jpg',
                                        () => Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => SpashScreenGallery())
                                        )
                                    ),
                                  _appIcon(
                                      context,
                                      'assets/icon/broswer.webp',
                                          () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => SpashScreenBroswer())
                                      )
                                  )
                                ]
                            )
                        )
                    )
                ]
            )
        );
    }

    Widget _appIcon(
        BuildContext context, String imagePath, VoidCallback onTap)
    {
        return ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: onTap,
                    child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.15)
                        ),
                        child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover
                        )
                    )
                )
            )
        );
    }
}