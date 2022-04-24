import 'package:etm_flutter/service/TaskService.dart';
import 'package:etm_flutter/service/UserService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/button.dart';
import '../model/Task.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import '../model/user.dart';

class TaskDetailsScreen extends StatefulWidget {
  Task task;
  User user;
  bool removed;
  TaskDetailsScreen({required this.task, required this.user, required this.removed});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}



class _TaskDetailsScreenState extends State<TaskDetailsScreen> {

  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final taskTitleController = new TextEditingController();
  final taskDescriptionContoller = new TextEditingController();
  final taskDueDateController = new TextEditingController();
  final usageController = new TextEditingController();
  var myFormat = DateFormat('yyyy-MM-dd');
  bool _isButtonDisabled = false;
  int totalTime = 0;
  void Function()? _buttonPressed;
  String dropdownValue="";
  List<CustomUser> users = [];
  bool locationsPermissionsEnabled = false;
  double x=0;
  double y=0;
  double z=0;

  @override
  void initState() {
    taskTitleController.text = widget.task.title;
    taskDescriptionContoller.text = widget.task.description;
    taskDueDateController.text = widget.task.by.toString();
    usageController.text = "low";
    UserService.getUserEmail(widget.task.allocatedTo).then((value) => {
      dropdownValue = value
    });
    UserService.worksFor(widget.user.uid).then((value1) => {
      UserService.listUsers(value1).then((value2) {
        setState(() {
        users = value2;
        dropdownValue = widget.task.allocatedTo;
        });
      })
    });
    checkIfTimerIsAlreadyPressed();
    checkPermissions();
    super.initState();
  }

  Future<void> checkPermissions() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        locationsPermissionsEnabled = true;
      }
      else{
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permission error'),
            content: Text("You have not enabled location permissions. In order for you to get the most functionality out of this app it's best to enable location permissions."),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              ElevatedButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.pop(context);
                  },
                  child: Text("Open Settings"))
            ],
          ),
        );
      }
    }
    else {
      locationsPermissionsEnabled = true;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void _timerStarted() {
    setState(() async {
      _isButtonDisabled = true;
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      TaskService.updateTaskLastPressedTime(widget.task.id);
      widget.task.stopwatchLastPress = DateTime.now();
      TaskService.updatePressedStatus(widget.task.id, _isButtonDisabled, await _determinePosition());
      widget.task.stopwatchPressed = !widget.task.stopwatchPressed;
      _buttonPressed = _timerStopped;
      gyroscopeEvents.listen((GyroscopeEvent event) {
        setState(() {
          x += event.x.abs();
          y += event.y.abs();
          z += event.z.abs();
          if (x+y+z > 1000){
            usageController.text = "Moderate";
          }
          if (x+y+z > 5000) {
            usageController.text = "high";
          }
        });
      });
    });
  }

  void _timerStopped() {
    setState(() async {
      _isButtonDisabled = false;
      stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      TaskService.updateTaskTime(widget.task.id, totalTime);
      widget.task.timeSpent = totalTime;
      widget.task.stopwatchLastPress = DateTime.now();
      TaskService.updatePressedStatus(widget.task.id, _isButtonDisabled, await _determinePosition());
      widget.task.stopwatchPressed = !widget.task.stopwatchPressed;
      _buttonPressed = _timerStarted;
    });
  }

  @override
  void dispose() async{
    super.dispose();
    await stopWatchTimer.dispose();
  }

  void checkIfTimerIsAlreadyPressed(){
    setState(() {
      if (widget.task.stopwatchPressed){
        _isButtonDisabled = !_isButtonDisabled;
        Duration diff = DateTime.now().difference(widget.task.stopwatchLastPress);
        stopWatchTimer.setPresetTime(mSec: diff.inMilliseconds + widget.task.timeSpent);
        stopWatchTimer.onExecute.add(StopWatchExecute.start);
        _buttonPressed = _timerStopped;
      }
      else{
        stopWatchTimer.setPresetTime(mSec: widget.task.timeSpent);
        _buttonPressed = _timerStarted;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.task.title),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: taskTitleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Task Title',
                      isDense: true,
                      enabled: true,
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    height: 5 * 24.0,
                    child: TextField(
                      controller: taskDescriptionContoller,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Task description",
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey[300],
                        isDense: true,
                      ),
                    )
                  ),
                  SizedBox(height: 16,),
                  TextField(
                    controller: taskDueDateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Due date',
                      isDense: true,
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      var tempDate = (await showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100)));
                      if (tempDate != null) {
                        taskDueDateController.text = myFormat.format(tempDate);
                      }
                    },
                    readOnly: true,
                  ),
                  SizedBox(height: 16,),
                  SizedBox(width: 300,
                      child: TextField(
                        controller: usageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Usage level',
                          isDense: true,
                          enabled: false,

                        ),
                      )
                  ),
                  SizedBox(height: 16,),
                  Text(
                    "Asignee"
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: users.map<DropdownMenuItem<String>>((CustomUser value) {
                      String email = value.Email;
                      return DropdownMenuItem<String>(
                        value: value.id,
                        child: Text(email),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          TaskService.updateTask(widget.task.id, taskTitleController.text, taskDescriptionContoller.text, taskDueDateController.text, dropdownValue);
                        },
                        child: Text('Update Task'),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      if (widget.removed)
                        TextButton(
                          style: raisedButtonStyle,
                          onPressed: () {
                            TaskService.restoreTask(widget.task.id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Task restored"),
                            ));
                            Navigator.pop(context);
                          },
                          child: Text('Restore Task'),
                      )
                      else
                        TextButton(
                          style: raisedButtonStyle,
                          onPressed: () {
                            TaskService.deleteTask(widget.task.id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Task deleted"),
                            ));
                            Navigator.pop(context);
                          },
                          child: Text('Delete Task'),
                        )
                    ],
                  ),

                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16,),
                  Text(
                    "Task time counter:",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                  SizedBox(height: 12,),
                  StreamBuilder<int>(
                      stream: stopWatchTimer.rawTime,
                      initialData: 0,
                      builder: (context, snap) {
                        final value = snap.data;
                        totalTime = value!;
                        final displayTime = StopWatchTimer.getDisplayTime(value);
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                displayTime,
                                style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                value.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: raisedButtonStyle,
                        onPressed: _isButtonDisabled ? null : _buttonPressed,
                        child: Text('Start timer'),

                      ),
                      SizedBox(
                        width: 16,
                      ),
                      TextButton(
                        style: raisedButtonStyle,
                        onPressed: _isButtonDisabled ? _buttonPressed : null,
                        child: Text('Stop timer'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}