import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CalendarPortal extends StatefulWidget {
  final String selectedDate;
  final String user;

  CalendarPortal({this.selectedDate, this.user});
  @override
  _CalendarPortalState createState() => _CalendarPortalState();
}

class _CalendarPortalState extends State<CalendarPortal>
    with SingleTickerProviderStateMixin {
  DateTime dateTime = DateTime(2020, 1, 1, 0, 0);

  TextEditingController _goal = new TextEditingController();
  String errorText;
  //neccessary to set the duration of our animation
  AnimationController controller;
  //0-1 indicates wether running or completed
  Animation<double> scaleAnimation;
  final DatabaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    //CurvedAnimation makes Animations smoother (think curve graph as oppose to linear)
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    //Calls the animation whenever an animation changes - Set state rebuilds
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _goal,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).appBarTheme.color),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(width: 1)),
                              errorText: this.errorText,
                              hintText: "Enter Your Goal"),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 50, 0),
                          child: Container(
                            height: 40,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.access_time),
                                Expanded(
                                  child: CupertinoDatePicker(
                                    minuteInterval: 30,
                                    use24hFormat: true,
                                    initialDateTime: dateTime,
                                    mode: CupertinoDatePickerMode.time,
                                    onDateTimeChanged: (time) {
                                      setState(() {
                                        this.dateTime = time;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                            child: Text(
                              "Book",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              //Firebase
                            })
                      ],
                    ))),
          ),
        ),
      ),
    );
  }
}
