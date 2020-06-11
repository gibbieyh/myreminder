import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:myreminder/model/reminder.dart';
import 'package:myreminder/model/reminder_bloc_today.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<String> listOfList = [];
  bool _remindIsVisible;
  String title;
  String detail;
  String dateString;
  String errorMessageTitle = '';
  String defaultList = 'All Tasks';
  String reminderInterval = 'none';
  int remindDate;
  int dueDate;
  int selectedList;
  int result;

  @override
  void initState() {
    super.initState();
    _getList();
    _initialiseReminder();
    remindDate = DateTime.now().millisecondsSinceEpoch;
    dueDate = DateTime.now().millisecondsSinceEpoch;
    _remindIsVisible = false;
    selectedList = 0;
  }

  _initialiseReminder() {
    var initialisationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initialisationSettingIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestAlertPermission: true,
    );
    var initialisationSettings = InitializationSettings(
        initialisationSettingsAndroid, initialisationSettingIOS);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initialisationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  // Define what happens if the notification is selected
  Future selectNotification(String payload) async {
    Navigator.pushNamed(context, '/add');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a reminder',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.grey[800],
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Title: ',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Fly to the moon...',
                    ),
                  ),
                  Text(
                    errorMessageTitle,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Detail: ',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      detail = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Make friends and ask them to go with...',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              color: Colors.grey[800],
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Remind me:',
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(fontSize: 17.5, color: Colors.grey[300]),
                      ),
                      CupertinoSwitch(
                        activeColor: Color(0xFFFDBC49),
                        value: _remindIsVisible,
                        onChanged: (value) {
                          setState(() {
                            _remindIsVisible = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: AnimatedContainer(
                        margin: EdgeInsets.only(top: 10),
                        duration: Duration(seconds: 1),
                        curve: Curves.decelerate,
                        height: _remindIsVisible ? 30 : 0,
                        child: getDate(remindDate),
                      ),
                      onTap: () {
                        _selectDate(
                          remindDate,
                          (date) {
                            setState(() {
                              remindDate = date.millisecondsSinceEpoch;
                            });
                          },
                          DateTime.fromMillisecondsSinceEpoch(dueDate),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.grey[700],
                    height: 0.5,
                    margin: EdgeInsets.only(bottom: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Due date:',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 17),
                      ),
                      GestureDetector(
                          onTap: () {
                            _selectDate(dueDate, (date) {
                              setState(() {
                                dueDate = date.millisecondsSinceEpoch;
                              });
                            }, DateTime(2050));
                          },
                          child: getDate(dueDate)),
                    ],
                  ),
                  Container(
                    color: Colors.grey[700],
                    height: 0.5,
                    margin: EdgeInsets.only(bottom: 5, top: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'List:',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 17),
                      ),
                      Builder(
                        builder: (context) => FlatButton(
                          onPressed: () {
                            if (listOfList.isNotEmpty) {
                              showPicker();
                            } else {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Color(0x991b1b1b),
                                  content: Text(
                                    'You have no other lists',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Text(
                            getListName(),
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xFFFDBC49),
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                  onPressed: () async {
                    if (title == null) {
                      setState(() {
                        errorMessageTitle = 'You have not entered any title';
                      });
                    } else {
                      setState(() {
                        errorMessageTitle = '';
                      });
                    }
                    if (title != null) {
                      final newReminder = Reminder(
                        title: title,
                        detail: detail,
                        remindDate: _remindIsVisible ? remindDate : null,
                        dueDate: dueDate,
                        list: getListName(),
                      );
                      try {
                        final ReminderBloc reminderBloc = ReminderBloc();
                        result = await reminderBloc.addReminder(newReminder);

                        _startReminderAsReminded();
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text(
                    'DONE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getListName() {
    if (listOfList.isNotEmpty) {
      return listOfList[selectedList];
    } else {
      return defaultList;
    }
  }

  Future<void> _startReminderAsDue() async {
    try {
      var scheduledNotificationDateTime =
          DateTime.fromMillisecondsSinceEpoch(dueDate);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'myreminderdue', 'Due Date', 'It is due',
          playSound: false,
          importance: Importance.Max,
          priority: Priority.High);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
          sound: 'alert.caf',
          badgeNumber: 1,
          presentSound: true,
          presentBadge: true,
          presentAlert: true);
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(
        result,
        'Your task is due!',
        title,
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'No_Sound',
      );
    } catch (e) {
      print(e);
    }

    Navigator.pushReplacementNamed(context, '/');
  }

  Future<void> _startReminderAsReminded() async {
    try {
      var scheduledNotificationDateTime =
          DateTime.fromMillisecondsSinceEpoch(remindDate);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'myreminderremind', 'Remind Me', 'It is reminder time',
          playSound: false,
          importance: Importance.Max,
          priority: Priority.High);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
          badgeNumber: 1,
          presentSound: true,
          presentBadge: true,
          presentAlert: true);
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.schedule(
        999999999 - result,
        title,
        detail,
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'No_Sound',
      );
    } catch (e) {
      print(e);
    }

    _startReminderAsDue();
  }

  Text getDate(int selectedDate) {
    var format = DateFormat('d MMM yyyy   HH:mm');
    var fromIntDate = DateTime.fromMillisecondsSinceEpoch(selectedDate);
    var newDate = format.format(fromIntDate);
    return Text(
      newDate,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Future<void> _selectDate(int selectedDate, Function(DateTime) onConfirmed,
      DateTime maxDate) async {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        theme: DatePickerTheme(
          backgroundColor: Color(0xFF1b1b1b),
          itemStyle: TextStyle(color: Colors.white),
          cancelStyle: TextStyle(color: Colors.white),
          doneStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        minTime: DateTime(2000, 0, 0),
        maxTime: maxDate,
        onChanged: (date) {},
        onConfirm: onConfirmed,
        currentTime: DateTime.now(),
        locale: LocaleType.en);
  }

  _getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prefsList = (prefs.getStringList('myList') ?? List<String>());
    setState(() {
      listOfList = prefsList;
    });
  }

  // iOS style picker for list
  showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      splashColor: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 210,
                child: CupertinoPicker(
                  onSelectedItemChanged: (value) {
                    setState(() {
                      selectedList = value;
                    });
                  },
                  itemExtent: 40.0,
                  children:
                      // ignore: missing_return
                      (() {
                    List<Widget> children = [];
                    for (var list in listOfList) {
                      children.add(Center(
                        child: Text(
                          list,
                          style: TextStyle(color: Colors.white),
                        ),
                      ));
                    }
                    return children;
                  }()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
