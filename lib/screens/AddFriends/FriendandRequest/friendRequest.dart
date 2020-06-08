import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/model/BaseAuth.dart';

class FriendRequest extends StatefulWidget {
  @override
  _FriendRequestState createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  String currentUser;
  final db = Firestore.instance;

  @override
  void initState() {
    Auth().getCurrentUser().then((firebaseUser) {
      this.currentUser = firebaseUser.email.toString();
    }).catchError((error) {
      this.currentUser = "dummy@gmail.com";
      //Re login
    });
    super.initState();
  }

  Future getRequests() async {
    QuerySnapshot qn = await db
        .collection("friendRequests")
        .where("reciever", isEqualTo: currentUser)
        .getDocuments();
    // QuerySnapshot qn = await db.collection("Users").where("Reason For Joining", isEqualTo: "Career").getDocuments();
    return qn.documents;
  }

  acceptUserDialog(BuildContext context, String user, DocumentSnapshot doc) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text("Accept Request?"),
                  new SizedBox(
                    height: 20,
                  ),
                  new RaisedButton(
                      child: Text("Yessir"),
                      onPressed: () {
                        addFriend(user, doc);
                        print(currentUser + "    " + user);
                        MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => FriendRequest());
                        Navigator.of(context).pop(route);
                      }),
                ],
              );
            }),
          );
        });
  }

  void addFriend(String recieverUser, DocumentSnapshot doc) async {
    DocumentReference ref = await db
        .collection('Users')
        .document(currentUser)
        .collection('friends')
        .add({'email': recieverUser});
    DocumentReference ref2 = await db
        .collection('Users')
        .document(recieverUser)
        .collection('friends')
        .add({'email': currentUser});

    await db.collection('friendRequests').document(doc.documentID).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: FutureBuilder(
                  future: getRequests(),
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
                                  snapshot.data[index].data['sender'],
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
                                onTap: () => acceptUserDialog(
                                    context,
                                    snapshot.data[index].data['sender'],
                                    snapshot.data[index]),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
