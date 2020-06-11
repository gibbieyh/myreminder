import 'package:myreminder/model/reminder.dart';
import 'reminder_repository.dart';

import 'dart:async';

class ReminderBloc {
  //Get instance of the Repository
  final _repository = ReminderRepository();

  // Controller acts as an admin that control the stream form its subscriber
  final _controller = StreamController<List<Reminder>>.broadcast();

  get reminders => _controller.stream;

  ReminderBloc() {
    getReminders();
  }

  getReminders({String query}) async {
    // add data reactively by using sink to stream
    _controller.sink.add(await _repository.getAllReminders(query: query));
  }

  addReminder(Reminder reminder) async {
    var result = await _repository.insertReminder(reminder);
    getReminders();
    return result;
  }

  updateReminder(Reminder reminder) async {
    await _repository.updateReminder(reminder);
  }

  deleteReminderById(int id) async {
    _repository.deleteReminderById(id);
  }

  dispose() {
    _controller.close();
  }
}
