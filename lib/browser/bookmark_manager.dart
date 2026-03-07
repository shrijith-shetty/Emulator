class BookmarkManager {

  List<String> bookmarks = [];

  /// Add bookmark
  void addBookmark(String url) {

    if (!bookmarks.contains(url)) {
      bookmarks.add(url);
    }

  }

  /// Remove bookmark
  void removeBookmark(String url) {

    bookmarks.remove(url);

  }

  /// Check if bookmarked
  bool isBookmarked(String url) {

    return bookmarks.contains(url);

  }

  /// Clear all bookmarks
  void clearBookmarks() {

    bookmarks.clear();

  }

}