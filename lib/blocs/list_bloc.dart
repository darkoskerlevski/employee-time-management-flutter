import "package:flutter_bloc/flutter_bloc.dart";
import "../model/list_item.dart";
import "list_event.dart";
import "list_state.dart";

class ListBloc extends Bloc<ListEvent, ListState> {
  List<ListItem> _elements=[];

  ListBloc() : super(ListInitState()) {
    on<ListInitializedEvent>((event, emit) {
      this._elements = [];
      ListInitState state = ListInitState();
      state.elements = this._elements;
      emit(state);
    });
    on<ListElementAddedEvent>((event, emit) {
      this._elements.add(event.element);
      emit(ListElementsState(elements: this._elements));
    });
    on<ListElementDeletedEvent>((event, emit) {
      this._elements.removeWhere((p) => p.id == event.id);
      if (this._elements.length > 0) {
        emit(ListElementsState(elements: this._elements));
      } else {
        emit(ListEmptyState());
      }
    });
  }
}
