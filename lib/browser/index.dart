import 'package:emulator/browser/history_manager.dart';
import 'package:emulator/browser/settings.dart';
import 'package:emulator/browser/tabView.dart';
import 'package:emulator/browser/webview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:emulator/browser/tab_manager.dart';
import 'tabView.dart' hide TabView;

class HomePage extends StatefulWidget
{
    const HomePage({super.key});

    @override
    State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
{
    HistoryManager historyManager = HistoryManager();
    TabManager tabManager = TabManager();
    List searchResult = [];
    bool isLoading = false;

    FocusNode searchFocus = FocusNode();
    bool isFocused = false;

    TextEditingController searchController = TextEditingController();

    @override
    void initState()
    {
        super.initState();

        searchFocus.addListener(()
            {
                setState(()
                    {
                        isFocused = searchFocus.hasFocus;
                    });
            });
    }

    void intoHomeScreen()
    {
        setState(()
            {
                searchResult = [];
                isFocused = false;
                isLoading = false;
                searchController.clear();
            });
        searchFocus.unfocus();
    }

    @override
    void dispose()
    {
        searchFocus.dispose();
        searchController.dispose();
        super.dispose();
    }
    void handleSearch(String query)
    {

        query = query.trim();

        /// If user typed a URL
        if (query.contains("."))
        {

            String url = query;

            if (!url.startsWith("http://") && !url.startsWith("https://"))
            {
                url = "https://$url";
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewPage(url: url)
                )
            );

        }

        /// Otherwise perform search
        else
        {
            search(query);
        }
    }
    @override
    Widget build(BuildContext context)
    {

        double screenHeight = MediaQuery.of(context).size.height;

        return Scaffold(

            appBar: AppBar(
                title: Row(
                    children: [

                        InkWell(
                            onTap: ()
                            {
                                intoHomeScreen();
                            },
                            child: const Icon(Icons.home_outlined)),

                        const Spacer(),

                        InkWell(
                            onTap: ()
                            {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabView(tabManager: tabManager)
                                    )
                                );
                            },
                            child: Stack(
                                alignment: Alignment.center,
                                children: const[
                                    Icon(CupertinoIcons.square),
                                    Text("1", style: TextStyle(fontSize: 15))
                                ]
                            )
                        ),

                        const SizedBox(width: 15),

                        PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),

                            onSelected: (value)
                            {

                                if (value == "settings") 
                                {

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const SettingsPage()
                                        )
                                    );

                                }

                            },

                            itemBuilder: (context) => [

                                const PopupMenuItem(
                                    value: "settings",
                                    child: Text("Settings")
                                )

                            ]
                        )

                    ]
                )
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
                                    height: 100
                                )
                            )
                        )
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

                                onSubmitted: (value)
                                {
                                    handleSearch(value);
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
                                            height: 24
                                        )
                                    ),

                                    fillColor: Colors.white10,
                                    filled: true,

                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide:
                                        BorderSide(color: Colors.grey.shade700)
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.blueAccent, width: 2)
                                    )
                                )
                            )
                        )
                    ),

                    /// SEARCH RESULTS
                    Positioned(
                        top: isFocused ? 80 : screenHeight * 0.6,
                        left: 0,
                        right: 0,
                        bottom: 0,

                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(

                                itemCount: searchResult.length,

                                itemBuilder: (context, index)
                                {

                                    final item = searchResult[index];

                                    if (item["FirstURL"] == null)
                                    {
                                        return const SizedBox();
                                    }

                                    return ListTile(

                                        title: Text(item["Text"] ?? ""),

                                        onTap: ()
                                        {

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                    WebViewPage(
                                                        url: item["FirstURL"])
                                                )
                                            );
                                        }
                                    );
                                }
                            )
                    )
                ]
            )
        );
    }

    /// SEARCH FUNCTION
    Future<void> search(String query) async
    {

        setState(()
            {
                isLoading = true;
            });

        final url = Uri.parse(
            "https://api.duckduckgo.com/?q=$query&format=json");

        final response = await http.get(url);

        if (response.statusCode == 200)
        {

            final data = jsonDecode(response.body);

            setState(()
                {
                    searchResult = data["RelatedTopics"];
                    isLoading = false;
                });

        } else
        {

            setState(()
                {
                    isLoading = false;
                });
        }
    }

}