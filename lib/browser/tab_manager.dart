import 'package:emulator/browser/broswer_tab.dart';

class TabManager {

  List<BrowserTab> tabs = [
    BrowserTab(url: "https://google.com")
  ];

  int currentIndex = 0;

  BrowserTab get currentTab => tabs[currentIndex];

  void addTab(String url) {
    tabs.add(BrowserTab(url: url));
    currentIndex = tabs.length - 1;
  }

  void switchTab(int index) {
    currentIndex = index;
  }

  void closeTab(int index) {

    if (tabs.length == 1) return;

    tabs.removeAt(index);

    if (currentIndex >= tabs.length) {
      currentIndex = tabs.length - 1;
    }
  }
}