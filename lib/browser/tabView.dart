import 'package:emulator/browser/browser_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:emulator/browser/tab_manager.dart';

class TabView extends StatefulWidget
{

  final TabManager tabManager;

  const TabView({super.key, required this.tabManager});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView>
{

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(

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
                          widget.tabManager.addTab("https://google.com");
                        });

                      }
                  ),

                  /// Tab counter
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
                            builder: (context) =>
                                BrowserScreen(tabManager: widget.tabManager)
                        )
                    );

                  },

                  child: Container(

                      decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(12)
                      ),

                      child: Column(
                          children: [

                            /// Preview area
                            Expanded(
                                child: Container(
                                    color: Colors.black
                                )
                            ),

                            /// Tab title
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                    tab.title.isEmpty ? tab.url : tab.title,
                                    style: const TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis
                                )
                            ),

                            /// Close tab button
                            IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),

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
    );
  }
}
