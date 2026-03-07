import 'package:flutter/material.dart';
import 'history_manager.dart';
import 'webview_page.dart';

class HistoryPage extends StatelessWidget
{

    final HistoryManager historyManager;

    const HistoryPage({super.key, required this.historyManager});

    @override
    Widget build(BuildContext context) 
    {

        return Scaffold(

            appBar: AppBar(
                title: const Text("History"),

                actions: [

                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: ()
                        {

                            historyManager.clear();
                            Navigator.pop(context);

                        }
                    )
                ]
            ),

            body: ListView.builder(

                itemCount: historyManager.history.length,

                itemBuilder: (context, index)
                {

                    final url = historyManager.history[index];

                    return ListTile(

                        leading: const Icon(Icons.history),

                        title: Text(url),

                        onTap: ()
                        {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebViewPage(url: url)
                                )
                            );

                        }
                    );
                }
            )
        );
    }
}