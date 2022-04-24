import 'package:etm_flutter/factories/CompanyFacotry.dart';
import 'package:etm_flutter/factories/CoordsFactory.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../model/Company.dart';
import '../model/Coords.dart';

class CoordsService{
  static Future<void> saveCoords({required String taskId,required String userId,required double lat,required double long})async {
    String coordsId = Uuid().v1();
    DatabaseReference ref = FirebaseDatabase.instance.ref("coords/${coordsId}");
    ref.set({
      "lat":lat,
      "long":long,
      "time":DateTime.now().toString(),
      "userId":userId,
      "taskId":taskId
    });
  }

  static Future<List<Coords>> getAllCoordsForTask(String taskId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("coords");
    DatabaseEvent event = await ref.once();
    Iterable<DataSnapshot> companiesSnapshot = event.snapshot.children;
    List<Coords> coords = [];
    for (DataSnapshot oneCoord in companiesSnapshot){
      String? id = oneCoord.key;
      double lat = double.parse(oneCoord.child("lat").value.toString());
      double long = double.parse(oneCoord.child("long").value.toString());
      DateTime dateTime = DateTime.parse(oneCoord.child("time").value.toString());
      String userId = oneCoord.child("userId").value.toString();
      String taskId = oneCoord.child("taskId").value.toString();

      coords.add(CoordsFactory.toCoords(id:id,lat:lat,long:long,time:dateTime,userId: userId,taskId: taskId));
    }
    coords = coords.where((element) => element.taskId==taskId).toList();
    coords.sort((e1,e2) => e1.dateTime.compareTo(e2.dateTime));
    return coords;
  }
}