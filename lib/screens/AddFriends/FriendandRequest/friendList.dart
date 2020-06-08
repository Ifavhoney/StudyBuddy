import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/model/BaseAuth.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  String currentUser;
  final db = Firestore.instance;

  List<String> allNames = [];

  void initState() {
    super.initState();
    Auth().getCurrentUser().then((firebaseUser) {
      this.currentUser = firebaseUser.email.toString();
    }).catchError((error) {
      this.currentUser = "dummy@gmail.com";
      //Re login
    });
  }

  Future getFriends() async {
    QuerySnapshot qn = await db
        .collection("Users").document(currentUser).collection('friends')
        .getDocuments();
    // QuerySnapshot qn = await db.collection("Users").where("Reason For Joining", isEqualTo: "Career").getDocuments();
    return qn.documents;
  }

  // void getFriendName(DocumentSnapshot doc) async {
  //   DocumentSnapshot snapshot = await db.collection('CRUD').document(doc.documentID).get();
  //   allNames.add(snapshot.data['First Name'] + " " + snapshot.data['Last Name']);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(child: new Center(
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: FutureBuilder(
                  future: getFriends(),
                  builder: (BuildContext _, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return new Text("Loading...");
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext _, int index) {
                            //getFriendName(snapshot.data[index]);
                            return Card(
                              elevation: 5,
                              color: Colors.white30,
                              shape: new RoundedRectangleBorder(
                                side: new BorderSide(
                                    color: Colors.green, width: 2.0),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: new ListTile(
                                leading: new Icon(Icons.person),
                                title: Text(
                                  snapshot.data[index].data['email'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                subtitle: Text(
                                  '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                
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