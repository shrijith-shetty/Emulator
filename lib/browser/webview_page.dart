import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final bool javascriptEnabled;

  const WebViewPage({
    super.key,
    required this.url,
    this.javascriptEnabled = true,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;

  double progress = 0;

  /// Ensure URL contains https
  String get formattedUrl {
    if (widget.url.startsWith("http")) {
      return widget.url;
    } else {
      return "https://${widget.url}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formattedUrl, overflow: TextOverflow.ellipsis),
      ),

      body: Column(
        children: [
          /// Progress bar
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),

          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(formattedUrl)),

              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: widget.javascriptEnabled,
              ),

              onWebViewCreated: (controller) {
                webViewController = controller;
              },

              onProgressChanged: (controller, progressValue) {
                setState(() {
                  progress = progressValue / 100;
                });
              },
            ),
          ),

          /// Browser Navigation Controls
          Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
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

                /// Home
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.pop(context);
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
