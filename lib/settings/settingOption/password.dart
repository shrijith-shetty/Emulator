import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() => PasswordPage();

}

class PasswordPage extends State<Password>
{

    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();
    @override

    Widget build(BuildContext context)
    {

        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: InkWell(
                    onTap:
                    ()
                    {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                    },
                    child: Icon(Icons.password_outlined, size: 30, color: Colors.white)),
                title: Text("Password", style: TextStyle(fontSize: 30, color: Colors.white))
            ),
            body: Container(
                child: Center(
                    child: InkWell(
                        onTap: ()
                        {
                            showModalBottomSheet(context: context, builder: (context)
                                {
                                    return Container(
                                        width: 500,
                                        height: 800,
                                        color: Colors.blue.shade50,
                                        child: Column(
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                SizedBox(
                                                    height: 40
                                                ),
                                                SizedBox(
                                                    width: 400,
                                                    child: TextField(

                                                        controller: oldPassword,
                                                        decoration: InputDecoration(
                                                            labelText: "Enter old Password",
                                                            fillColor: Colors.grey,
                                                            filled: true,
                                                            prefixIcon: Icon(Icons.password_outlined),
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.amber, width: 3),
                                                                borderRadius: BorderRadius.circular(20)
                                                            )
                                                        )
                                                    )
                                                ),
                                                SizedBox(height: 30),
                                                SizedBox(
                                                    width: 400,
                                                    child: TextField(
                                                        controller: newPassword,
                                                        decoration: InputDecoration(
                                                            labelText: "Enter old Password",
                                                            fillColor: Colors.grey,
                                                            filled: true,
                                                            prefixIcon: Icon(Icons.password_outlined),
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.amber, width: 3),
                                                                borderRadius: BorderRadius.circular(20)
                                                            )
                                                        )
                                                    )
                                                ),
                                                SizedBox(height: 30),
                                                InkWell(
                                                    onTap: ()
                                                    {
                                                        if (newPassword.text.length < 4)
                                                        {
                                                            // password should be more than 4 character
                                                        }
                                                        if (newPassword.text == oldPassword.text)
                                                        {
                                                            //old and new password are same
                                                        }
                                                        else if (oldPassword.text != "password")
                                                        {
                                                            //password is incorrect
                                                        }
                                                        else if (oldPassword.text == "password" && oldPassword.text != newPassword.text)
                                                        {
                                                            //password changed successfully
                                                        } else
                                                        {
                                                            //error
                                                        }
                                                    },
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadiusGeometry.circular(12),
                                                        child: Container(
                                                            height: 50,
                                                            width: 100,
                                                            color: Colors.blue,
                                                            child: Text("Change")
                                                        )
                                                    )
                                                )
                                            ]
                                        )
                                    );
                                }
                            );
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(12),
                            child: Container(

                                height: 50, width: 100, color: Colors.blue, child: Center(child: Text("Change Password"))))
                    )
                )
            )

        );
    }

}

// showModalBottomSheet(context: context, builder: (context)
//     {
//         return Container(
//             width: 500,
//             height: 400,
//             color: Colors.blue,
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                     Center(
//                         child: TextField(
//
//                             controller: oldPassword,
//
//                             decoration: InputDecoration(
//                                 hintText: "Enter old Password",
//                                 fillColor: Colors.grey,
//                                 filled: true
//
//                             )
//                         )
//                     ),
//                     SizedBox(height: 55),
//                     Center(child: TextField())
//                 ]
//             )
//         );
//     });

//
// PopupMenuItem(
// child: SizedBox(
// height: 400,
// width: 400,
// child: TextField(
// controller: oldPassword,
//
// decoration: InputDecoration(
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12)
// ),
// hintText: "Enter old Password",
// fillColor: Colors.grey,
// filled: true
// )
// )
// )
// );