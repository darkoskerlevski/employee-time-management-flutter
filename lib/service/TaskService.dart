
import 'package:etm_flutter/model/Task.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class TaskService{
  static Future<List<Task>> listTasksForUser(String userId,String companyId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks");
    DatabaseEvent event = await ref.once();
    Iterable<DataSnapshot> listTasks = event.snapshot.children;
    List<Task> tasks = [];
    for (DataSnapshot task in listTasks){
      String deleted = task.child("deleted").value.toString();
      if (deleted != "deleted") {
        String id = task.key!;
        String title = task
            .child("title")
            .value
            .toString();
        String desc = task
            .child("description")
            .value
            .toString();
        String companyIdT = task
            .child("companyId")
            .value
            .toString();
        String allocatedTo = task
            .child("allocatedTo")
            .value
            .toString();
        DateTime by = DateTime.parse(task
            .child("by")
            .value
            .toString());
        int time = int.parse(task.child("timeSpent").value.toString());
        double sumRoll = double.parse(task.child("sumRoll").value.toString());
        double sumPitch = double.parse(task.child("sumPitch").value.toString());
        bool pressed = task.child("pressed").value == true;
        DateTime lastpress = DateTime.parse(task
            .child("lastButtonPress")
            .value
            .toString());
        tasks.add(Task(id: id,
            companyId: companyIdT,
            title: title,
            by: by,
            allocatedTo: allocatedTo,
            description: desc,
            timeSpent: time,
            stopwatchPressed: pressed,
            stopwatchLastPress: lastpress,
        sumRoll: sumRoll,sumPitch: sumPitch));
      }
    }
    return tasks.where((element) => element.allocatedTo == userId && element.companyId == companyId).toList();
  }

  static Future<List<Task>> listTasksForCompany(String companyId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks");
    DatabaseEvent event = await ref.once();
    Iterable<DataSnapshot> listTasks = event.snapshot.children;
    List<Task> tasks = [];
    for (DataSnapshot task in listTasks){
      String deleted = task.child("deleted").value.toString();
      if (deleted != "deleted") {
        String id = task.key!;
        String title = task
            .child("title")
            .value
            .toString();
        String desc = task
            .child("description")
            .value
            .toString();
        String companyIdT = task
            .child("companyId")
            .value
            .toString();
        String allocatedTo = task
            .child("allocatedTo")
            .value
            .toString();
        DateTime by = DateTime.parse(task
            .child("by")
            .value
            .toString());
        int time = int.parse(task.child("timeSpent").value.toString());
        double sumRoll = double.parse(task.child("sumRoll").value.toString());
        double sumPitch = double.parse(task.child("sumPitch").value.toString());
        bool pressed = task.child("pressed").value == true;
        DateTime lastpress = DateTime.parse(task
            .child("lastButtonPress")
            .value
            .toString());
        tasks.add(Task(id: id,
            companyId: companyIdT,
            title: title,
            by: by,
            allocatedTo: allocatedTo,
            description: desc,
            timeSpent: time,
            stopwatchPressed: pressed,
            stopwatchLastPress: lastpress,
            sumPitch: sumPitch,
            sumRoll: sumRoll));
      }
    }
    return tasks.where((element) => element.companyId == companyId).toList();
  }

  static Future<List<Task>> listTasksForCompanyRemoved(String companyId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks");
    DatabaseEvent event = await ref.once();
    Iterable<DataSnapshot> listTasks = event.snapshot.children;
    List<Task> tasks = [];
    for (DataSnapshot task in listTasks){
      String deleted = task.child("deleted").value.toString();
      if (deleted == "deleted")
        {
          String id = task.key!;
          String title = task.child("title").value.toString();
          String desc = task.child("description").value.toString();
          String companyIdT = task.child("companyId").value.toString();
          String allocatedTo = task.child("allocatedTo").value.toString();
          DateTime by = DateTime.parse(task.child("by").value.toString());
          bool pressed = task.child("pressed").value == true;
          int time = int.parse(task.child("timeSpent").value.toString());
          double sumRoll = double.parse(task.child("sumRoll").value.toString());
          double sumPitch = double.parse(task.child("sumPitch").value.toString());
          DateTime lastpress = DateTime.parse(task.child("lastButtonPress").value.toString());
          tasks.add(Task(sumPitch:sumPitch,sumRoll:sumRoll,id: id, companyId: companyIdT,title: title,by: by,allocatedTo: allocatedTo, description: desc, timeSpent: time, stopwatchPressed: pressed, stopwatchLastPress: lastpress));
        }
    }
    return tasks.where((element) => element.companyId == companyId).toList();
  }
  static Future<void> newTask(Task task) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks/${task.id}");
    ref.set({
      "title":task.title,
      "description":task.description,
      "by":task.by.toString(),
      "allocatedTo":task.allocatedTo,
      "companyId":task.companyId,
      "timeSpent":task.timeSpent,
      "pressed":task.stopwatchPressed,
      "lastButtonPress": task.stopwatchLastPress.toString(),
      "sumRoll":0,
      "sumPitch":0
    });
  }

  static Future<void> updateTask(String taskId, String title, String desc, String date, String userId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks/${taskId}");
    ref.update({
      "title" : title,
      "description" : desc,
      "by": date,
      "allocatedTo" : userId
    });
  }

  static Future<void> deleteTask(String taskId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks/${taskId}");
    ref.update({
      "deleted" : "deleted"
    });
  }

  static Future<void> restoreTask(String taskId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks/${taskId}");
    ref.update({
      "deleted" : "restored"
    });
  }

  static Future<void> updateTaskTime(String taskId, int time) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks/${taskId}");
    ref.update({
      "timeSpent" : time
    });
  }
  static Future<void> updatePressedStatus(String taskId, bool pressed, Position? position) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks/${taskId}");
    ref.update({
      "pressed" : pressed
    });
  }
  static Future<void> updateTaskLastPressedTime(String taskId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks/${taskId}");
    ref.update({
      "lastButtonPress" : DateTime.now().toString()
    });
  }
  static Future<void> setRollAndPitch(String taskId,double sumRoll,double sumPitch) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks/${taskId}");
    ref.update({
      "sumRoll" : sumRoll,
      "sumPitch" : sumPitch
    });
  }
}