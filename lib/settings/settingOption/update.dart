import 'package:emulator/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => UpdatePage();
}

class UpdatePage extends State<Update> {
  String check = "Check for updates"; // ✅ MOVE HERE

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () => Navigator.pop(context), // ✅ go back
          child: const Icon(Icons.update, size: 30, color: Colors.white),
        ),
        title: const Text(
          "Update",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "System update",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Protect your device from security threats and get the latest android features",
              style: TextStyle(fontSize: 10),
            ),
            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 400,
                height: 80,
                color: Colors.black54,
                child: Row(
                  children: const [
                    Icon(Icons.check, color: Colors.white, size: 30),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Update status",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          "Your system has been updated to v234v-39-28-5",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          "On 19 December 2025",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(CupertinoIcons.check_mark_circled, size: 30),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    setState(() {
                      check = "No updates found"; // ✅ NOW WORKS
                    });
                  },
                  child: Text(
                    check,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
