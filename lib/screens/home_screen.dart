import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myreminder/screens/done_screen.dart';
import 'package:myreminder/screens/today_task.dart';
import 'package:myreminder/screens/list_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> homePages = [
    DoneScreen(),
    TodayTaskScreen(),
    ListSelectionScreen()
  ];
  int currentPageValue = 1;
  PageController _controller = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: homePages.length,
              onPageChanged: (int page) {
                getChangedPageAndMoveBar(page);
              },
              controller: _controller,
              itemBuilder: (context, index) {
                return homePages[index];
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: Colors.grey, width: 0.3),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Put some widgets or buttons here for improvements
              Container(
                margin: EdgeInsets.only(bottom: 0, top: 35),
                height: 15,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < homePages.length; i++)
                      if (i == currentPageValue) ...[circleBar(true)] else
                        circleBar(false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: FloatingActionButton(
          elevation: 5.0,
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          backgroundColor: Color(0xFFFDBC49),
          child: Icon(
            Icons.add,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 120),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Color(0xFFffca6b) : Color(0xFFe3e3e3),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
