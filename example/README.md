# search_app_bar example

Use the **SearchAppBar** widget as a regular AppBar.
Remember to pass an object of a class that uses **Searcher**
as a mixin:

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
            appBar: SearchAppBar(
                title: Text(title),
                searcher: bloc,
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

Below is an example of a HomeBloc class that uses **Searcher**:
(This example also uses the **bloc_pattern** library to implement a bloc class)

    import 'package:bloc_pattern/bloc_pattern.dart';
    import 'package:diacritic/diacritic.dart';
    import 'package:rxdart/subjects.dart';
    import 'package:search_app_bar/searcher.dart';

    class HomeBloc extends BlocBase with Searcher {
        final _isInSearchMode = BehaviorSubject<bool>();
        final _searchQuery = BehaviorSubject<String>();
        final _filteredData = BehaviorSubject<List<String>>();

        final _data = [
            'Thaís Fernandes',
            'Vinicius Santos',
            'Gabrielly Costa',
            'Olívia Sousa',
            'Diogo Lima',
            'Lucas Assunção',
            'Conceição Cardoso'
        ];

        ///
        /// Inputs
        ///
        @override
        get onSearchQueryChanged => _searchQuery.add;

        @override
        get setSearchMode => _isInSearchMode.add;

        ///
        /// Outputs
        ///
        @override
        Stream<bool> get isInSearchMode => _isInSearchMode.stream;

        @override
        Stream<String> get searchQuery => _searchQuery.stream;

        Stream<List<String>> get filteredData => _filteredData.stream;

        HomeBloc() {
            _filteredData.add(_data);
            searchQuery.listen((query) {
            final filtered =
                _data.where((test) => _startsWith(test, query)).toList();
            _filteredData.add(filtered);
            });
        }

        /// returns if [test] starts with the given [query],
        /// disregarding lower/upper case and diacritics.
        _startsWith(String test, String query) {
            final realTest = removeDiacritics(test.toLowerCase());
            final realQuery = removeDiacritics(query.toLowerCase());
            return realTest.startsWith(realQuery);
        }

        @override
        void dispose() {
            _isInSearchMode.close();
            _searchQuery.close();
            _filteredData.close();
            super.dispose();
        }
    }
    