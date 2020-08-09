import 'package:dio/dio.dart';
import 'package:rxdart/subjects.dart';
import 'package:search_app_bar/searcher.dart';
import 'package:search_test/repository.dart';
import 'package:search_test/user.dart';

class Store implements Searcher<String> {
  Store() {
    _fetchUsers();
    _filter.listen((_) => _filterUsers());
  }

  final _repository = Repository();
  List<User> _users = [];
  final _filteredUsers = BehaviorSubject<List<User>>.seeded([]);
  final _filter = BehaviorSubject<String>.seeded('');

  Stream<List<User>> get usersStream => _filteredUsers.stream;

  Future<void> _fetchUsers() async {
    try {
      _users = await _repository.fetchUsers();
      _filterUsers();
    } on DioError catch (e) {
      _filteredUsers.addError(e);
    }
  }

  void _filterUsers() {
    _filteredUsers.add(_users
        .where((user) =>
            user.name.toLowerCase().contains(_filter.value.toLowerCase()))
        .toList());
  }

  Function(String) get filter => (value) {
        _filter.add(value);
      };

  @override
  String Function(String filter) get onFiltering => filter;
}
