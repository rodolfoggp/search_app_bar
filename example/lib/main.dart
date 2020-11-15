import 'package:flutter/material.dart';
import 'package:search_app_bar/search_app_bar.dart';
import 'package:search_test/user.dart';

import 'store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search App Bar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Search App Bar Demo',
        store: Store(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final Store store;

  MyHomePage({
    this.title,
    this.store,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: SearchAppBar(
          title: Text(title),
          searcher: store,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: StreamBuilder<List<User>>(
          stream: store.usersStream,
          builder: (context, snapshot) {
            final list = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(list[index].name),
                );
              },
              itemCount: list?.length,
            );
          },
        ),
      );
}
