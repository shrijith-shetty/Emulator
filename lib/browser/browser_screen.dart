import 'package:emulator/browser/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:emulator/browser/browser_settings.dart';
import 'package:emulator/browser/tab_manager.dart';

import 'bookmark_manager.dart';
import 'history_manager.dart';
import 'history_page.dart';

class BrowserScreen extends StatefulWidget
{
    final TabManager tabManager;
    final BrowserSettings settings;
    final HistoryManager historyManager;     // ✅ ADD THIS
    final BookmarkManager bookmarkManager;

    const BrowserScreen({
        super.key,
        required this.tabManager,
        required this.settings,
      required this.historyManager,          // ✅ ADD
        required this.bookmarkManager
    });

    @override
    State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen>
{
    InAppWebViewController? webViewController;
    final TextEditingController searchController = TextEditingController();
    double progress = 0;

    /// Format URL
    String formatUrl(String url)
    {
        if (url.startsWith("http://") || url.startsWith("https://"))
        {
            return url;
        }
        return "https://$url";
    }

    /// Ad Blocker
    List<ContentBlocker> _getContentBlockers()
    {
        if (!widget.settings.blockAds) return [];

        return [
            ContentBlocker(
                trigger: ContentBlockerTrigger(
                    urlFilter: ".*",
                    resourceType: [
                        ContentBlockerTriggerResourceType.IMAGE,
                        ContentBlockerTriggerResourceType.STYLE_SHEET,
                        ContentBlockerTriggerResourceType.SCRIPT
                    ],
                    ifDomain: [
                        "doubleclick.net",
                        "googleadservices.com",
                        "googlesyndication.com",
                        "amazon-adsystem.com",
                        "adnxs.com",
                        "taboola.com",
                        "outbrain.com"
                    ]
                ),
                action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK)
            ),
            ContentBlocker(
                trigger: ContentBlockerTrigger(urlFilter: ".*ads.*"),
                action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK)
            )
        ];
    }

    @override
    Widget build(BuildContext context)
    {
        final tab = widget.tabManager.currentTab;

        /// Set URL in search bar
        searchController.text = tab.url;

        return ListenableBuilder(
            listenable: widget.settings,
            builder: (context, child)
            {
                return Theme(
                    data: widget.settings.darkMode
                        ? ThemeData.dark().copyWith(
                            appBarTheme: const AppBarTheme(

                                backgroundColor: Colors.black87
                            )
                        )
                        : ThemeData.light(),
                    child: Scaffold(
                        /// 🔹 APP BAR (FIXED SEARCH BAR)
                        appBar: AppBar(
                            automaticallyImplyLeading: false, // ❌ remove back arrow

                            title: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                    hintText: "Search or enter URL",
                                    filled: true,
                                    fillColor: widget.settings.darkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide.none
                                    )
                                ),
                                onSubmitted: (value)
                                {
                                    final url = formatUrl(value);
                                    webViewController?.loadUrl(
                                        urlRequest: URLRequest(url: WebUri(url))
                                    );
                                }
                            ),

                            /// 🔥 RIGHT MENU (ONLY 2 OPTIONS)
                            actions: [
                                PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),

                                    onSelected: (value) async
                                    {
                                        if (value == "history")
                                        {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => HistoryPage(
                                                        historyManager: widget.historyManager,
                                                        browserSettings: widget.settings
                                                    )
                                                )
                                            );
                                        } else if (value == "settings")
                                        {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => SettingsPage(
                                                        settings: widget.settings,
                                                        historyManager: widget.historyManager,
                                                        bookmarkManager: widget.bookmarkManager
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
                        ),

                        /// 🔹 BODY
                        body: Column(
                            children: [
                                /// Progress Bar
                                progress < 1.0
                                    ? LinearProgressIndicator(value: progress)
                                    : const SizedBox(),

                                /// WebView
                                Expanded(
                                    child: InAppWebView(
                                        initialUrlRequest: URLRequest(
                                            url: WebUri(formatUrl(tab.url))
                                        ),
                                        initialSettings: InAppWebViewSettings(
                                            javaScriptEnabled:
                                            widget.settings.javascriptEnabled,
                                            contentBlockers: _getContentBlockers()
                                        ),
                                        onWebViewCreated: (controller)
                                        {
                                            webViewController = controller;
                                            tab.controller = controller;
                                        },
                                        onProgressChanged: (controller, progressValue)
                                        {
                                            setState(()
                                                {
                                                    progress = progressValue / 100;
                                                });
                                        },
                                        onLoadStop: (controller, url) async
                                        {
                                            if (url != null)
                                            {
                                                setState(()
                                                    {
                                                        tab.url = url.toString();
                                                        searchController.text = tab.url;
                                                    });
                                            }

                                            final title = await controller.getTitle();
                                            if (title != null && title.isNotEmpty)
                                            {
                                                setState(()
                                                    {
                                                        tab.title = title;
                                                    });
                                            }
                                        }
                                    )
                                ),

                                /// 🔹 NAVIGATION BAR
                                Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(color: Colors.grey.shade300)
                                        )
                                    ),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                            /// Back
                                            IconButton(
                                                icon: const Icon(Icons.arrow_back),
                                                onPressed: () async
                                                {
                                                    if (webViewController != null &&
                                                        await webViewController!.canGoBack())
                                                    {
                                                        webViewController!.goBack();
                                                    }
                                                }
                                            ),

                                            /// Forward
                                            IconButton(
                                                icon: const Icon(Icons.arrow_forward),
                                                onPressed: () async
                                                {
                                                    if (webViewController != null &&
                                                        await webViewController!.canGoForward())
                                                    {
                                                        webViewController!.goForward();
                                                    }
                                                }
                                            ),

                                            /// Reload
                                            IconButton(
                                                icon: const Icon(Icons.refresh),
                                                onPressed: ()
                                                {
                                                    webViewController?.reload();
                                                }
                                            ),

                                            /// Tabs (go back to TabView)
                                            IconButton(
                                                icon: const Icon(Icons.home),
                                                onPressed: ()
                                                {
                                                    Navigator.pop(context);
                                                }
                                            )
                                        ]
                                    )
                                )
                            ]
                        )
                    )
                );
            }
        );
    }
}