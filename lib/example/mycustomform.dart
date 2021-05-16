// Define a custom Form widget.
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  //The controller of my form
  final myController = TextEditingController();

  //The response of the API request
  String _response = 'No answer';

  //Call of the hello function

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await fetchPost();
          return showDialog(
              context: context,
              child: AlertDialog(
                  title: Text('Alert'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('The answer'),
                        Text(_response),
                      ],
                    ),
                  )));
        },
        child: Icon(Icons.add_alert),
      ),
    );
  }

  fetchPost() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('hello',
        options: HttpsCallableOptions(timeout: Duration(seconds: 5)));
    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'message': myController.text,
        },
      );
      // DebugHelper.red(result.data['response']);
      setState(() {
        _response = result.data;
      });
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
  }
}
