import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emulator/database//password.dart';

class Password extends StatefulWidget
{
    @override
    State<StatefulWidget> createState() => PasswordPage();

}

class PasswordPage extends State<Password>
{
    final PasswordStorage _authService = PasswordStorage();
    late bool _isPassword;
    bool _obsecOld = true;
    bool _obsecNew = true;
    String errorMsg = "";
    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();
    Future<void> isPassword() async
    {
        _isPassword = await _authService.isPasswordSet();

    }

    Future<void> changePassword() async
    {
        String old_pass = oldPassword.text.trim();
        String new_pass = newPassword.text.trim();

        await isPassword();

        if (_isPassword)
        {

            if (old_pass.isEmpty || new_pass.isEmpty)
            {
                setState(()
                    {
                        errorMsg = "Password should not be empty";
                    });
                return;
            }

            if (new_pass.length < 4)
            {
                setState(()
                    {
                        errorMsg = "Password should be greater than 4 digits";
                    });
                return;
            }

            if (old_pass == new_pass)
            {
                setState(()
                    {
                        errorMsg = "Old password should not be equal to new password";
                    });
                return;
            }

            bool isValid = await _authService.verifyPassword(old_pass);

            if (!isValid)
            {
                setState(()
                    {
                        errorMsg = "Old password is incorrect";
                    });
                return;
            }

            await _authService.setPassword(new_pass);

            setState(()
                {
                    errorMsg = "Password changed successfully";
                });

        } else
        {

            if (new_pass.isEmpty)
            {
                setState(()
                    {
                        errorMsg = "Password should not be empty";
                    });
                return;
            }

            if (new_pass.length < 4)
            {
                setState(()
                    {
                        errorMsg = "Password should be greater than 4 digits";
                    });
                return;
            }

            await _authService.setPassword(new_pass);

            setState(()
                {
                    errorMsg = "Password set successfully";
                });
        }
    }

    @override
    void initState()
    {
        // TODO: implement initState
        super.initState();
        isPassword();
    }

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

                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            InkWell(
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
                                                                obscureText: true,
                                                                controller: oldPassword,

                                                                decoration: InputDecoration(
                                                                    suffixIcon: IconButton(onPressed: ()
                                                                        {setState(()
                                                                                {
                                                                                    _obsecOld = !_obsecOld;
                                                                                });
                                                                        },
                                                                        icon: Icon(
                                                                            _obsecOld ?
                                                                                CupertinoIcons.eye :
                                                                                CupertinoIcons.eye_slash
                                                                        )
                                                                    ),
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
                                                                obscureText: true,
                                                                controller: newPassword,
                                                                decoration: InputDecoration(
                                                                    suffixIcon: IconButton(onPressed: ()
                                                                        {
                                                                            setState(()
                                                                                {
                                                                                    _obsecNew = !_obsecNew;
                                                                                });
                                                                        }, icon: Icon(_obsecNew ? CupertinoIcons.eye : CupertinoIcons.eye_slash)),
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
                                                            async
                                                            {
                                                                await changePassword();
                                                                Navigator.pop(context);
                                                                newPassword.clear();
                                                                oldPassword.clear();
                                                            },
                                                            child: ClipRRect(
                                                                borderRadius: BorderRadiusGeometry.circular(12),
                                                                child: Container(
                                                                    height: 50,
                                                                    width: 100,
                                                                    color: Colors.blue,
                                                                    child: Center(
                                                                        // padding: const EdgeInsets.all(10.0),
                                                                        child: Text("Change")
                                                                    )
                                                                )
                                                            )

                                                        ),
                                                        Text(errorMsg, style: TextStyle(fontSize: 20))
                                                    ]
                                                )
                                            );
                                        }
                                    );
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(12),
                                    child: Container(

                                        height: 50, width: 150, color: Colors.blue, child: Center(
                                            // padding: const EdgeInsets.only(left: 15.0, top: 5),
                                            child: Text("Change Password")
                                        )))
                            ),
                            SizedBox(height: 30),
                            Text(errorMsg, style: TextStyle(fontSize: 20, color: Colors.black))
                        ]
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