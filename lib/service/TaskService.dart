
import 'package:etm_flutter/model/Task.dart';
import 'package:firebase_database/firebase_database.dart';

class TaskService{
  static Future<List<Task>> listTasksForUser(String userId,String companyId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks");
    DatabaseEvent event = await ref.once();
    Iterable<DataSnapshot> listTasks = event.snapshot.children;
    List<Task> tasks = [];
    for (DataSnapshot task in listTasks){
      String id = task.key!;
      String title = task.child("title").value.toString();
      String desc = task.child("description").value.toString();
      String companyIdT = task.child("companyId").value.toString();
      String allocatedTo = task.child("allocatedTo").value.toString();
      DateTime by = DateTime.parse(task.child("by").value.toString());
      tasks.add(Task(id: id, companyId: companyIdT,title: title,by: by,allocatedTo: allocatedTo, description: desc));
    }
    return tasks.where((element) => element.allocatedTo == userId && element.companyId == companyId).toList();
  }

  static Future<List<Task>> listTasksForCompany(String companyId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("tasks");
    DatabaseEvent event = await ref.once();
    Iterable<DataSnapshot> listTasks = event.snapshot.children;
    List<Task> tasks = [];
    for (DataSnapshot task in listTasks){
      String id = task.key!;
      String title = task.child("title").value.toString();
      String desc = task.child("description").value.toString();
      String companyIdT = task.child("companyId").value.toString();
      String allocatedTo = task.child("allocatedTo").value.toString();
      DateTime by = DateTime.parse(task.child("by").value.toString());
      tasks.add(Task(id: id, companyId: companyIdT,title: title,by: by,allocatedTo: allocatedTo, description: desc));
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
      "companyId":task.companyId
    });
  }
}