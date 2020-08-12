import 'dart:async';

import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/layout/home/model/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseUtil {
  //reference
  DatabaseReference _counterRef;
  DatabaseReference _userRef;
  //listeners?
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  FirebaseDatabase database = FirebaseDatabase();
  int _counter;
  DatabaseError error;
  static final FirebaseDatabaseUtil _instance =
      new FirebaseDatabaseUtil.internal();

  FirebaseDatabaseUtil.internal();

  factory FirebaseDatabaseUtil() {
    return _instance;
  }
  void initState() {
    //literally no difference between those two
    _counterRef = FirebaseDatabase.instance.reference().child("counter");
    _userRef = database.reference().child("user");

    database.reference().child("counter").once().then((DataSnapshot snapshot) {
      DebugHelper.red("connected to counter database");
    });
    //Cache + allows for information to be downloaded when network
    database.setPersistenceEnabled(true);
    //basically keeps the data offline, and downloads online when ready
    _counterRef.keepSynced(true);
    //constantly listen for information
    _counterSubscription = _counterRef.onValue.listen((event) {
      DebugHelper.red("Fires when this reference has been updated");
      error = null;
      _counter = event.snapshot.value ?? 0;
    }, onError: (Object o) {
      error = o;
    });
  }

  DatabaseError getError() {
    return error;
  }

  DatabaseReference getUser() {
    return _userRef;
  }

  int getCounter() {
    return _counter;
  }

  addUser(User user) async {
    final TransactionResult transactionResult =
        await _counterRef.runTransaction((mutableData) async {
      //It will increment
      mutableData.value = (mutableData.value ?? 0) + 1;
      return mutableData;
    });
    if (transactionResult.committed) {
      _userRef.push().set(<String, String>{
        "name": user.name,
        "age": user.age,
        "email": user.email,
        "mobile": user.mobile
      }).then((value) => DebugHelper.green("Transaction comitted"));
    } else {
      DebugHelper.red("Transaction did not commit: \n" + error.message);
    }
  }

  void deleteUser(User user) async {
    await _userRef
        .child(user.id)
        .remove()
        .then((value) => {DebugHelper.green("tranaction committed")});
  }

  void updateUser(User user) async {
    _userRef.child(user.id).update({
      "name": user.name,
      "age": user.age,
      "email": user.email,
      "mobile": user.mobile
    }).then((value) => DebugHelper.green("Transaction committed"));
  }

  void dispose() {
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }
}
