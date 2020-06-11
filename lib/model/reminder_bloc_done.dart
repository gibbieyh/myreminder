import 'package:myreminder/model/reminder.dart';
import 'reminder_repository.dart';

import 'dart:async';

class ReminderBlocDone {
  //Get instance of the Repository
  final _repository = ReminderRepository();

  final _controller = StreamController<List<Reminder>>.broadcast();

  get reminders => _controller.stream;

  ReminderBlocDone() {
    getRemindersDone();
  }

  getRemindersDone() async {
    // add data reactively by using sink to stream
    _controller.sink.add(await _repository.getAllRemindersDone());
  }

  addReminder(Reminder reminder) async {
    await _repository.insertReminder(reminder);
    getRemindersDone();
  }

  updateReminder(Reminder reminder) async {
    await _repository.updateReminder(reminder);
    getRemindersDone();
  }

  deleteReminderById(int id) async {
    _repository.deleteReminderById(id);
    getRemindersDone();
  }

  dispose() {
    _controller.close();
  }
}
