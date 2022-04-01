class Task{
  String id;
  String title;
  String description;
  DateTime by;
  String allocatedTo;
  String companyId;
  int timeSpent;
  bool stopwatchPressed;
  DateTime stopwatchLastPress;
  double sumRoll;
  double sumPitch;

  Task({required this.sumPitch,required this.sumRoll,required this.id,required this.allocatedTo,required this.companyId,required this.title,required this.description,required this.by,required this.timeSpent,required this.stopwatchPressed,required this.stopwatchLastPress});

}