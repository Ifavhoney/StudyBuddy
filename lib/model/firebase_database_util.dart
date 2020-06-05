import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

/*
This class needs work 
Some methods  don't belong here like initState
*/
class FirebaseDatabaseUtil {
  //Childs in our database
  String child1 = 'Peer2Strangers';
  String child2 = 'Appointments';
  String child3 = 'Awaiting';

  DatabaseReference _database;

  FirebaseDatabase database = new FirebaseDatabase();

  DatabaseError error;

  static final FirebaseDatabaseUtil _instance =
      new FirebaseDatabaseUtil.internal();

  FirebaseDatabaseUtil.internal();

  factory FirebaseDatabaseUtil() {
    return _instance;
  }
  void initState() {
    // Demonstrates configuring to the database using a file
    _database = FirebaseDatabase.instance
        .reference()
        .child(child1)
        .child(child2)
        .child(child3);

    /*Dont know what to do with this so far
        print(child1);
    database.setPersistenceCacheSizeBytes(100);
    database.setPersistenceEnabled(true);
    _database.keepSynced(true);
    _messageSubscription = _database.onChildAdded.listen((Event event) {
      error = null;
    });
    */
  }

  DatabaseReference getDay() {
    return _database;
  }

  Future<void> deleteAppointmentGivenKey(DatabaseReference database,
      String selectedDate, String time, String key, dynamic appointment) async {
    return await database.child(selectedDate).child(time).child(key).remove();
  }

  Future<void> updateAppointmentGivenKey(DatabaseReference database,
      String selectedDate, String time, String key, dynamic appointment) async {
    return await database
        .child(selectedDate)
        .child(time)
        .child(key)
        .set(appointment.toJson());
  }

  Future<void> insertConfirmation(DatabaseReference database,
      String selectedDate, String time, dynamic appointment) async {
    return await database.push().set(appointment.toJson());
  }

  Future<void> insertAppointment(DatabaseReference database,
      String selectedDate, String time, dynamic appointment) async {
    return await database
        .child(selectedDate)
        .child(time)
        .push()
        .set(appointment.toJson());
  }

  Future<DataSnapshot> getConfirmationData(DatabaseReference database) async {
    return await database.once();
  }

  Future<DataSnapshot> getAwaitingApppointmentsData(
      DatabaseReference database, String selectedDate, String time) async {
    return await database.child(selectedDate).child(time).once();
  }

  void dispose() {
    //_messageSubscription.cancel();
  }
}
