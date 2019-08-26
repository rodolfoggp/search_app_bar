import 'dart:core';

abstract class Searcher<T> {
  Function(List<T>) get onDataFiltered;
  List<T> get data;
}
