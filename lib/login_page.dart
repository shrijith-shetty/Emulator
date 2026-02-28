import 'package:emulator/animationLockScreen/LockScreenAnimation.dart';
import 'package:emulator/main.dart';
import 'package:emulator/settings/settingOption/password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'database/password.dart';

class LoginPage extends StatefulWidget
{
    const LoginPage({super.key});

    @override
    State<StatefulWidget> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>
{
    final PasswordStorage _authService = PasswordStorage();    
    bool _obsecure = true;
    final TextEditingController _controller = TextEditingController();
    late SMITrigger _trigger;

    bool _isPassword = false;
    String _message = "";

    @override
    void initState()
    {
        // TODO: implement initState
        super.initState();
        _checkPassword();
    }

    Future<void> _checkPassword() async
    {
        bool exists = await _authService.isPasswordSet();
        setState(()
            {
                _isPassword = exists;
            });
    }

    Future<void> _handleButton() async
    {
        String input = _controller.text.trim();

        if (input.isEmpty)
        {
            setState(()
                {
                    _message = "Password cannot be empty";
                });
            return;
        }

        if (!_isPassword)
        {
            await _authService.setPassword(input);
            setState(()
                {
                    _message = "Password set successfully!";
                    _isPassword = true;
                });
        }
        else
        {
            bool correct = await _authService.verifyPassword(input);

            if (correct)
            {
                setState(()
                    {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LockscreenAnimation())
                        );

                    });
            } else
            {
                setState(()
                    {
                        _message = "Wrong Password";
                    });
            }
        }
        _controller.clear();
    }

    void _onRiverItt(Artboard artboard)
    {
        final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (controller != null)
        {
            artboard.addController(controller);
            _trigger = controller.findSMI('play') as SMITrigger;
        }
    }

    @override
    void dispose()
    {
        _controller.dispose();
        super.dispose();
    }

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
                                    controller: _controller,
                                    obscureText: _obsecure,
                                    decoration: InputDecoration(
                                        filled: true,
                                        labelText: "Password",

                                        labelStyle: TextStyle(
                                            color: Colors.black
                                        ),
                                        prefixIcon: Icon(Icons.password, color: Colors.black, size: 20, fontWeight: FontWeight.bold),
                                        suffixIcon: IconButton(onPressed: ()
                                            {
                                                setState(()
                                                    {
                                                        _obsecure = !_obsecure;
                                                    });
                                            }, icon: Icon(_obsecure ? CupertinoIcons.eye : CupertinoIcons.eye_slash)),

                                        fillColor: Colors.grey.shade100,
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

                                child: InkWell(onTap: ()
                                    {
                                        _handleButton();

                                    }, child: Center(child: Text(_isPassword ? "Login" : "Sign In", style: TextStyle(color: Colors.black, fontSize: 20)))

                                )
                            )
                        )
                    ]

                )
            )
        );
    }

}