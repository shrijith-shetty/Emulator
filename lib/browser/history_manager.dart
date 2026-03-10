class HistoryManager
{

  List<String> history = [];

  /// Add new history entry
  void add(String url)
  {

    if (url.isEmpty) return;

    /// remove duplicate
    history.remove(url);

    /// add to top
    history.insert(0, url);

    /// optional limit (last 100 items)
    if (history.length > 100)
    {
      history.removeLast();
    }
  }

  /// Remove one item
  void remove(String url)
  {

    history.remove(url);

  }

  /// Clear entire history
  void clear()
  {

    history.clear();

  }

  /// Get latest visited page
  String? latest()
  {

    if (history.isEmpty) return null;

    return history.first;
  }

}