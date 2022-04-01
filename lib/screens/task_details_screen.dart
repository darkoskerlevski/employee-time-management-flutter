import 'package:etm_flutter/service/TaskService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../components/button.dart';
import '../model/Task.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TaskDetailsScreen extends StatefulWidget {
  Task task;
  TaskDetailsScreen({required this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}



class _TaskDetailsScreenState extends State<TaskDetailsScreen> {

  // late final stopwatchViewModel = DPStopwatchViewModel(
  //   startWithTenMilliseconds: widget.task.timeSpent,
  //   clockTextStyle: const TextStyle(
  //     color: Colors.black,
  //     fontSize: 32,
  //   ),
  // );
  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    // onChange: (value) => print('onChange $value'),
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  final taskTitleController = new TextEditingController();
  final taskDescriptionContoller = new TextEditingController();
  final taskDueDateController = new TextEditingController();
  final pitchController = new TextEditingController();
  final rollController = new TextEditingController();
  var myFormat = DateFormat('yyyy-MM-dd');
  bool _isButtonDisabled = false;
  int totalTime = 0;
  void Function()? _buttonPressed;

  @override
  void initState() {
    taskTitleController.text = widget.task.title;
    taskDescriptionContoller.text = widget.task.description;
    taskDueDateController.text = widget.task.by.toString();
    rollController.text = widget.task.sumRoll.toString();
    pitchController.text = widget.task.sumPitch.toString();
    checkIfTimerIsAlreadyPressed();
    super.initState();
  }

  void _timerStarted() {
    setState(() {
      _isButtonDisabled = true;
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      TaskService.updateTaskLastPressedTime(widget.task.id);
      widget.task.stopwatchLastPress = DateTime.now();
      TaskService.updatePressedStatus(widget.task.id, _isButtonDisabled);
      widget.task.stopwatchPressed = !widget.task.stopwatchPressed;
      _buttonPressed = _timerStopped;
      FlutterBackgroundService flutterBackgroundService = FlutterBackgroundService();
      flutterBackgroundService.startService();
    });
  }

  void _timerStopped() {
    setState(() {
      FlutterBackgroundService flutterBackgroundService = FlutterBackgroundService();
      flutterBackgroundService.sendData({"event" : "sendData"});
      _isButtonDisabled = false;
      stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      TaskService.updateTaskTime(widget.task.id, totalTime);
      widget.task.timeSpent = totalTime;
      widget.task.stopwatchLastPress = DateTime.now();
      TaskService.updatePressedStatus(widget.task.id, _isButtonDisabled);
      widget.task.stopwatchPressed = !widget.task.stopwatchPressed;
      _buttonPressed = _timerStarted;

      flutterBackgroundService.onDataReceived.first.then((value)=>{
        TaskService.setRollAndPitch(widget.task.id,widget.task.sumRoll + value!["sumRoll"], widget.task.sumPitch + value["sumPitch"])
      });
      flutterBackgroundService.sendData({"event" : "stopService"});
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
                  SizedBox(height: 16,)
                  ,Row(
                   children: [
                     SizedBox(width: 150,
                         child: TextField(
                           controller: rollController,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(),
                             labelText: 'Sum of roll',
                             isDense: true,
                             enabled: false,

                           ),
                         )
                     ),
                     SizedBox(
                       width: 16,
                     )
                     ,SizedBox(width: 150,child: TextField(
                       controller: pitchController,
                       decoration: InputDecoration(
                         border: OutlineInputBorder(),
                         labelText: 'Sum of pitch',
                         isDense: true,
                         enabled: false,
                       ),
                     ))
                   ],
                  ),
                  SizedBox(height: 16,),
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