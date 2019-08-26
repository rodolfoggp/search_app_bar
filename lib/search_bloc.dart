import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search_app_bar/searcher.dart';

import 'filter.dart';

class SearchBloc<T> extends BlocBase {
  final Searcher searcher;
  Filter<T> filter;

  final _isInSearchMode = BehaviorSubject<bool>();
  final _searchQuery = BehaviorSubject<String>();

  ///
  /// Inputs
  ///
  get onSearchQueryChanged => _searchQuery.add;

  get setSearchMode => _isInSearchMode.add;

  Function get onClearSearchQuery => () => onSearchQueryChanged('');

  ///
  /// Outputs
  ///
  Stream<bool> get isInSearchMode => _isInSearchMode.stream;

  Stream<String> get searchQuery => _searchQuery.stream;

  ///
  /// Constructor
  ///
  SearchBloc({
    @required this.searcher,
    this.filter,
  }) {
    _configureFilter();
    searchQuery.listen((query) {
      final List<T> filtered = searcher.data.where((test) => filter(test, query)).toList();
      searcher.onDataFiltered(filtered);
    });
  }

  _configureFilter() {
    if (filter == null) {
      if (T == String) {
        filter = _defaultFilter;
      } else {
        throw (Exception(
            'If data is not a List of Strings, a filter function must be provided for SearchAppBar!'));
      }
    }
  }

  Filter get _defaultFilter => Filters.startsWith;

  @override
  void dispose() {
    _isInSearchMode.close();
    _searchQuery.close();
    super.dispose();
  }
}
