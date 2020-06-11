import 'package:flutter/material.dart';
import 'package:myreminder/components/dismissible_task_card.dart';
import 'package:myreminder/model/reminder_bloc_perlist.dart';
import '../model/reminder.dart';

// ignore: must_be_immutable
class PerTaskScreen extends StatefulWidget {
  String selectedList;
  PerTaskScreen({this.selectedList});

  @override
  _PerTaskScreenState createState() => _PerTaskScreenState();
}

class _PerTaskScreenState extends State<PerTaskScreen> {
  String selectedList;
  ReminderBlocPerList reminderBloc = ReminderBlocPerList();

  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  void initState() {
    super.initState();
    selectedList = widget.selectedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 12, bottom: 15),
                      child: Text(
                        selectedList == '' ? 'All Tasks' : selectedList,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                if (selectedList == '')
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _showReminderSearchSheet(context);
                      })
              ],
            ),
            Expanded(
              child: Container(
                child: getRemindersWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRemindersWidget() {
    // get the Stream Builder but per list
    return StreamBuilder(
      stream: reminderBloc.reminders,
      builder: (BuildContext context, AsyncSnapshot<List<Reminder>> snapshot) {
        return getReminderCards(snapshot);
      },
    );
  }

  Widget getReminderCards(AsyncSnapshot<List<Reminder>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Reminder reminder = snapshot.data[itemPosition];
                final Widget dismissibleCard = DismissibleTaskCard(
                  objectKey: reminder,
                  dismissDirection: _dismissDirection,
                  onDismiss: (direction) {
                    // delete item by id when dismissed
                    reminderBloc.deleteReminderById(
                        reminder.id, selectedList, 'list');
                  },
                  onTapped: () {
                    //Reverse the value
                    reminder.isDone = !reminder.isDone;
                    // update the task based on isDone value
                    reminderBloc.updateReminder(reminder, selectedList, 'list');
                  },
                  widgetOverdue: Container(),
                );
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
                // display this message when no tasks
                child: noReminderMessageWidget(),
              ),
            );
    } else {
      return Center(
        // Display loading animation when fetching data
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    // reload the reminders
    if (selectedList == '') {
      reminderBloc.getRemindersPerList();
    } else {
      reminderBloc.getRemindersPerList(query: selectedList, where: 'list');
    }
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noReminderMessageWidget() {
    return Container(
      child: Text(
        "No tasks from this list...\nStart adding one",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    reminderBloc.dispose();
    super.dispose();
  }

  void _showReminderSearchSheet(BuildContext context) {
    final _reminderSearchDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller:
                                  _reminderSearchDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search for a task...',
                                labelText: 'Search:',
                                labelStyle: TextStyle(
                                    color: Color(0xFFFDBC49),
                                    fontWeight: FontWeight.w500),
                              ),
                              validator: (String value) {
                                return value.contains('@')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFFDBC49),
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // get tasks based on the searched String
                                  reminderBloc.getRemindersPerList(
                                      query:
                                          _reminderSearchDescriptionFormController
                                              .value.text,
                                      where: 'title');
                                  //dismisses the bottomsheet
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
