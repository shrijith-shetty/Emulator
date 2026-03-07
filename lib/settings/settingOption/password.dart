import 'package:emulator/database/isPasswordRequeired.dart';
import 'package:emulator/database/password.dart';
import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Password extends StatefulWidget
{
    @override
    State<Password> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<Password>
{
    final PasswordStorage _authService = PasswordStorage();
    final IsPasswordRequired _isRequired = IsPasswordRequired();

    bool _isPasswordSet = false;
    bool _isEnabled = false;
    bool _obsecOld = true;
    bool _obsecNew = true;
    String errorMsg = "";

    final TextEditingController oldPassword = TextEditingController();
    final TextEditingController newPassword = TextEditingController();

    @override
    void initState() 
    {
        super.initState();
        _loadData();
    }

    Future<void> _loadData() async
    {
        bool passwordSet = await _authService.isPasswordSet();
        bool required = await _isRequired.isPasswordRequired();

        setState(()
            {
                _isPasswordSet = passwordSet;
                _isEnabled = required;
            });
    }

    Future<void> changePassword() async
    {
        String oldPass = oldPassword.text.trim();
        String newPass = newPassword.text.trim();

        _isPasswordSet = await _authService.isPasswordSet();

        /// CASE 1: Protection enabled AND password already exists
        if (_isEnabled && _isPasswordSet) 
        {

            if (oldPass.isEmpty || newPass.isEmpty) 
            {
                setState(() => errorMsg = "All fields required");
                return;
            }

            if (newPass.length < 4) 
            {
                setState(() => errorMsg = "Password must be at least 4 digits");
                return;
            }

            bool valid = await _authService.verifyPassword(oldPass);
            if (!valid) 
            {
                setState(() => errorMsg = "Old password incorrect");
                return;
            }

            await _authService.setPassword(newPass);
            setState(() => errorMsg = "Password changed successfully");
        }

        /// CASE 2: Protection enabled BUT no password exists
        else if (_isEnabled && !_isPasswordSet) 
        {

            if (newPass.isEmpty) 
            {
                setState(() => errorMsg = "Enter new password");
                return;
            }

            if (newPass.length < 4) 
            {
                setState(() => errorMsg = "Password must be at least 4 digits");
                return;
            }

            await _authService.setPassword(newPass);
            setState(() => errorMsg = "Password created successfully");
        }

        await _loadData();
    }

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
                backgroundColor: Colors.black,
                leading: InkWell(
                    onTap: ()
                    {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Settings())
                        );
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white)
                ),
                title: Text(
                    "Password",
                    style: TextStyle(color: Colors.white, fontSize: 24)
                )
            ),
            body: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                        /// SWITCH
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                    "Enable Password",
                                    style: TextStyle(fontSize: 20, color: Colors.white)
                                ),
                                Switch(
                                    value: _isEnabled,
                                    onChanged: (value) async
                                    {
                                        setState(() => _isEnabled = value);
                                        await _isRequired.setIsPasswordRequired(value);

                                        if (!value) 
                                        {
                                            await _authService.deletePassword();

                                            setState(()
                                                {
                                                    errorMsg = "Password protection disabled & deleted";
                                                });
                                        } else 
                                        {
                                            setState(()
                                                {
                                                    errorMsg = "";
                                                });
                                        }

                                        await _loadData();
                                    }
                                )
                            ]
                        ),

                        SizedBox(height: 40),

                        /// CHANGE PASSWORD BUTTON
                        InkWell(
                            onTap: _isEnabled
                                ? ()
                                {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => _buildBottomSheet()
                                    );
                                }
                                : null,
                            child: Text(
                                "Change Password",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: _isEnabled ? Colors.white : Colors.grey
                                )
                            )
                        ),

                        SizedBox(height: 30),

                        if (errorMsg.isNotEmpty)
                        Text(
                            errorMsg,
                            style: TextStyle(color: Colors.greenAccent)
                        )
                    ]
                )
            )
        );
    }

    /// ================= BOTTOM SHEET =================
    Widget _buildBottomSheet() 
    {
        return Container(
            height: 750,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Color(0xFF121212),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25)
                )
            ),
            child: Column(
                children: [

                    Container(
                        height: 5,
                        width: 50,
                        margin: EdgeInsets.only(bottom: 25),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),

                    Text(
                        "Change Password",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )
                    ),

                    SizedBox(height: 30),

                    /// SHOW OLD PASSWORD ONLY IF IT EXISTS
                    if (_isEnabled && _isPasswordSet)
                    Column(
                        children: [
                            TextField(
                                controller: oldPassword,
                                obscureText: _obsecOld,
                                style: TextStyle(color: Colors.white),
                                decoration: _passwordDecoration(
                                    label: "Old Password",
                                    obscure: _obsecOld,
                                    toggle: ()
                                    {
                                        setState(() => _obsecOld = !_obsecOld);
                                    }
                                )
                            ),
                            SizedBox(height: 20)
                        ]
                    ),

                    /// NEW PASSWORD (Always required when enabled)
                    TextField(
                        controller: newPassword,
                        obscureText: _obsecNew,
                        style: TextStyle(color: Colors.white),
                        decoration: _passwordDecoration(
                            label: "New Password",
                            obscure: _obsecNew,
                            toggle: ()
                            {
                                setState(() => _obsecNew = !_obsecNew);
                            }
                        )
                    ),

                    SizedBox(height: 30),

                    SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                )
                            ),
                            onPressed: () async
                            {
                                await changePassword();
                                Navigator.pop(context);
                                oldPassword.clear();
                                newPassword.clear();
                            },
                            child: Text("Save")
                        )
                    )
                ]
            )
        );
    }

    InputDecoration _passwordDecoration({
        required String label,
        required bool obscure,
        required VoidCallback toggle
    }) 
    {
        return InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Color(0xFF1E1E1E),
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
            suffixIcon: IconButton(
                icon: Icon(
                    obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                    color: Colors.grey
                ),
                onPressed: toggle
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade700)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2)
            )
        );
    }
}