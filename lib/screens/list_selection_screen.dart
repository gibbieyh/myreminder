import 'package:flutter/material.dart';
import 'package:myreminder/model/reminder.dart';
import 'package:myreminder/model/reminder_dao.dart';
import 'package:myreminder/screens/task_per_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListSelectionScreen extends StatefulWidget {
  @override
  _ListSelectionScreenState createState() => _ListSelectionScreenState();
}

class _ListSelectionScreenState extends State<ListSelectionScreen> {
  List<String> listOfList = [];
  List<Color> colours = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.green,
    Colors.cyan,
    Colors.brown,
    Colors.deepPurple,
    Colors.amberAccent,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.green,
    Colors.cyan,
    Colors.brown,
    Colors.deepPurple,
    Colors.amberAccent
  ];
  String selectedList;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  void _getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prefsList = (prefs.getStringList('myList') ?? List<String>());
    setState(() {
      listOfList = prefsList;
      selectedList = listOfList[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20, left: 15, bottom: 10),
              child: Text(
                'Your Lists',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            FlatButton(
              color: Colors.transparent,
              onPressed: () {
                _showAddList(context);
              },
              child: Row(
                children: [
                  Text('New List', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 5),
                  Icon(Icons.playlist_add, size: 18, color: Colors.white)
                ],
              ),
            )
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PerTaskScreen(
                  selectedList: '',
                ),
              ),
            );
            _getList();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[700],
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.control_point,
                color: Color(0xFFFDBC49),
              ),
              title: Text(
                'All Tasks',
                style: TextStyle(fontSize: 20),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              itemCount: listOfList.length,
              itemBuilder: (context, index) {
                var listItem = listOfList[index];
                return Dismissible(
                  resizeDuration: Duration(milliseconds: 500),
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[Text('delete'), Text('delete')],
                      ),
                    ),
                  ),
                  onDismissed: (direction) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    listOfList.removeAt(index);
                    await prefs.setStringList('myList', listOfList);
                    List<Reminder> reminders = await ReminderDao()
                        .getRemindersPerList(
                            query: selectedList, whereQuery: 'list');
                    for (var reminder in reminders) {
                      reminder.list = 'All Tasks';
                      await ReminderDao().updateReminder(reminder);
                    }

                    setState(() {});
                  },
                  key: ValueKey(listItem),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PerTaskScreen(
                            selectedList: listOfList[index] == '123AllTasks321'
                                ? ''
                                : listOfList[index],
                          ),
                        ),
                      );
                      _getList();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.control_point,
                          color: Colors.white,
                        ),
                        title: Text(
                          listOfList[index] == '123AllTasks321'
                              ? 'All Tasks'
                              : listOfList[index],
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showAddList(BuildContext context) {
    final _controllerAddList = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            color: Colors.transparent,
            child: Container(
              height: 230,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 15, top: 25.0, right: 15, bottom: 30),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _controllerAddList,
                            textInputAction: TextInputAction.newline,
                            maxLines: 4,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Family Trip...',
                              labelText: 'New List:',
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
                        IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            size: 33,
                            color: Color(0xFFFDBC49),
                          ),
                          onPressed: () {
                            setState(() {
                              listOfList.add(_controllerAddList.value.text);
                              _saveList();
                              Navigator.pop(context);
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myList', listOfList);
  }

  @override
  void dispose() {
    listOfList.clear();
    print('close');
    super.dispose();
  }
}
