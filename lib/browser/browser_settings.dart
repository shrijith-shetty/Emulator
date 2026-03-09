import 'package:flutter/material.dart';

class BrowserSettings extends ChangeNotifier {
  bool _darkMode = false;
  bool _javascriptEnabled = true;
  bool _blockAds = false;
  String _searchEngine = 'google';
  String _homepage = 'https://google.com';

  // Getters
  bool get darkMode => _darkMode;
  bool get javascriptEnabled => _javascriptEnabled;
  bool get blockAds => _blockAds;
  String get searchEngine => _searchEngine;
  String get homepage => _homepage;

  // Setters with notification
  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  set javascriptEnabled(bool value) {
    _javascriptEnabled = value;
    notifyListeners();
  }

  set blockAds(bool value) {
    _blockAds = value;
    notifyListeners();
  }

  set searchEngine(String value) {
    _searchEngine = value;
    notifyListeners();
  }

  set homepage(String value) {
    _homepage = value;
    notifyListeners();
  }

  /// Get search URL based on selected search engine
  String getSearchUrl(String query) {
    final encodedQuery = Uri.encodeComponent(query);
    switch (_searchEngine) {
      case 'duckduckgo':
        return 'https://duckduckgo.com/?q=$encodedQuery';
      case 'bing':
        return 'https://www.bing.com/search?q=$encodedQuery';
      case 'yahoo':
        return 'https://search.yahoo.com/search?p=$encodedQuery';
      case 'google':
      default:
        return 'https://www.google.com/search?q=$encodedQuery';
    }
  }

  /// Reset all settings to defaults
  void resetToDefaults() {
    _darkMode = false;
    _javascriptEnabled = true;
    _blockAds = false;
    _searchEngine = 'google';
    _homepage = 'https://google.com';
    notifyListeners();
  }
}
