import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool darkMode = false;
  bool javascriptEnabled = true;
  bool blockAds = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Settings"),
      ),

      body: ListView(

        children: [

          /// Dark mode toggle
          SwitchListTile(
            title: const Text("Dark Mode"),

            value: darkMode,

            onChanged: (value) {

              setState(() {
                darkMode = value;
              });

            },
          ),

          /// Javascript toggle
          SwitchListTile(
            title: const Text("Enable JavaScript"),

            value: javascriptEnabled,

            onChanged: (value) {

              setState(() {
                javascriptEnabled = value;
              });

            },
          ),

          /// Ad blocker toggle
          SwitchListTile(
            title: const Text("Block Ads"),

            value: blockAds,

            onChanged: (value) {

              setState(() {
                blockAds = value;
              });

            },
          ),

          /// Clear history button
          ListTile(
            leading: const Icon(Icons.history),

            title: const Text("Clear History"),

            onTap: () {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("History cleared"),
                ),
              );

            },
          ),

          /// Clear bookmarks
          ListTile(
            leading: const Icon(Icons.bookmark),

            title: const Text("Clear Bookmarks"),

            onTap: () {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bookmarks cleared"),
                ),
              );

            },
          ),

        ],
      ),
    );
  }
}