import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'tab_manager.dart';

class BrowserScreen extends StatefulWidget {

  final TabManager tabManager;

  const BrowserScreen({super.key, required this.tabManager});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {

  InAppWebViewController? webViewController;

  double progress = 0;

  @override
  Widget build(BuildContext context) {

    final tab = widget.tabManager.currentTab;

    return Scaffold(

      appBar: AppBar(
        title: Text(
          tab.url,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      body: Column(
        children: [

          /// Progress bar
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : const SizedBox(),

          Expanded(

            child: InAppWebView(

              initialUrlRequest:
              URLRequest(url: WebUri(tab.url)),

              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
              ),

              onWebViewCreated: (controller) {
                webViewController = controller;
                tab.controller = controller;
              },

              onProgressChanged: (controller, progressValue) {

                setState(() {
                  progress = progressValue / 100;
                });

              },

            ),

          ),

          /// Navigation controls
          Container(

            height: 55,

            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [

                /// Back
                IconButton(
                  icon: const Icon(Icons.arrow_back),

                  onPressed: () async {

                    if (webViewController != null &&
                        await webViewController!.canGoBack()) {
                      webViewController!.goBack();
                    }

                  },
                ),

                /// Forward
                IconButton(
                  icon: const Icon(Icons.arrow_forward),

                  onPressed: () async {

                    if (webViewController != null &&
                        await webViewController!.canGoForward()) {
                      webViewController!.goForward();
                    }

                  },
                ),

                /// Reload
                IconButton(
                  icon: const Icon(Icons.refresh),

                  onPressed: () {
                    webViewController?.reload();
                  },
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}