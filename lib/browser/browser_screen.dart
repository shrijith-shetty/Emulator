import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:emulator/browser/browser_settings.dart';
import 'tab_manager.dart';

class BrowserScreen extends StatefulWidget
{
    final TabManager tabManager;
    final BrowserSettings settings;

    const BrowserScreen({
        super.key,
        required this.tabManager,
        required this.settings
    });

    @override
    State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen>
{
    InAppWebViewController? webViewController;

    double progress = 0;

    /// Ensure URL contains https
    String formatUrl(String url) 
    {
        if (url.startsWith("http")) 
        {
            return url;
        } else 
        {
            return "https://$url";
        }
    }

    /// Get content blockers for ad blocking
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
                        "adservice.google.com",
                        "pagead2.googlesyndication.com",
                        "amazon-adsystem.com",
                        "ads.yahoo.com",
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
            ),
            ContentBlocker(
                trigger: ContentBlockerTrigger(urlFilter: ".*banner.*"),
                action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK)
            )
        ];
    }

    @override
    Widget build(BuildContext context) 
    {
        final tab = widget.tabManager.currentTab;

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
                        appBar: AppBar(
                            title: Text(tab.url, overflow: TextOverflow.ellipsis)
                        ),

                        body: Column(
                            children: [
                                /// Progress bar
                                progress < 1.0
                                    ? LinearProgressIndicator(value: progress)
                                    : const SizedBox(),

                                Expanded(
                                    child: InAppWebView(
                                        initialUrlRequest: URLRequest(
                                            url: WebUri(formatUrl(tab.url))
                                        ),

                                        initialSettings: InAppWebViewSettings(
                                            javaScriptEnabled: widget.settings.javascriptEnabled,
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

                                /// Navigation controls
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
