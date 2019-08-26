# search_app_bar

An animated SearchAppBar Widget, to be used with Flutter.

## Usage

Simply use the **SearchAppBar** widget as a regular AppBar.
The only required attribute in the widget is called **searcher**.

You must implement the **Searcher\<T\>** interface in a class of yours (a Bloc, for example), to
control a list of data (of type **T**) and react to the list filtering provided by **SearchAppBar**.

Here's a simple example of **SearchAppBar**'s usage with bloc:

    Scaffold(
      appBar: SearchAppBar<String>(
        searcher: bloc,
      ),
      body: ...
    );

## Implementing Searcher

When you implement the **Searcher** interface, you must provide an implementation for both overrides:

    @override
    List<T> get data => ...

    @override
    get onDataFiltered => ...

`data` should simply return your full data list, in which you will search for elements.

`onDataFiltered` expects a function that receives a `List<T>`. This is the filtered data list. Use that list as you will. For example, if you are using Bloc, add this filtered list to your data's `StreamController`.

## Complete Example

Here's a complete example of a view using **SearchAppBar**:

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
