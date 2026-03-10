import 'package:flutter/material.dart';
import 'browser_settings.dart';
import 'history_manager.dart';
import 'bookmark_manager.dart';

class SettingsPage extends StatefulWidget
{
    final BrowserSettings settings;
    final HistoryManager historyManager;
    final BookmarkManager bookmarkManager;

    const SettingsPage({
        super.key,
        required this.settings,
        required this.historyManager,
        required this.bookmarkManager
    });

    @override
    State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
{
    @override
    Widget build(BuildContext context) 
    {
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
                        appBar: AppBar(title: const Text("Settings")),
                        body: ListView(
                            children: [
                                /// Dark mode toggle
                                SwitchListTile(
                                    title: const Text("Dark Mode"),
                                    subtitle: const Text("Enable dark theme for the browser"),
                                    value: widget.settings.darkMode,
                                    onChanged: (value)
                                    {
                                        widget.settings.darkMode = value;
                                    }
                                ),

                                const Divider(),

                                /// Javascript toggle
                                SwitchListTile(
                                    title: const Text("Enable JavaScript"),
                                    subtitle: const Text("Allow websites to run JavaScript"),
                                    value: widget.settings.javascriptEnabled,
                                    onChanged: (value)
                                    {
                                        widget.settings.javascriptEnabled = value;
                                    }
                                ),

                                /// Ad blocker toggle
                                SwitchListTile(
                                    title: const Text("Block Ads"),
                                    subtitle: const Text("Block advertisements on websites"),
                                    value: widget.settings.blockAds,
                                    onChanged: (value)
                                    {
                                        widget.settings.blockAds = value;
                                    }
                                ),

                                const Divider(),

                                /// Search engine selection
                                ListTile(
                                    leading: const Icon(Icons.search),
                                    title: const Text("Search Engine"),
                                    subtitle: Text(
                                        _getSearchEngineName(widget.settings.searchEngine)
                                    ),
                                    onTap: () => _showSearchEngineDialog()
                                ),

                                /// Homepage setting
                                ListTile(
                                    leading: const Icon(Icons.home),
                                    title: const Text("Homepage"),
                                    subtitle: Text(widget.settings.homepage),
                                    onTap: () => _showHomepageDialog()
                                ),

                                const Divider(),

                                /// Clear history button
                                ListTile(
                                    leading: const Icon(Icons.history),
                                    title: const Text("Clear History"),
                                    subtitle: Text(
                                        "${widget.historyManager.history.length} items"
                                    ),
                                    onTap: () => _confirmClearHistory()
                                ),

                                /// Clear bookmarks
                                ListTile(
                                    leading: const Icon(Icons.bookmark),
                                    title: const Text("Clear Bookmarks"),
                                    subtitle: Text(
                                        "${widget.bookmarkManager.bookmarks.length} items"
                                    ),
                                    onTap: () => _confirmClearBookmarks()
                                ),

                                const Divider(),

                                /// Reset settings
                                ListTile(
                                    leading: const Icon(Icons.restore),
                                    title: const Text("Reset to Defaults"),
                                    subtitle: const Text(
                                        "Restore all settings to default values"
                                    ),
                                    onTap: () => _confirmResetSettings()
                                )
                            ]
                        )
                    )
                );
            }
        );
    }

    String _getSearchEngineName(String engine) 
    {
        switch (engine)
        {
            case 'google':
                return 'Google';
            case 'duckduckgo':
                return 'DuckDuckGo';
            case 'bing':
                return 'Bing';
            case 'yahoo':
                return 'Yahoo';
            default:
            return 'Google';
        }
    }

    void _showSearchEngineDialog() 
    {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text("Select Search Engine"),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        _searchEngineOption('google', 'Google'),
                        _searchEngineOption('duckduckgo', 'DuckDuckGo'),
                        _searchEngineOption('bing', 'Bing'),
                        _searchEngineOption('yahoo', 'Yahoo')
                    ]
                )
            )
        );
    }

    Widget _searchEngineOption(String value, String label) 
    {
        return RadioListTile<String>(
            title: Text(label),
            value: value,
            groupValue: widget.settings.searchEngine,
            onChanged: (newValue)
            {
                setState(()
                    {
                        widget.settings.searchEngine = newValue!;
                    });
                Navigator.pop(context);
            }
        );
    }

    void _showHomepageDialog() 
    {
        final controller = TextEditingController(text: widget.settings.homepage);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text("Set Homepage"),
                content: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        labelText: "Homepage URL",
                        hintText: "https://google.com"
                    ),
                    keyboardType: TextInputType.url
                ),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")
                    ),
                    TextButton(
                        onPressed: ()
                        {
                            String url = controller.text.trim();
                            if (url.isNotEmpty) 
                            {
                                if (!url.startsWith("http://") && !url.startsWith("https://")) 
                                {
                                    url = "https://$url";
                                }
                                setState(()
                                    {
                                        widget.settings.homepage = url;
                                    });
                            }
                            Navigator.pop(context);
                        },
                        child: const Text("Save")
                    )
                ]
            )
        );
    }

    void _confirmClearHistory() 
    {
        showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
                title: const Text("Clear History"),
                content: const Text(
                    "Are you sure you want to clear all browsing history?"
                ),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text("Cancel")
                    ),
                    TextButton(
                        onPressed: ()
                        {
                            widget.historyManager.clear();
                            Navigator.pop(dialogContext);
                            setState(()
                                {});
                            ScaffoldMessenger.of(
                                context
                            ).showSnackBar(const SnackBar(content: Text("History cleared")));
                        },
                        child: const Text("Clear", style: TextStyle(color: Colors.red))
                    )
                ]
            )
        );
    }

    void _confirmClearBookmarks() 
    {
        showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
                title: const Text("Clear Bookmarks"),
                content: const Text("Are you sure you want to clear all bookmarks?"),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text("Cancel")
                    ),
                    TextButton(
                        onPressed: ()
                        {
                            widget.bookmarkManager.clearBookmarks();
                            Navigator.pop(dialogContext);
                            setState(()
                                {});
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Bookmarks cleared"))
                            );
                        },
                        child: const Text("Clear", style: TextStyle(color: Colors.red))
                    )
                ]
            )
        );
    }

    void _confirmResetSettings() 
    {
        showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
                title: const Text("Reset Settings"),
                content: const Text(
                    "Are you sure you want to reset all settings to defaults?"
                ),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text("Cancel")
                    ),
                    TextButton(
                        onPressed: ()
                        {
                            widget.settings.resetToDefaults();
                            Navigator.pop(dialogContext);
                            setState(()
                                {});
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Settings reset to defaults"))
                            );
                        },
                        child: const Text("Reset", style: TextStyle(color: Colors.red))
                    )
                ]
            )
        );
    }
}
