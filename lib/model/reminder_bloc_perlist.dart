import 'package:myreminder/model/reminder.dart';
import 'reminder_repository.dart';

import 'dart:async';

class ReminderBlocPerList {
  //Get instance of the Repository
  final _repository = ReminderRepository();

  final _controller = StreamController<List<Reminder>>.broadcast();

  get reminders => _controller.stream;

  ReminderBlocPerList() {
    getRemindersPerList();
  }

  getRemindersPerList({String query, String where}) async {
    // add data reactively by using sink to stream
    _controller.sink.add(
        await _repository.getAllRemindersPerList(query: query, where: where));
  }

  addReminder(Reminder reminder) async {
    await _repository.insertReminder(reminder);
    getRemindersPerList();
  }

  updateReminder(Reminder reminder, String query, String where) async {
    await _repository.updateReminder(reminder);
    getRemindersPerList(query: query, where: where);
  }

  deleteReminderById(int id, String query, String where) async {
    _repository.deleteReminderById(id);
    getRemindersPerList(query: query, where: where);
  }

  dispose() {
    _controller.close();
  }
}
