class Reminder {
  int id;
  String title;
  String detail; //todo: there must be at least something here
  String list;
  int remindDate;
  int dueDate;
  bool isDone = false;
  Reminder(
      {this.id,
      this.title,
      this.dueDate,
      this.remindDate,
      this.detail,
      this.list,
      this.isDone = false});
  factory Reminder.fromDatabaseJson(Map<String, dynamic> data) => Reminder(
        id: data['id'],
        title: data['title'],
        detail: data['detail'],
        remindDate: data['remind_date'],
        dueDate: data['due_date'],
        list: data['list'],
        isDone: data['is_done'] == 0 ? false : true,
      );
  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "title": this.title,
        "detail": this.detail,
        "remind_date": this.remindDate,
        "due_date": this.dueDate,
        "list": this.list,
        "is_done": this.isDone == false ? 0 : 1,
      };
}
