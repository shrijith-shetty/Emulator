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
                        TextField(
                            controller: Password,

                            decoration: InputDecoration(
                                filled: true,
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
                        ),
                        SizedBox(
                            height: 30
                        ),
                        Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.blue

                            ),

                            child: InkWell(onTap: () => 
                                {
                                    Text("Sign IN"),
                                    if(Password.text == "password")
                                    {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Jai"))
                                        )
                                    }
                                    else
                                    {
                                        Password.text = ""
                                    }
                                }

                            )
                        )
                    ]

                )
            )
        );
    }

}