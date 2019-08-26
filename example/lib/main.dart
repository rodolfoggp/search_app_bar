import 'package:flutter/material.dart';
import 'package:search_app_bar/filter.dart';
import 'package:search_app_bar/search_app_bar.dart';

import 'home_bloc.dart';

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
        bloc: HomeBloc(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final HomeBloc bloc;

  MyHomePage({
    this.title,
    this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar<String>(
        title: Text(title),
        searcher: bloc,
        filter: Filters.startsWith,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<String>>(
        stream: bloc.filteredData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final list = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(list[index]),
              );
            },
            itemCount: list.length,
          );
        },
      ),
    );
  }
}
