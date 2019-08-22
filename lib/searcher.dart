mixin Searcher {
  Function(bool) get setSearchMode;
  Stream<bool> get isInSearchMode;
  Function(String) get onSearchQueryChanged;
  Stream<String> get searchQuery;
  Function get onClearSearchQuery => () => onSearchQueryChanged('');
}
