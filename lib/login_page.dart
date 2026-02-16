import 'package:emulator/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget
{
    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{

    final FlutterSecureStorage _storage = const FlutterSecureStorage();
    static const String _passwordKey = 'app_password_hash';

    bool _obsecure = true;
    String errorMsg = "";

    TextEditingController passwordController = TextEditingController();

    // HASH FUNCTION
    String _hashPassword(String password) 
    {
        var bytes = utf8.encode(password);
        var digest = sha256.convert(bytes);
        return digest.toString();
    }

    // VERIFY PASSWORD
    Future<bool> _verifyPassword(String inputPassword) async
    {
        String? storedHash = await _storage.read(key: _passwordKey);

        if (storedHash == null) return false;

        return storedHash == _hashPassword(inputPassword);
    }

    Future<void> _login() async
    {
        bool isCorrect = await _verifyPassword(passwordController.text.trim());

        if (isCorrect) 
        {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: "Jai"))
            );
        } else 
        {
            setState(()
                {
                    errorMsg = "Wrong Password ❌";
                });
            passwordController.clear();
        }
    }

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                        // PASSWORD FIELD
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                                height: 55,
                                child: TextField(
                                    controller: passwordController,
                                    obscureText: _obsecure,
                                    decoration: InputDecoration(
                                        filled: true,
                                        labelText: "Password",
                                        prefixIcon: const Icon(Icons.password),
                                        suffixIcon: IconButton(
                                            onPressed: ()
                                            {
                                                setState(()
                                                    {
                                                        _obsecure = !_obsecure;
                                                    });
                                            },
                                            icon: Icon(_obsecure
                                                    ? CupertinoIcons.eye
                                                    : CupertinoIcons.eye_slash)
                                        ),
                                        fillColor: Colors.red.shade100,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15))
                                    )
                                )
                            )
                        ),

                        const SizedBox(height: 25),

                        // SIGN IN BUTTON
                        ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(150, 50)),
                            child: const Text("Sign In")
                        ),

                        const SizedBox(height: 20),

                        Text(
                            errorMsg,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16)
                        )
                    ]
                )
            )
        );
    }
}
