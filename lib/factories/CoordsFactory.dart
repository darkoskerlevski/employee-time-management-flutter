import 'package:etm_flutter/model/Coords.dart';

class CoordsFactory{

  static toCoords({
    id,
    lat,
    long,
    time,
    userId,
    taskId
  }){
    return Coords(
      id: id,
      lat: lat,
      dateTime: time,
      userId: userId,
      long: long,
      taskId: taskId
    );
  }
}