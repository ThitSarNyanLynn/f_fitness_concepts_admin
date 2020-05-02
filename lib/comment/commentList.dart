import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:f_fitness_concepts_admin/comment/showComment.dart';
import 'package:f_fitness_concepts_admin/globals.dart';
import 'package:f_fitness_concepts_admin/model/adminComment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class AdminCommentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AdminCommentListState();
}

class AdminCommentListState extends State<AdminCommentList> {
  var formatter = new DateFormat('MMM dd');

  String _errTitle = '';
  String _errDetail = '';
  Widget _commentListWidget;
  //true for local, false for internet
  bool _localOrInternet;


  @override
  void initState() {
    super.initState();
    //_getCommentList();
    //_serverConnectCheck();
    _checkWifiConnect();
  }

  bool _serverConnect = false;

  void _checkWifiConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      print("wifi connect");
      // I am connected to a wifi network.
      _serverConnectCheck();
    } else if (connectivityResult == ConnectivityResult.mobile) {
      print("mobile internet connect");
      // I am connected to a mobile network.
      _internetConnectCheck();
    } else {
      setState(() {
        _serverConnect = false;
        _errTitle = 'Not connected to wifi';
        _errDetail = 'Please connect to server with wifi.';
      });
    }
  }

  Future<List<AdminCommentModel>> _getLocalServerCmtList() async {
    List<AdminCommentModel> commentList = [];
    //final Map<String, dynamic> jsonResponse = json.decode(response.body);

    print('here at _getLocalServerCmtList');

    final response =
        await http.post("$localServerLink" + "getComment.php", body: {
      "MemberNo": memberNo.toString(),
    });
    print('before we decode');
    print(response.body);
    //here, u will get, ClassName,ClassInfo,ClassTime,Fees,TrainerName
    var jsonResponse = json.decode(response.body);
    print("json response is $jsonResponse");

    for (var r in jsonResponse) {
      AdminCommentModel rj = AdminCommentModel(
        memberName: r["MemberName"],
        trainerName: r["TrainerName"],
        comment: r["Comment"],
        commentDate: r["logDateTime"],
      );
      commentList.add(rj);
    }
    print("length is ${commentList.length}");
    print("pending form list is $commentList");
    return commentList;
  }

  Future<List<AdminCommentModel>> _getInternetServerCmtList() async {
    List<AdminCommentModel> commentList = [];
    //final Map<String, dynamic> jsonResponse = json.decode(response.body);

    print('here at _getInternetServerCmtList');

    final response =
        await http.post("$internetServerLink" + "getComment.php", body: {
      "MemberNo": memberNo.toString(),
    });
    print('before we decode');
    print(response.body);
    //here, u will get, ClassName,ClassInfo,ClassTime,Fees,TrainerName
    var jsonResponse = json.decode(response.body);
    print("json response is $jsonResponse");

    for (var r in jsonResponse) {
      AdminCommentModel rj = AdminCommentModel(
        memberName: r["MemberName"],
        trainerName: r["TrainerName"],
        comment: r["Comment"],
        commentDate: r["logDateTime"],
      );
      commentList.add(rj);
    }
    print("length is ${commentList.length}");
    print("pending form list is $commentList");
    return commentList;
  }

  Future<void> _serverConnectCheck() async {
    //bool _serverConnection=false;
    try {
      final _localServerResponse =
          await http.post("$localServerLink" + "checkConnect.php");
      var _localServerResult = json.decode(_localServerResponse.body);
      //server connected
      if (_localServerResult[0]['Test'] == "OK") {
        print('local server connected');

        setState(() {
          _serverConnect = true;
          _localOrInternet=true;
        });
        //call method to get comment list from local server
        _getLocalServerCmtList();
      } else {print('local server check fail');
        _internetConnectCheck();
      }
    } on SocketException catch (_) {
      //Not connected to server
      print('not server connected');

      setState(() {
        _serverConnect = false;
        _errTitle = 'Local Server Connection Fail';
        _errDetail = 'Connection to local server failed. Please connect to server with wifi.';
      });
    }
  }

  Future<void> _internetConnectCheck() async {
    try {
      final _internetServerResponse =
          await http.post("$internetServerLink" + "checkConnect.php");
      var _internetServerResult = json.decode(_internetServerResponse.body);
      if (_internetServerResult[0]['Test'] == "OK") {
        print('internet server connected');

        setState(() {
          _serverConnect = true;
          _localOrInternet=false;
        });
        //call method to get comment list from local server
        _getInternetServerCmtList();
      } else {
        print('internet server check fail');
        setState(() {
          _serverConnect = false;
          _errTitle = 'Internet Server Connection Fail';
          _errDetail = 'Connection to internet server failed. Please connect to server with wifi.';
        });
      }
    } on SocketException catch (_) {
      //Not connected to server
      print('not internet server connected');

      setState(() {
        _serverConnect = false;
        _errTitle = 'Internet Server Connection Fail';
        _errDetail = 'Connection to internet server failed. Please connect to server with wifi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment List"),
      ),
      body: _serverConnect
          ? FutureBuilder<List<AdminCommentModel>>(
              future: _localOrInternet?_getLocalServerCmtList():_getInternetServerCmtList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.length == 0) {
                  return Center(
                    child: Text(
                      "There is no comment.",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 16),
                    ),
                  );
                } else if (snapshot.data != null) {
                  print("found data here");
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      DateTime readyDate =
                          DateTime.parse(snapshot.data[index].commentDate);
                      return ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(formatter.format(readyDate)),
                            Text(readyDate.year.toString()),
                          ],
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                Text(snapshot.data[index].memberName),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 4.0)),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.fitness_center,
                                  color: Colors.grey,
                                ),
                                Text(
                                  snapshot.data[index].trainerName,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: GestureDetector(
                          child: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            print("this will be sent ${snapshot.data[index]}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowComment(
                                          adminCommentModel:
                                              snapshot.data[index],
                                        )));
                          },
                        ),
                      );
                    },
                  );
                }
                return Container(
                  alignment: AlignmentDirectional.center,
                  child: CircularProgressIndicator(),
                );
              })
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _errTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 20)),
                    Text(
                      _errDetail,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    RaisedButton(
                        child: Icon(Icons.refresh),
                        onPressed: () {
                          _checkWifiConnect();
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}
