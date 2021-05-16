import 'package:buddy/layout/orrin/sharedWidgets/sizeConfig.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String gender = 'Male';
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.fromLTRB(0, SizeConfig.safeBlockVertical * 2, 0,
            SizeConfig.safeBlockVertical * 3),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Material(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(80.0)),
                  elevation: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: SizeConfig.blockSizeHorizontal * 13,
                    child: new Icon(
                      Icons.person,
                      size: SizeConfig.blockSizeHorizontal * 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 1),
              Text(
                "Add a Profile Picture",
                style: TextStyle(
                  fontFamily: 'Open-Sans',
                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                ),
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 1),
              Form(
                key: _formKey,
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Material(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                          elevation: 3,
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 85,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  hintText: "First Name"),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 2),
                        Material(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                          elevation: 3,
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 85,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  hintText: "Last Name"),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 2),
                        Material(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                          elevation: 3,
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 85,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  hintText: "Email Address"),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 2),
                        Material(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                          elevation: 3,
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 85,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  hintText: "Password"),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 2),
                        Material(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                          elevation: 3,
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 85,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  hintText: "Confirm Password"),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Material(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                              elevation: 3,
                              child: Container(
                                height: SizeConfig.blockSizeVertical * 5,
                                width: SizeConfig.blockSizeHorizontal * 38,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          25, 0, 0, 0),
                                      border: new OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(30.0),
                                        ),
                                      ),
                                      hintText: "Age"),
                                ),
                              ),
                            ),
                            Material(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                              elevation: 3,
                              child: Container(
                                height: SizeConfig.blockSizeVertical * 5,
                                width: SizeConfig.blockSizeHorizontal * 38,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          25, 0, 0, 0),
                                      border: new OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(30.0),
                                        ),
                                      ),
                                      hintText: "Gender"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 2),
                        Material(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                          elevation: 3,
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 85,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: new InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),
                                  hintText: "Select City"),
                            ),
                          ),
                        ),
                        Container(
                          height: SizeConfig.blockSizeVertical * 7.2,
                          width: SizeConfig.blockSizeHorizontal * 85,
                          child: CheckboxListTile(
                            title: Text("I have read the terms and condition",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 3.5,
                                )),
                            value: _isChecked,
                            onChanged: (val) {
                              setState(() {
                                _isChecked = val;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 1),
                        RaisedButton(
                          padding: const EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.white),
                          ),
                          child: Container(
                              width: SizeConfig.blockSizeHorizontal * 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFe4b9fa),
                                    Color(0xFFd9b9fa),
                                    Color(0xFFb9bffa)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text("REGISTER",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                5)),
                              ),
                              padding: EdgeInsets.all(
                                  SizeConfig.safeBlockHorizontal * 3)),
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
