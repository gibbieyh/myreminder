import 'package:flutter/material.dart';
import 'task_dialog.dart';

// ignore: must_be_immutable
class DismissibleTaskCard extends StatefulWidget {
  DismissibleTaskCard(
      {this.objectKey,
      this.dismissDirection,
      this.onDismiss,
      this.onTapped,
      this.widgetOverdue});

  Function(DismissDirection) onDismiss;
  Function onTapped;
  DismissDirection dismissDirection;
  Widget widgetOverdue;
  var objectKey;

  @override
  _DismissibleTaskCardState createState() => _DismissibleTaskCardState();
}

class _DismissibleTaskCardState extends State<DismissibleTaskCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Delete",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Delete",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        color: Colors.redAccent,
      ),
      onDismissed: widget.onDismiss,
      direction: widget.dismissDirection,
      key: new ObjectKey(widget.objectKey),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[600], width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          dense: true,
          leading: InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              setState(widget.onTapped);
            },
            child: Container(
              //decoration: BoxDecoration(),
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: widget.objectKey.isDone
                  ? Icon(
                      Icons.radio_button_checked,
                      size: 30.0,
                      color: Color(0xFFFDBC49),
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      size: 30.0,
                      color: Colors.white,
                    ),
            ),
          ),
          title: Text(
            widget.objectKey.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 20,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                decoration: widget.objectKey.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          subtitle: widget.objectKey.detail != null
              ? IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.objectKey.detail,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w500,
                              decoration: widget.objectKey.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ),
                      ),
                      widget.widgetOverdue,
                    ],
                  ),
                )
              : widget.widgetOverdue,
          trailing: IconButton(
              icon: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white70,
                ),
              ),
              onPressed: () {
                showAddDialog(context, widget.objectKey);
              }),
        ),
      ),
    );
  }
}
