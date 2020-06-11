import 'package:flutter/material.dart';
import 'package:myreminder/screens/add_task_screen.dart';
import 'package:myreminder/screens/edit_screen.dart';
import 'package:myreminder/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Reminder',
      theme: ThemeData.dark()
          .copyWith(
            backgroundColor: Color(0xFF1b1b1b),
            textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Assistant',
                ),
            primaryTextTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Assistant',
                ),
            accentTextTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: 'Assistant',
                ),
          )
          .copyWith(accentColor: Color(0xFFFDBC49)),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add': (context) => AddScreen(),
        '/edit': (context) => EditScreen(),
      },
    );
  }
}
