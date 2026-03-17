import 'package:flutter/material.dart';
import 'browser_settings.dart';
import 'history_manager.dart';
import 'index.dart';
import 'webview_page.dart';

GlobalKey<HomePageState> widgetKey = GlobalKey<HomePageState>();

class HistoryPage extends StatefulWidget {

  final HistoryManager historyManager;
  final BrowserSettings browserSettings;

  const HistoryPage({
    super.key,
    required this.historyManager,
    required this.browserSettings,

  });


  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.browserSettings,
      builder: (context, child) {
        return Theme(
          data: widget.browserSettings.darkMode
              ? ThemeData.dark().copyWith(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black87,
            ),
          )
              : ThemeData.light(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("History"),

              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      widget.historyManager.clear();
                    });
                  },
                ),
              ],
            ),

            body: widget.historyManager.history.isEmpty
                ? const Center(child: Text("No history yet"))
                : ListView.builder(
              itemCount: widget.historyManager.history.length,

              itemBuilder: (context, index) {
                final url = widget.historyManager.history[index];

                return ListTile(
                  leading: const Icon(Icons.history),

                  title: Text(url),

                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        widget.historyManager.remove(url);
                      });
                    },
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewPage(
                          url: url,
                          settings: widget.browserSettings,
                          widgetKey: widgetKey,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
