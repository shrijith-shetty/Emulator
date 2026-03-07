import 'package:emulator/animationLockScreen/LockScreenAnimation.dart';
import 'package:emulator/settings/settingOption/password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database/password.dart';
import 'database/isPasswordRequeired.dart';

class LoginPage extends StatefulWidget
{
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
    final PasswordStorage _authService = PasswordStorage();
    final IsPasswordRequired _isRequired = IsPasswordRequired();

    bool _obsecure = true;
    final TextEditingController _controller = TextEditingController();

    bool _isPasswordRequired = false;
    bool _isPasswordSet = false;

    String _message = "";

    @override
    void initState() 
    {
        super.initState();
        _initializeApp();
    }

    /// 🔥 CHECK EVERYTHING AT APP START
    Future<void> _initializeApp() async
    {
        bool required = await _isRequired.isPasswordRequired();
        bool exists = await _authService.isPasswordSet();

        if (!required) 
        {
            // 🔓 Password not required → Go directly
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LockscreenAnimation())
            );
            return;
        }

        if (required && !exists) 
        {
            // ⚠ Required but password not set → Go to Password Page
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Password())
            );
            return;
        }

        setState(()
            {
                _isPasswordRequired = required;
                _isPasswordSet = exists;
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

        bool correct = await _authService.verifyPassword(input);

        if (correct) 
        {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LockscreenAnimation())
            );
        } else 
        {
            setState(()
                {
                    _message = "Wrong Password";
                });
        }

        _controller.clear();
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
            body: _isPasswordRequired
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                    controller: _controller,
                                    obscureText: _obsecure,
                                    decoration: InputDecoration(
                                        filled: true,
                                        labelText: "Password",
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                                _obsecure
                                                    ? CupertinoIcons.eye
                                                    : CupertinoIcons.eye_slash
                                            ),
                                            onPressed: ()
                                            {
                                                setState(()
                                                    {
                                                        _obsecure = !_obsecure;
                                                    });
                                            }
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15)
                                        )
                                    )
                                )
                            ),

                            SizedBox(height: 25),

                            ElevatedButton(
                                onPressed: _handleButton,
                                child: Text("Login")
                            ),

                            SizedBox(height: 15),

                            if (_message.isNotEmpty)
                            Text(
                                _message,
                                style: TextStyle(color: Colors.red)
                            )
                        ]
                    )
                )
                : SizedBox() // Prevent flicker
        );
    }
}