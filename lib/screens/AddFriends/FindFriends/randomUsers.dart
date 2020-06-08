import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/model/BaseAuth.dart';

class RandomUsers extends StatefulWidget {
  @override
  _RandomUsersState createState() => _RandomUsersState();
}

class _RandomUsersState extends State<RandomUsers> {
  String currentUser;
  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
    Auth().getCurrentUser().then((firebaseUser) {
      this.currentUser = firebaseUser.email.toString();
    }).catchError((error) {
      this.currentUser = "dummy@gmail.com";
      //Re login
    });
  }

  Future getUsers() async {
    QuerySnapshot qn = await db.collection("Users").getDocuments();
    //QuerySnapshot qn = await db.collection("Users").where("Reason For Joining", isEqualTo: "Career").getDocuments();
    return qn.documents;
  }

  addUserDialog(BuildContext context, String user) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text("Add as a friend?"),
                  new SizedBox(
                    height: 20,
                  ),
                  new RaisedButton(
                    child: Text("Yessir"),
                    onPressed: () {
                    addFriendRequest(user);
                    print(currentUser + "    " + user);
                    Navigator.of(context).pop(context);
                  }),
                ],
              );
            }),
          );
        });
  }

  void addFriendRequest(String reciverUser) async {
    DocumentReference ref = await db
        .collection('friendRequests')
        .add({'sender': currentUser, 'reciever': reciverUser});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
        child: new Column(
          children: <Widget>[
            new Expanded(
                child: FutureBuilder(
                    future: getUsers(),
                    builder: (BuildContext _, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Text("Loading...");
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext _, int index) {
                              return Card(
                                elevation: 5,
                                color: Colors.white30,
                                shape: new RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: new ListTile(
                                  leading: new Icon(Icons.person),
                                  title: Text(
                                    snapshot.data[index].data['First Name'] + " " + snapshot.data[index].data['Last Name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    snapshot.data[index].documentID,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  onTap: () => addUserDialog(
                                      context, snapshot.data[index].documentID),
                                ),
                              );
                            });
                      }
                    })),
          ],
        ),
      ),
    );
  }
}
