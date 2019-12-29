import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:study_buddy/model/calendar/Appointments/awaiting.dart';

class CalendarPortal extends StatefulWidget {
  final String selectedDate;
  final String user;

  CalendarPortal({this.selectedDate, this.user});
  @override
  _CalendarPortalState createState() => _CalendarPortalState();
}

class _CalendarPortalState extends State<CalendarPortal>
    with SingleTickerProviderStateMixin {
  //Childs in our database
  String child1 = 'Peer2Strangers';
  String child2 = 'Appointments';
  String child3 = 'Awaiting';
  List<Awaiting> _list;
  DateTime dateTime = DateTime(2020, 1, 1, 0, 0);
  String time;

  TextEditingController _goal = new TextEditingController();
  String errorText;
  //neccessary to set the duration of our animation
  AnimationController controller;
  //0-1 indicates wether running or completed
  Animation<double> scaleAnimation;
  DatabaseReference _database = FirebaseDatabase.instance.reference();

  //Listens to when changes happen
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  Query _query;

  @override
  void initState() {
    super.initState();
    _database = _database.child(child1).child(child2).child(child3);
/*
    _query = _database
        .reference()
        .child(child1)
        .child(child2)
        .child(child3)
        .child(widget.selectedDate)
        .orderByChild("user")
        .equalTo(widget.user);
        */
    /*Occurs when a child is added -> listens to method
    _onTodoAddedSubscription = _query.onChildAdded.listen(onEntryAdded);
  */
    /*Occurs when a child is changed -> Listens to method
    _onTodoChangedSubscription = _query.onChildChanged.listen(onEntryChanged);
*/
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

/*
  @override
  void dispose() {
    // TODO: implement dispose
    _onTodoAddedSubscription.cancel();
   // _onTodoChangedSubscription.cancel();
    super.dispose();
  }

*/

  /*
  onEntryChanged(Event event){
    var oldEntry = 
  }
  */

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
                                    onDateTimeChanged: (currentTime) {
                                      setState(() {
                                        DateFormat _df = DateFormat.Hm();
                                        this.time = _df.format(currentTime);
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
                              addAppointment(
                                time == null ? "0:00" : time,
                                "nuthsaid@gmail.com",
                                _goal.text,
                              );
                              //Firebase
                            })
                      ],
                    ))),
          ),
        ),
      ),
    );
  }

  void addAppointment(String time, String users, String goals) {
    if (goals.isEmpty) {
      setState(() {
        errorText = "Text cannot be empty";
      });
    } else {
      Awaiting awaiting = Awaiting(user: users, goal: goals, hasMatched: false);

      //Reads through database & returns one value
      _database
          .child(widget.selectedDate)
          .child(time)
          .once()
          .then((DataSnapshot snapshot) {
        //Meaning nobody has chosen at that time
        if (snapshot.value == null) {
          //insert

          _database
              .child(widget.selectedDate)
              .child(time)
              .push()
              .set(awaiting.toJson());
        } else {
          //Read

          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key, values) {
            print(values["hasMatched"]);
          });
        }
      });
    }
  }
}
