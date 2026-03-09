import 'package:flutter/material.dart';
import 'history_manager.dart';
import 'webview_page.dart';

class HistoryPage extends StatefulWidget {
  final HistoryManager historyManager;

  const HistoryPage({super.key, required this.historyManager});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  builder: (context) => WebViewPage(url: url),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
