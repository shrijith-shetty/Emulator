import 'package:emulator/browser/settings.dart';
import 'package:emulator/browser/history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'browser_settings.dart';
import 'index.dart';

class WebViewPage extends StatefulWidget
{
    final GlobalKey<HomePageState> widgetKey;
    final String url;
    final BrowserSettings settings;

    const WebViewPage({
        super.key,
        required this.url,
        required this.settings,
        required this.widgetKey
    });

    @override
    State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
{
    TextEditingController searchController = TextEditingController();
    InAppWebViewController? webViewController;

    double progress = 0;

    @override
    void initState() 
    {
        super.initState();
        widget.settings.addListener(_applyBrowserSettings);
        searchController.text = formattedUrl;
    }

    @override
    void dispose() 
    {
        widget.settings.removeListener(_applyBrowserSettings);
        searchController.dispose();
        super.dispose();
    }

    /// Ensure URL contains https
    String get formattedUrl 
    {
        if (widget.url.startsWith("http://") || widget.url.startsWith("https://")) 
        {
            return widget.url;
        }
        return "https://${widget.url}";
    }

    /// Ad blocker rules
    List<ContentBlocker> _getContentBlockers() 
    {
        if (!widget.settings.blockAds) 
        {
            return [];
        }

        return [
            ContentBlocker(
                trigger: ContentBlockerTrigger(
                    urlFilter: '.*',
                    resourceType: [
                        ContentBlockerTriggerResourceType.IMAGE,
                        ContentBlockerTriggerResourceType.STYLE_SHEET,
                        ContentBlockerTriggerResourceType.SCRIPT
                    ],
                    ifDomain: [
                        'doubleclick.net',
                        'googleadservices.com',
                        'googlesyndication.com',
                        'adservice.google.com',
                        'pagead2.googlesyndication.com',
                        'amazon-adsystem.com',
                        'ads.yahoo.com',
                        'adnxs.com',
                        'taboola.com',
                        'outbrain.com'
                    ]
                ),
                action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK)
            ),
            ContentBlocker(
                trigger: ContentBlockerTrigger(urlFilter: '.*ads.*'),
                action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK)
            ),
            ContentBlocker(
                trigger: ContentBlockerTrigger(urlFilter: '.*banner.*'),
                action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK)
            )
        ];
    }

    /// Apply browser settings dynamically
    Future<void> _applyBrowserSettings() async
    {
        final controller = webViewController;

        if (controller == null) 
        {
            if (mounted) 
            {
                setState(()
                    {});
            }
            return;
        }

        await controller.setSettings(
            settings: InAppWebViewSettings(
                javaScriptEnabled: widget.settings.javascriptEnabled,
                contentBlockers: _getContentBlockers()
            )
        );

        if (mounted) 
        {
            setState(()
                {});
        }
    }

    @override
    Widget build(BuildContext context) 
    {
        return ListenableBuilder(
            listenable: widget.settings,
            builder: (context, child) => Theme(
                data: widget.settings.darkMode
                    ? ThemeData.dark().copyWith(
                        appBarTheme:
                        const AppBarTheme(backgroundColor: Colors.black87)
                    )
                    : ThemeData.light(),
                child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                        title: Row(
                            children: [
                                Expanded(
                                    child: TextField(
                                        controller: searchController,
                                        decoration: InputDecoration(
                                            hintText: formattedUrl,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20)
                                            )
                                        ),
                                        onSubmitted: (value)
                                        {
                                            webViewController?.loadUrl(
                                                urlRequest: URLRequest(url: WebUri(value))
                                            );
                                        }
                                    )
                                ),

                                /// Popup Menu
                                PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) async
                                    {
                                        final homeState = widget.widgetKey.currentState;

                                        if (homeState == null) return;

                                        if (value == "settings") 
                                        {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => SettingsPage(
                                                        settings: homeState.browserSettings,
                                                        historyManager: homeState.historyManager,
                                                        bookmarkManager: homeState.bookmarkManager
                                                    )
                                                )
                                            );
                                        } else if (value == "history") 
                                        {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => HistoryPage(
                                                        historyManager: homeState.historyManager,
                                                        browserSettings: homeState.browserSettings
                                                    )
                                                )
                                            );
                                        }

                                        if (mounted) 
                                        {
                                            widget.widgetKey.currentState?.intoHomeScreen();
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

                    /// BODY
                    body: Column(
                        children: [
                            /// Loading Progress
                            progress < 1.0
                                ? LinearProgressIndicator(value: progress)
                                : const SizedBox(),

                            /// WebView
                            Expanded(
                                child: InAppWebView(
                                    initialUrlRequest: URLRequest(url: WebUri(formattedUrl)),
                                    initialSettings: InAppWebViewSettings(
                                        javaScriptEnabled: widget.settings.javascriptEnabled,
                                        contentBlockers: _getContentBlockers()
                                    ),
                                    onWebViewCreated: (controller)
                                    {
                                        webViewController = controller;
                                        _applyBrowserSettings();
                                    },
                                    onProgressChanged: (controller, progressValue)
                                    {
                                        setState(()
                                            {
                                                progress = progressValue / 100;
                                            });
                                    }
                                )
                            ),

                            /// Bottom Navigation
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

                                        /// Home
                                        IconButton(
                                            icon: const Icon(Icons.home),
                                            onPressed: ()
                                            {
                                                widget.widgetKey.currentState?.intoHomeScreen();
                                                Navigator.pop(context);
                                            }
                                        )
                                    ]
                                )
                            )
                        ]
                    )
                )
            )
        );
    }
}