import 'package:emulator/browser/bookmark_manager.dart';
import 'package:emulator/browser/browser_settings.dart';
import 'package:emulator/browser/history_manager.dart';
import 'package:emulator/browser/history_page.dart';
import 'package:emulator/browser/settings.dart';
import 'package:emulator/browser/tabView.dart';
import 'package:emulator/browser/webview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:emulator/browser/tab_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  HistoryManager historyManager = HistoryManager();
  BookmarkManager bookmarkManager = BookmarkManager();
  BrowserSettings browserSettings = BrowserSettings();
  TabManager tabManager = TabManager();
  List searchSuggestions = [];
  bool isLoadingSuggestions = false;

  FocusNode searchFocus = FocusNode();
  bool isFocused = false;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchFocus.addListener(() {
      setState(() {
        isFocused = searchFocus.hasFocus;
      });
    });
  }

  void intoHomeScreen() {
    setState(() {
      searchSuggestions = [];
      isFocused = false;
      isLoadingSuggestions = false;
      searchController.clear();
    });
    searchFocus.unfocus();
  }

  @override
  void dispose() {
    searchFocus.dispose();
    searchController.dispose();
    super.dispose();
  }

  void handleSearch(String query) {
    query = query.trim();
    if (query.isEmpty) return;

    String url;

    /// If user typed a URL
    if (query.contains(".") && !query.contains(" ")) {
      url = query;
      if (!url.startsWith("http://") && !url.startsWith("https://")) {
        url = "https://$url";
      }
    }
    /// Otherwise open search
    else {
      url = browserSettings.getSearchUrl(query);
    }

    historyManager.add(url);
    setState(() {
      searchSuggestions = [];
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          url: url,
          javascriptEnabled: browserSettings.javascriptEnabled,
        ),
      ),
    );
  }

  /// Fetch search suggestions while typing
  void fetchSuggestions(String query) async {
    query = query.trim();
    if (query.isEmpty) {
      setState(() {
        searchSuggestions = [];
      });
      return;
    }

    setState(() {
      isLoadingSuggestions = true;
    });

    try {
      final url = Uri.parse(
        "https://duckduckgo.com/ac/?q=${Uri.encodeComponent(query)}&type=list",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          searchSuggestions = data is List ? data : [];
          isLoadingSuggestions = false;
        });
      } else {
        setState(() {
          isLoadingSuggestions = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            InkWell(
              onTap: () {
                intoHomeScreen();
              },
              child: const Icon(Icons.home_outlined),
            ),

            const Spacer(),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabView(tabManager: tabManager),
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(CupertinoIcons.square),
                  Text(
                    "${tabManager.tabs.length}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 15),

            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),

              onSelected: (value) {
                if (value == "settings") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(
                        settings: browserSettings,
                        historyManager: historyManager,
                        bookmarkManager: bookmarkManager,
                      ),
                    ),
                  );
                } else if (value == "history") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HistoryPage(historyManager: historyManager),
                    ),
                  );
                }
              },

              itemBuilder: (context) => [
                const PopupMenuItem(value: "history", child: Text("History")),
                const PopupMenuItem(value: "settings", child: Text("Settings")),
              ],
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          /// GOOGLE LOGO
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: isFocused ? 0 : 1,
              duration: const Duration(milliseconds: 400),
              child: Center(
                child: Image.asset(
                  "assets/browser/google.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),

          /// SEARCH BAR
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,

            top: isFocused ? 10 : screenHeight * 0.12,
            left: 20,
            right: 20,

            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: TextField(
                controller: searchController,
                focusNode: searchFocus,

                onSubmitted: (value) {
                  handleSearch(value);
                },

                onChanged: (value) {
                  fetchSuggestions(value);
                },

                decoration: InputDecoration(
                  suffixIcon: const Icon(CupertinoIcons.mic),

                  labelText: "Search or Enter URL",
                  labelStyle: const TextStyle(color: Colors.blue),

                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      "assets/browser/google.png",
                      width: 24,
                      height: 24,
                    ),
                  ),

                  fillColor: Colors.white10,
                  filled: true,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade700),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// SEARCH SUGGESTIONS
          Positioned(
            top: isFocused ? 80 : screenHeight * 0.6,
            left: 0,
            right: 0,
            bottom: 0,

            child: isLoadingSuggestions
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: searchSuggestions.length,

              itemBuilder: (context, index) {
                final suggestion = searchSuggestions[index];
                final text = suggestion is Map
                    ? (suggestion["phrase"] ?? "")
                    : suggestion.toString();

                if (text.isEmpty) return const SizedBox();

                return ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(text),

                  onTap: () {
                    searchController.text = text;
                    handleSearch(text);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
