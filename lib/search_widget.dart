import 'package:flutter/material.dart';
import 'package:search_app_bar/search_bloc.dart';

class SearchWidget extends StatelessWidget implements PreferredSizeWidget {
  final SearchBloc bloc;
  final Color color;
  final VoidCallback onCancelSearch;
  final TextCapitalization textCapitalization;
  final String hintText;

  SearchWidget({
    @required this.bloc,
    @required this.onCancelSearch,
    this.color,
    this.textCapitalization,
    this.hintText,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    // to handle notches properly
    return SafeArea(
      top: true,
      child: GestureDetector(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildBackButton(),
                  _buildTextField(),
                  _buildClearButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return StreamBuilder<String>(
      stream: bloc.searchQuery,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.isEmpty != false)
          return Container();
        return IconButton(
          icon: Icon(
            Icons.close,
            color: color,
          ),
          onPressed: bloc.onClearSearchQuery,
        );
      },
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color),
      onPressed: onCancelSearch,
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: StreamBuilder<String>(
        stream: bloc.searchQuery,
        builder: (context, snapshot) {
          TextEditingController controller = _getController(snapshot);
          return TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            style: TextStyle(fontSize: 18.0),
            onChanged: bloc.onSearchQueryChanged,
          );
        },
      ),
    );
  }

  TextEditingController _getController(AsyncSnapshot<String> snapshot) {
    final controller = TextEditingController();
    controller.value = TextEditingValue(text: snapshot.data ?? '');
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text?.length ?? 0),
    );
    return controller;
  }
}
