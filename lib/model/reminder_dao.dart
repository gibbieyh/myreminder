import 'dart:async';
import 'database.dart';
import 'reminder.dart';

class ReminderDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Reminder records
  Future<int> createReminder(Reminder reminder) async {
    final db = await dbProvider.database;
    var result = await db.insert(reminderTable, reminder.toDatabaseJson());
    print('int result: $result');
    return result;
  }

  //Get Reminders using per list
  Future<List<Reminder>> getRemindersPerList(
      {List<String> columns, String query, String whereQuery}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(reminderTable,
            columns: columns,
            where: '$whereQuery = ?',
            whereArgs: ["$query"],
            orderBy: '"due_date" ASC');
    } else {
      result = await db.query(reminderTable,
          columns: columns, orderBy: '"is_done" ASC, "due_date" ASC');
    }
    // Rewrite the list
    List<Reminder> reminders = result.isNotEmpty
        ? result.map((item) => Reminder.fromDatabaseJson(item)).toList()
        : [];
    return reminders;
  }

  //Get reminders for done only
  Future<List<Reminder>> getRemindersDone(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    result = await db.query(reminderTable,
        columns: columns,
        where: 'is_done LIKE ?',
        whereArgs: ["%1%"],
        orderBy: '"due_date" ASC');

    // Rewrite the list
    List<Reminder> reminders = result.isNotEmpty
        ? result.map((item) => Reminder.fromDatabaseJson(item)).toList()
        : [];
    return reminders;
  }

  //Get Reminders for today's tasks
  Future<List<Reminder>> getRemindersToday(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;
    result = await db.query(reminderTable,
        columns: columns, orderBy: '"is_done" ASC, "due_date" ASC');

    // Rewrite the list
    List<Reminder> reminders = result.isNotEmpty
        ? result.map((item) => Reminder.fromDatabaseJson(item)).toList()
        : [];
    return reminders;
  }

  //Update Reminder record
  Future<int> updateReminder(Reminder reminder) async {
    final db = await dbProvider.database;

    var result = await db.update(reminderTable, reminder.toDatabaseJson(),
        where: "id = ?", whereArgs: [reminder.id]);

    return result;
  }

  //Delete Reminder records
  Future<int> deleteReminder(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(reminderTable, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllReminders() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      reminderTable,
    );

    return result;
  }
}
