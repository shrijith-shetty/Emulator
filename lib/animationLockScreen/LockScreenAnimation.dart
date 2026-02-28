import 'package:emulator/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

class LockscreenAnimation extends StatelessWidget
{
    @override
    Widget build(BuildContext context)
    {
        return AnimatedSplashScreen(
            splash: Center(
                child: Lottie.asset('assets/animation/loginAnimation.json')
            ), nextScreen: MyHomePage(),
            splashIconSize: 600,
            duration: 3000,
        );
    }

}

