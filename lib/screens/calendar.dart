import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_buddy/model/calendar/Appointments/confirmed.dart';
import 'package:study_buddy/model/calendar/appointments/awaiting.dart';
import 'webcam/camPortal.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'calendarPortal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:study_buddy/model/firebase_database_util.dart';
import 'calendarStatus.dart';
//cupertino_picker

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String child1 = 'Peer2Strangers';
  String child2 = 'Appointments';
  String child3 = 'Awaiting';
  String child4 = 'Confirmed';
  DateTime now;
  int week = 7;
  //DateFormat dateFormat = DateFormat("E, MMMM d y");
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DatabaseReference _database2 = FirebaseDatabase.instance.reference();
  DatabaseReference _database1 = FirebaseDatabase.instance.reference();

  List<String> dates = [];
  String user;
  bool hasNotBooked = false;

  TextEditingController channelName = new TextEditingController();
  String initialText;
  String errorText;
  String hintText = "Enter Channel Name";
  String buttonText;
  bool disableButton;

  FirebaseDatabaseUtil databaseUtil;
  @override
  void initState() {
    disableButton = true;
    super.initState();
    initialText = "Double tab to book";
    int i = 0;
    now = DateTime.now();
    dates.add(dateFormat.format(now).toString());
    //should be a method in data
    while (i != week) {
      dates.add(dateFormat.format(now.add(Duration(days: i + 1))).toString());
      i += 1;
    }

    Auth().getCurrentUser().then((firebaseUser) {
      this.user = firebaseUser.email.toString();
    }).catchError((error) {
      this.user = "Blob@gmail.com";
      //Re login
    });

    databaseUtil = new FirebaseDatabaseUtil();
    databaseUtil.initState();
    _database1 = _database1.child(child1).child(child2).child(child3);

    _database2 = _database2.child(child1).child(child2).child(child4);

    //Read through Awaiting, if it shows false, update the card
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    databaseUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: Container(),
          title: Text("Calendar"),
          actions: <Widget>[
            IconButton(
              icon: disableButton == true ? Icon(null) : Icon(Icons.videocam),
              onPressed: disableButton == true
                  ? null
                  : () {
                      //Does something
                      showDialog(
                        context: context,
                        builder: (_) => CamPortal(),
                      );
                    },
            )
          ],
        ),
        floatingActionButton: RaisedButton(
          child: Text(
            "View Status",
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            MaterialPageRoute route = MaterialPageRoute(builder: (context) {
              return CalendarStatus(user);
            });
            Navigator.of(context).push(route);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 30),
          child: FirebaseAnimatedList(
              query: _database1.orderByKey().limitToFirst(7).startAt(dates[0]),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int i) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[showCard(snapshot, i)],
                  ),
                );
              }),
        ));
  }

  Widget showCard(DataSnapshot dateSnapshot, int i) {
    if (dateSnapshot.value.toString().length >= 2) {}

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 10,
        child: Container(
          height: MediaQuery.of(context).size.height / 8,
          child: Card(
            color: Colors.teal.shade200,
            child: InkWell(
              onDoubleTap: () {
                print(this.user);
                showDialog(
                    context: this.context,
                    builder: (context) => CalendarPortal(
                          selectedDate: dateSnapshot.key,
                          user: this.user,
                        ));
              },
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  //WHERE WE ENTER KEY
                  ListTile(
                    title: Text(
                      dateSnapshot.key,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    leading: Icon(Icons.calendar_today),
                    trailing: Icon(
                      Icons.touch_app,
                      color: Colors.teal.shade100,
                      size: 30,
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          initialText,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    //Not the same as the usual once query (key)
                    //VERIFY you are in the correct key or you may face issues

                    child: FirebaseAnimatedList(
                        primary: true,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: false,
                        query: _database2.orderByKey(),
                        itemBuilder: (BuildContext context, DataSnapshot res,
                            Animation<double> animation, int i) {
                          return FutureBuilder<DataSnapshot>(
                            future: _database2.child(res.key).once(),
                            builder: (BuildContext context, snapshot) {
                              String channel;
                              String date;
                              String time;
                              List<dynamic> users;

                              //-----

                              //Can be improved using a method
                              if (snapshot.hasData) {
                                //Only if the time exists in the confirm collection
                                if (dateSnapshot.key ==
                                    snapshot.data.value["date"]) {}
                                //shows where the user has an apppointment
                                if (snapshot.data.value["users"]
                                        .toString()
                                        .contains(user) &&
                                    dateSnapshot.key ==
                                        snapshot.data.value["date"]) {
                                  channel = snapshot.data.value["channelName"]
                                      .toString();
                                  date = snapshot.data.value["date"];
                                  time = snapshot.data.value["time"];
                                  users = snapshot.data.value["users"];
                                }
                                //Shows where the user does not have an appointment

                                else if (!snapshot.data.value["users"]
                                    .toString()
                                    .contains(user)) {}
                              }
                              return time != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                              colorBrightness: Brightness.dark,
                                              color: Theme.of(context)
                                                  .buttonColor
                                                  .withBlue(255),
                                              onPressed: () {},
                                              child: Text(time)),
                                        )
                                      ],
                                    )
                                  : Text("");
                            },
                          );
                        }),
                  )

                  //Display correct content
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),

            // the box shawdow property allows for fine tuning as aposed to shadowColor
            boxShadow: [
              new BoxShadow(
                  color: Colors.lightBlue.shade100,
                  // offset, the X,Y coordinates to offset the shadow
                  offset: new Offset(0.0, 10.0),
                  // blurRadius, the higher the number the more smeared look
                  blurRadius: 30.0,
                  spreadRadius: 4.0)
            ],
          ),
        ),
      ),
    );
  }

  Widget confirmedData(DataSnapshot res) {
    //used for keeping track of changes
    List<String> userData;
    //Proving we have data @ that exact location or else it'll throw an error
    if (res.value.toString().length >= 2) {
      Map<dynamic, dynamic> values;
      values = res.value;
      return Container();
    } else {
      return Container();
    }
  }

  Future<DataSnapshot> getUserData(
      DatabaseReference database, String selectedDate) async {
    return await database.child(selectedDate).once();
  }
}
