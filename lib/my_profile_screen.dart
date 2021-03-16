import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/constant.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>  with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  SharedPreferences pref;
  String userName = "";
  String email = "";
  String mobileNo = "";
  String imageUrl = "";
  bool isImageUrlNull = true;

  TextEditingController _controllerMemberName,_controllerMobileNo,_controllerEmailId;

  @override
  void initState() {
    super.initState();
    getSharedPrefData();
  }

  getSharedPrefData() async {
    pref = await SharedPreferences.getInstance();
    userName = pref.getString("userName");
    email = pref.getString("emailId");
    mobileNo = pref.getString("mobileNo");
    imageUrl = pref.getString("userImg");
    String adharCardImg = pref.getString("adharCardImg");
    String panCardImg = pref.getString("panCardImg");

    _controllerMemberName = new TextEditingController(text: userName);
    _controllerMobileNo = new TextEditingController(text: mobileNo);
    _controllerEmailId = new TextEditingController(text: email);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Profile", style: TextStyle(color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 2.0,
        ),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
//                  new Container(
//                    height: 250.0,
//                    color: Colors.white,
//                    child: new Column(
//                      children: <Widget>[
//
//                        Padding(
//                          padding: EdgeInsets.only(top: 20.0),
//                          child:  Stack(fit: StackFit.loose, children: <Widget>[
//                             Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                 Container(
//                                    width: 140.0,
//                                    height: 140.0,
//                                    decoration:  BoxDecoration(
//                                      shape: BoxShape.circle,
//                                      image:
//                                       DecorationImage(
//                                        image: NetworkImage(imageUrl != null ? imageUrl:""),
//                                        fit: BoxFit.cover,
//                                      ),
//                                    ),
//                                ),
//                              ],
//                            ),
//                            Padding(
//                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
//                                child:  Row(
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  children: <Widget>[
//                                    InkWell(
//                                      onTap:(){
//                                        CommonMethods.showColoredToast("Camera Clicked", Colors.blueAccent);
//                                      },
//                                      child: new CircleAvatar(
//                                        backgroundColor: Colors.red,
//                                        radius: 25.0,
//                                        child: new Icon(
//                                          Icons.camera_alt,
//                                          color: Colors.white,
//                                        ),
//                                      ),
//                                    )
//                                  ],
//                                )),
//                          ]),
//                        )
//                      ],
//                    ),
//                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Parsonal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                      controller: _controllerMemberName,

                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                      enabled: !_status,
                                      controller: _controllerEmailId,
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: !_status,
                                      controller: _controllerMobileNo,
                                    ),
                                  ),
                                ],
                              )),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  left: 25.0, right: 25.0, top: 25.0),
//                              child: new Row(
//                                mainAxisSize: MainAxisSize.max,
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: <Widget>[
//                                  Expanded(
//                                    child: Container(
//                                      child: new Text(
//                                        'Pin Code',
//                                        style: TextStyle(
//                                            fontSize: 16.0,
//                                            fontWeight: FontWeight.bold),
//                                      ),
//                                    ),
//                                    flex: 2,
//                                  ),
//                                  Expanded(
//                                    child: Container(
//                                      child: new Text(
//                                        'State',
//                                        style: TextStyle(
//                                            fontSize: 16.0,
//                                            fontWeight: FontWeight.bold),
//                                      ),
//                                    ),
//                                    flex: 2,
//                                  ),
//                                ],
//                              )),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  left: 25.0, right: 25.0, top: 2.0),
//                              child: new Row(
//                                mainAxisSize: MainAxisSize.max,
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: <Widget>[
//                                  Flexible(
//                                    child: Padding(
//                                      padding: EdgeInsets.only(right: 10.0),
//                                      child: new TextField(
//                                        decoration: const InputDecoration(
//                                            hintText: "Enter Pin Code"),
//                                        enabled: !_status,
//                                      ),
//                                    ),
//                                    flex: 2,
//                                  ),
//                                  Flexible(
//                                    child: new TextField(
//                                      decoration: const InputDecoration(
//                                          hintText: "Enter State"),
//                                      enabled: !_status,
//                                    ),
//                                    flex: 2,
//                                  ),
//                                ],
//                              )),
                          !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        callAPI();

                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
//        setState(() {
//          _status = false;
//        });
      },
    );
  }

  void callAPI() {
    //call update profie and then change status
    _status = true;
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
