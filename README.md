# search_app_bar

An animated SearchAppBar Widget, to be used with Flutter.

## Usage

Simply use the **SearchAppBar** widget as a regular AppBar.
The only required attribute in the widget is called **searcher**.

You must implement the **Searcher** interface in a class of yours, to
control the list of data and react to the list filtering provided by **SearchAppBar**.

  import 'package:flutter/material.dart';
  import 'package:search_app_bar/search_app_bar.dart';
  import 'package:search_test/home_bloc.dart';

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

Below is an example of a HomeBloc class that implements **Searcher**:
(This example also uses the **bloc_pattern** library to implement a bloc class)

  import 'package:bloc_pattern/bloc_pattern.dart';
  import 'package:rxdart/subjects.dart';
  import 'package:search_app_bar/searcher.dart';

  class HomeBloc extends BlocBase implements Searcher<String> {

    final _filteredData = BehaviorSubject<List<String>>();

    final dataList = [
        'Thaís Fernandes',
        'Vinicius Santos',
        'Gabrielly Costa',
        'Olívia Sousa',
        'Diogo Lima',
        'Lucas Assunção',
        'Conceição Cardoso'
    ];

    Stream<List<String>> get filteredData => _filteredData.stream;

    HomeBloc() {
        _filteredData.add(dataList);
    }

    @override
    get onDataFiltered => _filteredData.add;

    @override
    get data => dataList;
    
    @override
    void dispose() {
        _filteredData.close();
        super.dispose();
    }
  }

## Disclaimer

This small library was developed (and later, improved)
based on the excellent tutorial provided by Nishant Desai at:
https://blog.usejournal.com/change-app-bar-in-flutter-with-animation-cfffb3413e8a

All due credit goes to him :)
