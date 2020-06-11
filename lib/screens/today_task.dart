import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myreminder/components/dismissible_task_card.dart';
import 'package:myreminder/model/reminder_bloc_today.dart';
import '../model/reminder.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TodayTaskScreen extends StatelessWidget {
  final ReminderBloc reminderBloc = ReminderBloc();
  final DismissDirection _dismissDirection = DismissDirection.horizontal;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 20, bottom: 15),
          child: Text(
            'Today',
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

  void refreshData() async {
    // monitor network fetch
    await reminderBloc.getReminders();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
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
    var todayTask = (DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1))
        .millisecondsSinceEpoch;
    var yesterdayTask = (DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day))
        .millisecondsSinceEpoch;

    if (snapshot.hasData) {
      badgeCount = 0;
      // generate the badge for iOS
      for (var snap in snapshot.data) {
        // To add a new badge for every today's and yesterday's tasks and the isNotDone
        if (snap.dueDate < todayTask && !snap.isDone) {
          badgeCount++;
          FlutterAppBadger.updateBadgeCount(badgeCount);
        }
      }

      return snapshot.data.length != 0
          ? SmartRefresher(
              controller: _refreshController,
              onRefresh: refreshData,
              header: WaterDropMaterialHeader(),
              onLoading: () {
                print('loading');
              },
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, itemPosition) {
                  Reminder reminder = snapshot.data[itemPosition];

                  // If statement to check if the task is for today or not
                  final Widget dismissibleCard =
                      (reminder.dueDate < todayTask) && !reminder.isDone
                          ? DismissibleTaskCard(
                              objectKey: reminder,
                              dismissDirection: _dismissDirection,
                              onDismiss: (direction) async {
                                // delete reminder by id when dismissed
                                reminderBloc.deleteReminderById(reminder.id);
                                // reset the badge to 0 to recalculate
                                FlutterAppBadger.removeBadge();
                                // delete its reminder from being fired after deletion
                                FlutterLocalNotificationsPlugin localNotif =
                                    FlutterLocalNotificationsPlugin();
                                await localNotif.cancel(reminder.id);
                              },
                              onTapped: () {
                                //Reverse the value
                                reminder.isDone = !reminder.isDone;
                                // update the task based on isDone value
                                reminderBloc.updateReminder(reminder);
                                // reset the badge to 0
                                FlutterAppBadger.removeBadge();
                              },
                              widgetOverdue: reminder.dueDate < yesterdayTask
                                  ? Text(
                                      'Overdue',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Container(),
                            )
                          : Container();
                  return dismissibleCard;
                },
              ),
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
    reminderBloc.getReminders();
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
        "Start adding a task...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    reminderBloc.dispose();
  }
}
