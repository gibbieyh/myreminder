import 'reminder_dao.dart';
import 'reminder.dart';

class ReminderRepository {
  final reminderDao = ReminderDao();

  Future getAllReminders({String query}) =>
      reminderDao.getRemindersToday(query: query);

  Future getAllRemindersPerList({String query, String where}) =>
      reminderDao.getRemindersPerList(query: query, whereQuery: where);

  Future getAllRemindersDone() => reminderDao.getRemindersDone();

  Future<int> insertReminder(Reminder reminder) async {
    var result = await reminderDao.createReminder(reminder);
    return result;
  }

  Future updateReminder(Reminder reminder) =>
      reminderDao.updateReminder(reminder);

  Future deleteReminderById(int id) => reminderDao.deleteReminder(id);

  Future deleteAllReminders() => reminderDao.deleteAllReminders();
}
