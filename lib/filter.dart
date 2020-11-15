import 'package:diacritic/diacritic.dart';

typedef bool Filter<T>(T test, String query);

typedef bool FilterFields<T>(List<T> test, String query);

class Filters {
  /// returns if [test] starts with the given [query],
  /// disregarding lower/upper case and diacritics.
  static Filter<String> startsWith = (test, query) {
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query);
    return realTest.startsWith(realQuery);
  };

  /// returns if [test] is exactly the same as [query],
  /// disregarding lower/upper case and diacritics.
  static Filter<String> equals = (test, query) {
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query);
    return realTest == realQuery;
  };

  /// returns if [test] contains the given [query],
  /// disregarding lower/upper case and diacritics.
  static Filter<String> contains = (test, query) {
    final realTest = _prepareString(test);
    final realQuery = _prepareString(query);
    return realTest.contains(realQuery);
  };

  /// returns if [test] array contains the given [query],
  /// disregarding lower/upper case and diacritics.
  static FilterFields<String> containsInFields = (test, query) {
    final realTest1 = test.map((e) => _prepareString(e));
    final realQuery = _prepareString(query);
    return realTest1.any((element) => element.contains(realQuery));
  };

  static String _prepareString(String string) =>
      removeDiacritics(string != null ? string : '')?.toLowerCase();
}
