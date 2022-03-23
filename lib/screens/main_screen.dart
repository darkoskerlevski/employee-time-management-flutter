import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/list_item.dart';
import '../widgets/nov_element.dart';
import '../widgets/my_list_tile.dart';

import '../blocs/list_bloc.dart';
import '../blocs/list_state.dart';
import '../blocs/list_event.dart';

class MainScreen extends StatelessWidget {
  void _addItemFunction(BuildContext ct) {
    // var newElement = ListItem(id: "T1", naslov: "Test 1", vrednost: 13);
    //
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NovElement(_addNewItemToList),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _addNewItemToList(BuildContext ctx, ListItem item) {
    final bloc = BlocProvider.of<ListBloc>(ctx);
    bloc.add(ListElementAddedEvent(element: item));
  }

  void _deleteItem(BuildContext ctx, String id) {
    final bloc = BlocProvider.of<ListBloc>(ctx);
    bloc.add(ListElementDeletedEvent(id: id));
  }

  Widget _createBody(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(builder: (context, state) {
      return state.runtimeType == ListEmptyState
          ? Center(
              child: Text("No elements"),
            )
          : Center(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return MyListTile(
                    (state as ListElementsState).elements[index],
                    _deleteItem,
                  );
                },
                itemCount: (state as ListElementsState).elements.length,
              ),
            );
    });
  }

  PreferredSizeWidget _createAppBar(BuildContext context) {
    return AppBar(
        // The title text which will be shown on the action bar
        title: Text("Lists Example"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addItemFunction(context),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: _createBody(context),
    );
  }
}
