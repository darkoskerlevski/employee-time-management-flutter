import '../model/list_item.dart';

abstract class ListEvent {}

class ListInitializedEvent extends ListEvent {}

class ListElementAddedEvent extends ListEvent {
  final ListItem element;
  ListElementAddedEvent({required this.element});
}

class ListElementDeletedEvent extends ListEvent {
  final String id;
  ListElementDeletedEvent({required this.id});
}
