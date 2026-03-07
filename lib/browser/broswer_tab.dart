import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BrowserTab
{

    String url;
    String title;

    InAppWebViewController? controller;

    BrowserTab({
        required this.url,
        this.title = ""
    });

}