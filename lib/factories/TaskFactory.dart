
import '../model/Task.dart';

class TaskFactory{

  TaskFactory();

  Task toTask({id,
  companyId,
  title,
  by,
  allocatedTo,
  description,
  timeSpent,
  stopwatchPress,
  stopwatchLastPressed,
  sumRoll, sumPitch}){
    return Task(id: id,
    companyId: companyId,
title: title,
by: by,
allocatedTo: allocatedTo,
description: description,
timeSpent: timeSpent,
stopwatchPressed: stopwatchPress,
stopwatchLastPress: stopwatchLastPressed,
sumRoll: sumRoll,sumPitch: sumPitch);
  }
}