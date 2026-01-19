
import 'package:emulator/Gallery/gallery.dart';
import 'package:emulator/calculator/calculator.dart';
import 'package:emulator/camera/camera.dart';
import 'package:emulator/settings/settingOption/addWallpaper.dart';
import 'package:emulator/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_page.dart';

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

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context)
    {

      return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(

                colorScheme: .fromSeed(seedColor: Colors.deepPurple)
            ),
            home: Addwallpaper( /*title: "title"*/)
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

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.grey,
                title: Text("Emulator", style: TextStyle(fontSize: 30))
            ),
            body: Padding(

                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                    spacing: 20,
                    children: [
                        design(context, "a"),
                        design(context, "b"),
                        design(context, "c"),
                        design(context, "d")
                    ]
                )
            )
        );
    }

}

Widget design(BuildContext context, String text)
{
    return Container(
        width: 50,
        height: 50,

        decoration: BoxDecoration(

            color: Colors.blue,
            borderRadius: BorderRadius.circular(12)
        ),
        child: InkWell(
            onTap: ()
            {
                if (text == 'a')
                {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Calculator(title: 'jai'))
                    );
                }
                if (text == 'b')
                {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Settings())
                    );
                }
                if (text == 'c')
                {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => CameraPage())
                    );
                }
                if(text=='d')
                  {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context)=>Gallery())
                    );
                  }

            },
            child: Center(child: Text(text, style: TextStyle(color: Colors.black, fontSize: 30)))
        )

    );
}
