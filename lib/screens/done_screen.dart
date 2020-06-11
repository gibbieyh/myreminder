import 'package:flutter/material.dart';
import 'package:myreminder/components/dismissible_task_card.dart';
import 'package:myreminder/model/reminder.dart';
import 'package:myreminder/model/reminder_bloc_done.dart';

class DoneScreen extends StatefulWidget {
  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  final ReminderBlocDone reminderBloc = ReminderBlocDone();

  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 20, bottom: 15),
          child: Text(
            'Done',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Container(
            //This is where the magic starts
            child: getRemindersWidget(),
          ),
        ),
      ],
    );
  }

  Widget getRemindersWidget() {
    // Stream builder to get all the reminders for Today
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
                  widgetOverdue: Container(),
                  dismissDirection: _dismissDirection,
                  objectKey: reminder,
                  onDismiss: (direction) {
                    // delete reminder by id when dismissed
                    reminderBloc.deleteReminderById(reminder.id);
                  },
                  onTapped: () {
                    //Reverse the value
                    reminder.isDone = !reminder.isDone;
                    // Update the reminder based on isDone value
                    reminderBloc.updateReminder(reminder);
                  },
                );
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
                // show this when there is no task
                child: noReminderMessageWidget(),
              ),
            );
    } else {
      return Center(
        // show indicator if still loading data
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    // Get reminders again
    reminderBloc.getRemindersDone();
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
        "Remember to accomplish your tasks!",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    reminderBloc.dispose();
    super.dispose();
  }
}
