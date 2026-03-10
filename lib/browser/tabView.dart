import 'package:emulator/browser/browser_screen.dart';
import 'package:emulator/browser/browser_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:emulator/browser/tab_manager.dart';

class TabView extends StatefulWidget
{
    final TabManager tabManager;
    final BrowserSettings browserSettings;

    const TabView({
        super.key,
        required this.tabManager,
        required this.browserSettings
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
                        appBar: AppBar(
                            title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    /// Add new tab
                                    IconButton(
                                        icon: const Icon(CupertinoIcons.plus_app_fill),
                                        onPressed: ()
                                        {
                                            setState(()
                                                {
                                                    widget.tabManager.addTab(
                                                        widget.browserSettings.homepage
                                                    );
                                                });
                                        }
                                    ),

                                    Stack(
                                        alignment: Alignment.center,
                                        children: [
                                            const Icon(CupertinoIcons.square),

                                            Text(
                                                "${widget.tabManager.tabs.length}",
                                                style: const TextStyle(fontSize: 15)
                                            )
                                        ]
                                    ),

                                    const Icon(Icons.more_vert)
                                ]
                            )
                        ),

                        body: GridView.builder(
                            padding: const EdgeInsets.all(10),

                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                    settings: widget.browserSettings
                                                )
                                            )
                                        );
                                    },

                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: widget.browserSettings.darkMode
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(12)
                                        ),

                                        child: Column(
                                            children: [
                                                Expanded(
                                                    child: Container(
                                                        color: widget.browserSettings.darkMode
                                                            ? Colors.black
                                                            : Colors.grey.shade200
                                                    )
                                                ),

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
                );
            }
        );
    }
}
