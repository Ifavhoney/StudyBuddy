import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:study_buddy/data/data.dart';
import 'package:study_buddy/helpers/camPortalValidation.dart';
import 'package:study_buddy/helpers/debug_helper.dart';
import 'package:study_buddy/screens/webcam/Peer2Stranger/cam.dart';

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
  bool isConfirmed = false;

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
      this.user = "dummy@gmail.com";
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _showButton() async {
    await CamPortalValidation.isValidateAppointment(databaseUtil, user, context)
        .whenComplete(() {
      if (CamPortalValidation.camCredentialModel.errorText == "success") {
        /*
        CamPortalValidation.toWebcam(
            CamPortalValidation.camCredentialModel, context);
            */
        setState(() {
          isConfirmed = true;
        });
      } else {
        setState(() {
          isConfirmed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          leading: Container(),
          title: Text("Calendar"),
          actions: <Widget>[
            FutureBuilder(
              future: _showButton(),
              // initialData: databaseUtil.getConfirmationData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (isConfirmed == true) {
                  return Icon(Icons.camera);
                } else {
                  return Icon(Icons.ac_unit);
                }
              },
            ),
            /*
          IconButton(
                    icon: Icon(Icons.videocam),
                    onPressed: () {
                      /*
                showDialog(
                  context: context,
                  builder: (_) => CamPortal(user),
                );
                */
                    },
                  )
                IconButton(
                    icon: Icon(Icons.alarm),
                    onPressed: () {},
                  )
                  */
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
        //Displays 7 snapshots of the awaiting table, and thus showing 7 cards
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 18, 0, 30),
          child: FirebaseAnimatedList(
              query: _database1.orderByKey().limitToFirst(7).startAt(dates[0]),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int i) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[showCard(snapshot, i)],
                  ),
                );
              }),
        ));
  }

  Widget showCard(DataSnapshot dateSnapshot, int i) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 30, 50, 20),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 10,
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          child: Card(
            color: Colors.teal.shade200,
            child: InkWell(
              //Link the correct date to the calendar portal using Snapshot.key
              onDoubleTap: () {
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
                    child: FirebaseAnimatedList(
                        primary: true,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: false,
                        query: _database2.orderByKey(),
                        itemBuilder: (BuildContext context, DataSnapshot res,
                            Animation<double> animation, int i) {
                          //res.key is the random generated key
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
                                      mainAxisSize: MainAxisSize.min,
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
}
