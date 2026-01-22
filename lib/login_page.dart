import 'package:emulator/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class _Password
// {
//   // String password = _LoginPageState();
//   if(Password=="shrift")
//   {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context)=>const MyHomePage(title: "title"))
//     );
//   }
// }

class LoginPage extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>
{
    bool _obsecure = true;
    TextEditingController Password = TextEditingController();
    // _LoginPageState({required this.Password});
    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 14.0, right: 14),
                            child: SizedBox(
                                // width: 370,
                                height: 50,
                                child: TextField(
                                    controller: Password,
                                    obscureText: _obsecure,
                                    decoration: InputDecoration(
                                        filled: true,
                                        labelText: "Password",

                                        labelStyle: TextStyle(
                                            color: Colors.red
                                        ),
                                        prefixIcon: Icon(Icons.password, color: Colors.black, size: 20, fontWeight: FontWeight.bold),
                                        suffixIcon: IconButton(onPressed: (){
                                          setState(() {
                                            _obsecure=!_obsecure;
                                          });
                                        }, icon: Icon(_obsecure?CupertinoIcons.eye:CupertinoIcons.eye_slash)),

                                        fillColor: Colors.red.shade100,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 1.0
                                            )
                                        ),
                                        focusedBorder: OutlineInputBorder(

                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                                color: Colors.purple,
                                                width: 2
                                            )
                                        )
                                    )
                                )
                            )
                        ),
                        SizedBox(
                            height: 30
                        ),
                        ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(30),
                            child: Container(
                                width: 150,
                                height: 50,

                                decoration: BoxDecoration(
                                    color: Colors.blue
                                ),

                                child: InkWell(onTap: () =>
                                    {

                                        if(Password.text == "password")
                                        {
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Jai"))
                                            )
                                        }
                                        else
                                        {
                                            Password.clear()
                                        }
                                    }, child: Center(child: Text("Sign In", style: TextStyle(color: Colors.black, fontSize: 20)))

                                )
                            )
                        )
                    ]

                )
            )
        );
    }

}