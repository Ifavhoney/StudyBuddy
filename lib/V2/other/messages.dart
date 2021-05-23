import 'package:buddy/V2/other/sizeConfig.dart';
import 'package:buddy/layout/orrin/model/user.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

/*
class MessageList extends StatefulWidget {
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {

  final List<User> getUsers = User.userList();

  Widget userCard(User user, BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(),
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 12.62,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.safeBlockVertical * 1,
              bottom: SizeConfig.safeBlockVertical * 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Material(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(80.0)),
                    elevation: 5,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(user.image),
                      backgroundColor: Colors.white,
                      radius: SizeConfig.blockSizeHorizontal * 8,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 37,
                        child: new Text(
                          user.firstName + " " + user.lastName,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                          ),
                        ),
                      ),
                      Container(
                        width: SizeConfig.blockSizeHorizontal * 37,
                        child: new Text(
                          "Insert message here",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.video_call,
                    color: Colors.blue,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Colors.blue,
                  ),
                  onPressed: null,
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(0, SizeConfig.safeBlockVertical * 8, 0, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Material(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(25.0),
                    ),
                    elevation: 3,
                    child: Container(
                      width: SizeConfig.blockSizeHorizontal * 60,
                      height: SizeConfig.blockSizeVertical * 5.2,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                              SizeConfig.safeBlockVertical * 2, 0, 0, 0),
                          prefixIcon: Icon(Icons.search),
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(25.0),
                            ),
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: SizeConfig.safeBlockVertical * 2.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Material(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(80.0)),
                      elevation: 5,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: SizeConfig.blockSizeHorizontal * 8,
                        child: new Icon(
                          Icons.person,
                          size: SizeConfig.blockSizeHorizontal * 6,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Expanded(
                child: ListView.builder(
                    itemCount: getUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return userCard(getUsers[index], context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

}

  */
