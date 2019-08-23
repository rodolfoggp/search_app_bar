# search_app_bar

An animated SearchAppBar Widget, to be used with Flutter.

## Usage

Simply use the SearchAppBar widget, included in this package, 
where you would use a regular AppBar:

    Scaffold(
      appBar: SearchAppBar(
        title: Text(title),
        searcher: bloc,
      ),
      body: // Insert body here
    );

The only required attribute in this widget is **searcher**.
Here, you should pass an instance of a class that uses **Searcher**
as a mixin. Like this one:

    class HomeBloc with Searcher {
        // ...
    }

A functional example can be found in the **example** folder.

## Disclaimer

This small library was developed (and later, improved)
based on the excellent tutorial provided by Nishant Desai at:
https://blog.usejournal.com/change-app-bar-in-flutter-with-animation-cfffb3413e8a

All due credit goes to him :)
