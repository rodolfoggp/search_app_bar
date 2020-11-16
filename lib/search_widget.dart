import 'package:flutter/material.dart';
import 'package:search_app_bar/search_bloc.dart';

class SearchWidget extends StatelessWidget implements PreferredSizeWidget {
  final SearchBloc bloc;
  final Color color;
  final VoidCallback onCancelSearch;
  final TextCapitalization textCapitalization;
  final String hintText;
  final TextStyle searchTextStyle;
  final EdgeInsets searchTextFieldPadding;
  final bool useCloseButton;

  SearchWidget(
      {@required this.bloc,
      @required this.onCancelSearch,
      this.color,
      this.textCapitalization,
      this.hintText,
      this.searchTextStyle,
      this.searchTextFieldPadding,
      this.useCloseButton = false});

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  useCloseButton ? Container() : _buildBackButton(),
                  _buildTextField(),
                  _buildClearButton(),
                  useCloseButton ? _buildCloseSearchButton() : Container()
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

  Widget _buildCloseSearchButton() {
    return StreamBuilder<String>(
      stream: bloc.searchQuery,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.isEmpty != false)
          return IconButton(
            icon: Icon(Icons.cancel_outlined, color: color),
            onPressed: onCancelSearch,
          );
        return Container();
      },
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: Padding(
        padding: this.searchTextFieldPadding,
        child: StreamBuilder<String>(
          stream: bloc.searchQuery,
          builder: (context, snapshot) {
            TextEditingController controller = _getController(snapshot);
            return TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: hintText,
              ),
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              style: searchTextStyle,
              onChanged: bloc.onSearchQueryChanged,
            );
          },
        ),
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
