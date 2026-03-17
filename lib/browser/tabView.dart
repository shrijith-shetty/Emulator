import 'package:emulator/browser/browser_screen.dart';
import 'package:emulator/browser/browser_settings.dart';
import 'package:emulator/browser/settings.dart';
import 'package:emulator/browser/history_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:emulator/browser/tab_manager.dart';
import 'package:emulator/browser/history_manager.dart';
import 'package:emulator/browser/bookmark_manager.dart';

class TabView extends StatefulWidget
{
    final TabManager tabManager;
    final BrowserSettings browserSettings;
    final HistoryManager historyManager;
    final BookmarkManager bookmarkManager;

    const TabView({
        super.key,
        required this.tabManager,
        required this.browserSettings,
        required this.historyManager,
        required this.bookmarkManager
    });

    @override
    State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView>
{
    @override
    Widget build(BuildContext context) 
    {
        return ListenableBuilder(
            listenable: widget.browserSettings,
            builder: (context, child)
            {
                return Theme(
                    data: widget.browserSettings.darkMode
                        ? ThemeData.dark().copyWith(
                            appBarTheme: const AppBarTheme(
                                backgroundColor: Colors.black87
                            )
                        )
                        : ThemeData.light(),
                    child: Scaffold(
                        /// 🔹 APP BAR (ORIGINAL STYLE)
                        appBar: AppBar(
                            automaticallyImplyLeading: false,
                            title: Row(
                                children: [
                                    /// ➕ Add Tab
                                    IconButton(
                                        icon: const Icon(CupertinoIcons.plus_app_fill, size: 28),
                                        onPressed: ()
                                        {
                                            setState(()
                                                {
                                                    widget.tabManager
                                                        .addTab(widget.browserSettings.homepage);
                                                });
                                        }
                                    ),

                                    /// 🔥 CENTER TAB COUNT (FIXED WITH EXPANDED)
                                    Expanded(
                                        child: Center(
                                            child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                    const Icon(CupertinoIcons.square, size: 28),
                                                    Text(
                                                        "${widget.tabManager.tabs.length}",
                                                        style: const TextStyle(fontSize: 18)
                                                    )
                                                ]
                                            )
                                        )
                                    ),

                                    /// ☰ MENU (CLICKABLE FIXED)
                                    PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert),
                                        onSelected: (value) async
                                        {
                                            if (value == "settings") 
                                            {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => SettingsPage(
                                                            settings: widget.browserSettings,
                                                            historyManager: widget.historyManager,
                                                            bookmarkManager: widget.bookmarkManager
                                                        )
                                                    )
                                                );
                                            } else if (value == "history") 
                                            {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => HistoryPage(
                                                            historyManager: widget.historyManager,
                                                            browserSettings: widget.browserSettings
                                                        )
                                                    )
                                                );
                                            }
                                        },
                                        itemBuilder: (context) => const[
                                            PopupMenuItem(
                                                value: "history",
                                                child: Text("History")
                                            ),
                                            PopupMenuItem(
                                                value: "settings",
                                                child: Text("Settings")
                                            )
                                        ]
                                    )
                                ]
                            )
                        ),

                        /// 🔹 BODY
                        body: SafeArea(
                            child: GridView.builder(
                                padding: const EdgeInsets.all(10),
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.7
                                ),
                                itemCount: widget.tabManager.tabs.length,
                                itemBuilder: (context, index)
                                {
                                    final tab = widget.tabManager.tabs[index];

                                    return GestureDetector(
                                        onTap: ()
                                        {
                                            widget.tabManager.switchTab(index);

                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => BrowserScreen(
                                                        tabManager: widget.tabManager,
                                                        settings: widget.browserSettings, historyManager: widget.historyManager, bookmarkManager: widget.bookmarkManager,
                                                    )
                                                )
                                            );
                                        },

                                        /// 🔹 SIMPLE TAB CARD (ORIGINAL LOOK)
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: widget.browserSettings.darkMode
                                                    ? Colors.grey.shade800
                                                    : Colors.grey.shade300,
                                                borderRadius: BorderRadius.circular(12)
                                            ),
                                            child: Column(
                                                children: [
                                                    /// Preview Area
                                                    Expanded(
                                                        child: Container(
                                                            color: widget.browserSettings.darkMode
                                                                ? Colors.black
                                                                : Colors.grey.shade200
                                                        )
                                                    ),

                                                    /// Title
                                                    Padding(
                                                        padding: const EdgeInsets.all(8),
                                                        child: Text(
                                                            tab.title.isEmpty ? tab.url : tab.title,
                                                            style: TextStyle(
                                                                color: widget.browserSettings.darkMode
                                                                    ? Colors.white
                                                                    : Colors.black
                                                            ),
                                                            overflow: TextOverflow.ellipsis
                                                        )
                                                    ),

                                                    /// Close Button
                                                    IconButton(
                                                        icon: Icon(
                                                            Icons.close,
                                                            color: widget.browserSettings.darkMode
                                                                ? Colors.white
                                                                : Colors.black
                                                        ),
                                                        onPressed: ()
                                                        {
                                                            setState(()
                                                                {
                                                                    widget.tabManager.closeTab(index);
                                                                });
                                                        }
                                                    )
                                                ]
                                            )
                                        )
                                    );
                                }
                            )
                        )
                    )
                );
            }
        );
    }
}