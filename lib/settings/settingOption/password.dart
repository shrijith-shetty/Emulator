import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Password extends StatefulWidget
{
    @override
    State<Password> createState() => _SecurePasswordManager();
}

class _SecurePasswordManager extends State<Password>
{
    final FlutterSecureStorage _storage = const FlutterSecureStorage();

    static const String _passwordKey = 'app_password_hash';

    bool _obsecOld = true;
    bool _obsecNew = true;

    String errorMsg = "";

    TextEditingController oldPassword = TextEditingController();
    TextEditingController newPassword = TextEditingController();

    // ================= HASH FUNCTION =================
    String _hashPassword(String password) 
    {
        var bytes = utf8.encode(password);
        var digest = sha256.convert(bytes);
        return digest.toString();
    }

    // ================= VERIFY PASSWORD =================
    Future<bool> _verifyPassword(String inputPassword) async
    {
        String? storedHash = await _storage.read(key: _passwordKey);
        if (storedHash == null) return false;

        return storedHash == _hashPassword(inputPassword);
    }

    // ================= CHANGE PASSWORD =================
    Future<void> _changePassword() async
    {
        String old = oldPassword.text.trim();
        String newPas = newPassword.text.trim();

        if (newPas.length < 4) 
        {
            setState(()
                {
                    errorMsg = "New Password must be at least 4 characters";
                });
            return;
        }

        if (old == newPas) 
        {
            setState(()
                {
                    errorMsg = "New Password must be different";
                });
            return;
        }

        bool isCorrect = await _verifyPassword(old);

        if (!isCorrect) 
        {
            setState(()
                {
                    errorMsg = "Old Password is incorrect";
                });
            return;
        }

        await _storage.write(
            key: _passwordKey, value: _hashPassword(newPas));

        setState(()
            {
                errorMsg = "Password changed successfully ✅";
            });

        Navigator.pop(context);
    }
    Future<void> clearAll() async {
      await _storage.deleteAll();
      print("All secure storage cleared");
    }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearAll();
  }
    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: InkWell(
                    onTap: ()
                    {
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings()));
                    },
                    child: const Icon(Icons.password_outlined,
                        size: 30, color: Colors.white)),
                title: const Text("Password",
                    style: TextStyle(fontSize: 25, color: Colors.white))),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        // ================= CHANGE BUTTON =================
                        InkWell(
                            onTap: ()
                            {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context)
                                    {
                                        return Container(
                                            padding: const EdgeInsets.all(20),
                                            height: 350,
                                            child: Column(
                                                children: [
                                                    const SizedBox(height: 20),

                                                    // OLD PASSWORD
                                                    TextField(
                                                        obscureText: _obsecOld,
                                                        controller: oldPassword,
                                                        decoration: InputDecoration(
                                                            suffixIcon: IconButton(
                                                                onPressed: ()
                                                                {
                                                                    setState(()
                                                                        {
                                                                            _obsecOld = !_obsecOld;
                                                                        });
                                                                },
                                                                icon: Icon(_obsecOld
                                                                        ? CupertinoIcons.eye
                                                                        : CupertinoIcons
                                                                            .eye_slash)),
                                                            labelText: "Enter Old Password",
                                                            filled: true,
                                                            prefixIcon: const Icon(
                                                                Icons.password_outlined),
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(20)))
                                                    ),

                                                    const SizedBox(height: 25),

                                                    // NEW PASSWORD
                                                    TextField(
                                                        obscureText: _obsecNew,
                                                        controller: newPassword,
                                                        decoration: InputDecoration(
                                                            suffixIcon: IconButton(
                                                                onPressed: ()
                                                                {
                                                                    setState(()
                                                                        {
                                                                            _obsecNew = !_obsecNew;
                                                                        });
                                                                },
                                                                icon: Icon(_obsecNew
                                                                        ? CupertinoIcons.eye
                                                                        : CupertinoIcons
                                                                            .eye_slash)),
                                                            labelText: "Enter New Password",
                                                            filled: true,
                                                            prefixIcon: const Icon(
                                                                Icons.lock_outline),
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(20)))
                                                    ),

                                                    const SizedBox(height: 30),

                                                    ElevatedButton(
                                                        onPressed: _changePassword,
                                                        child: const Text("Change Password")
                                                    )
                                                ]
                                            )
                                        );
                                    });
                            },
                            child: Container(
                                height: 50,
                                width: 170,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Center(
                                    child: Text("Change Password",
                                        style: TextStyle(color: Colors.white)))
                            )
                        ),

                        const SizedBox(height: 30),

                        Text(errorMsg,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black))
                    ]
                )
            )
        );
    }
}
