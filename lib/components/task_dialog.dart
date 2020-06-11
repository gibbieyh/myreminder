import 'package:flutter/material.dart';
import 'package:myreminder/model/reminder.dart';
import 'package:intl/intl.dart';
import 'package:myreminder/screens/edit_screen.dart';

void showAddDialog(BuildContext context, Reminder reminder) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 300),
    context: context,
    pageBuilder: (_, __, ___) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              reminder.title,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            reminder.detail == null
                ? Container()
                : Text(
                    reminder.detail,
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    textAlign: TextAlign.left,
                    maxLines: null,
                    overflow: TextOverflow.ellipsis,
                  ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[700])),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Due:', style: TextStyle(fontSize: 14)),
                  Text(
                    getDate(reminder.dueDate),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
            ),
            reminder.remindDate == null
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[700]))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Reminder:', style: TextStyle(fontSize: 14)),
                        Text(
                          getDate(reminder.remindDate),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
            SizedBox(height: 7.5),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                reminder.list,
                style: TextStyle(fontSize: 14, color: Colors.amber),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        actionsPadding: EdgeInsets.only(right: 10, bottom: 5),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(
                    reminder: reminder,
                  ),
                ),
              );
            },
            child: Text(
              'Edit',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          )
        ],
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}

String getDate(int selectedDate) {
  var format = DateFormat('MMM dd, yyyy - HH:mm');
  var fromIntDate = DateTime.fromMillisecondsSinceEpoch(selectedDate);
  var newDate = format.format(fromIntDate);
  return newDate;
}
