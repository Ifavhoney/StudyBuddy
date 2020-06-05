import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/data/data.dart';
import 'package:study_buddy/helpers/debug_helper.dart';
import 'package:study_buddy/reusableWidgets/animations/popUp.dart';

class Cam extends StatefulWidget {
  final String channelName;
  final Duration duration;

  Cam({this.channelName, this.duration});
  @override
  _CamState createState() => _CamState();
}

class _CamState extends State<Cam> {
  //list of user IDs
  static final _users = <int>[];
  //Webcam Info for debugging purposes
  final _infoStrings = <String>[];
  //For our tooblar
  bool muted = false;
  int _min = 0;
  int _start = 0;

  Timer _primaryTimer;
  Timer _secondaryTimer;

  //dispose() is called when the State object is removed
  @override
  void dispose() {
    super.dispose();
    _users.clear();

    if (_primaryTimer.isActive) {
      _primaryTimer.cancel();
    }
    if (_primaryTimer.isActive == false) {
      _secondaryTimer.cancel();
    }

    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
  }

  @override
  void initState() {
    _min = int.parse(widget.duration.inMinutes.toString());
    startPrimaryTimer();

    super.initState();
    initialize();
  }

  void startPrimaryTimer() {
    _primaryTimer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      if (_min < 2) {
        _primaryTimer.cancel();
        setState(() {
          _start = 60;
        });
        startSecondaryTimer();
      } else {
        setState(() {
          _min = _min - 1;
        });
      }
    });

    //return new Timer(duration, endTimer);
  }

  void startSecondaryTimer() {
    _secondaryTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_start < 1) {
        _secondaryTimer.cancel();
        Navigator.of(context).pop();
      } else {
        setState(() {
          _start = _start - 1;
        });
      }
    });

    //return new Timer(duration, endTimer);
  }

  endTimer() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Column(
          children: <Widget>[
            Text(
              "Time Remaining: ",
              //   style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              _primaryTimer.isActive == true
                  ? "$_min minutes"
                  : "$_start seconds",
              //   style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //ADD NAME
              /*
              Text("Time Remaining: "),
              Text("$_min min"),
              */
            ],
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Stack(
          children: <Widget>[_viewRows(), _tooblar()],
        ),
      ),
    );
  }

  Future<void> initialize() async {
    if (Data.APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add("APP_ID is missing, include in webcam/data.dart");
        _infoStrings.add("Agora Engine will not start");
      });
      return;
    } else {
      setState(() {
        _infoStrings.clear();
      });
      await _initAgoraRtcEngine();
      _addAgoraEventHandlers();
      await AgoraRtcEngine.enableWebSdkInteroperability(true);
      await AgoraRtcEngine.setParameters('''
{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
      await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
    }
  }

  //Create an Agora Instance given the App_ID & start video
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(Data.APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  void _addAgoraEventHandlers() {
    //For errors (May not neccessarly break code)
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        _infoStrings.add(code);
      });
    };
    //occurs when somebody joins
    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      setState(() {
        _infoStrings.add("Join Channel: $channel, uid: $uid");
      });
    };
    //occurs when somebody leaves (would make more sense if this were a bool method)
    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };
    //Occurs when somebody joins
    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        _infoStrings.add("User's ID: $uid");
        _users.add(uid);
      });
    };
    //in comparision to onleave channel, this provides info wether a poor connection involved
    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        _infoStrings.add("user may have lost connection, $uid");
        _users.remove(uid);
      });
    };
    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  ///Returns a list of views to be used when sizing video views
  List<Widget> _getRenderViews() {
    final list = [
      AgoraRenderWidget(
        0,
        local: true,
        preview: true,
      ),
    ];

    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Our Video View
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  ///Takes full advantage of width of device
  Widget _expandedViewRow(List<Widget> views) {
    final rowedView = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: rowedView,
      ),
    );
  }

  ///video layout
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedViewRow([views[0]]),
            _expandedViewRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedViewRow(views.sublist(0, 2)),
            _expandedViewRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedViewRow(views.sublist(0, 2)),
            _expandedViewRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  ///tooblar represents our icon
  Widget _tooblar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              _onToggleMute();
            },
            child: Icon(muted ? Icons.mic : Icons.mic_off,
                color: muted ? Colors.white : Colors.blueAccent),
            shape: CircleBorder(),
            elevation: 3.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  ///Mutes Self
  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  //Will do something once it exists using firebase
  _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }
}
