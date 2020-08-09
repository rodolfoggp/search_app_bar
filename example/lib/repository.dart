import 'package:dio/dio.dart';
import 'package:search_test/user.dart';

class Repository {
  final _dio = Dio();

  Future<List<User>> fetchUsers() async {
    final result = await _dio.get('https://jsonplaceholder.typicode.com/users');

    return (result.data as List).map((e) => User.fromJson(e)).toList();
  }
}
