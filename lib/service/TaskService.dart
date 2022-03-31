
import 'package:etm_flutter/model/Task.dart';
import 'package:firebase_database/firebase_database.dart';

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
        bool pressed = task.child("pressed").value == 'true';
        tasks.add(Task(id: id,
            companyId: companyIdT,
            title: title,
            by: by,
            allocatedTo: allocatedTo,
            description: desc,
            timeSpent: time,
            stopwatchPressed: pressed));
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
        bool pressed = task.child("pressed").value == 'true';
        tasks.add(Task(id: id,
            companyId: companyIdT,
            title: title,
            by: by,
            allocatedTo: allocatedTo,
            description: desc,
            timeSpent: time,
            stopwatchPressed: pressed));
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
          tasks.add(Task(id: id, companyId: companyIdT,title: title,by: by,allocatedTo: allocatedTo, description: desc, timeSpent: 0, stopwatchPressed: false));
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
      "timeSpent":task.timeSpent
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
  static Future<void> updatePressedStatus(String taskId, bool pressed) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks/${taskId}");
    ref.update({
      "pressed" : pressed
    });
  }
}