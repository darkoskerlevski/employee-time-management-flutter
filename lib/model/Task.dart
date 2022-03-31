class Task{
  String id;
  String title;
  String description;
  DateTime by;
  String allocatedTo;
  String companyId;

  Task({required this.id,required this.allocatedTo,required this.companyId,required this.title,required this.description,required this.by});

}