import 'dart:async';
import 'dart:convert';
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

  String _noServerTitle = 'Not connected to server';
  String _noServerDetail = 'Please connect to server with Wifi.';

  @override
  void initState() {
    super.initState();
    //_getCommentList();
    _serverConnectCheck();
  }

  bool _serverConnect = false;

  Future<List<AdminCommentModel>> _getCommentList() async {
    List<AdminCommentModel> commentList = [];
    //final Map<String, dynamic> jsonResponse = json.decode(response.body);

    print('here at search init button click');

    final response = await http.post("$localServerLink" + "getComment.php", body: {
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
    try {
      final _connectSrv = await http.post("$localServerLink" + "checkConnect.php");
      var _connectResult = json.decode(_connectSrv.body);
      //server connected
      if (_connectResult[0]['Test'] == "OK") {
        print('server connected');

        setState(() {
          _serverConnect = true;
        });
      }
    } on SocketException catch (_) {
      //Not connected to server
      print('not server connected');

      setState(() {
        _serverConnect = false;
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
          future: _getCommentList(),
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
                            Icon(Icons.person,color: Colors.grey,),
                            Text(snapshot.data[index].memberName),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 4.0)),
                        Row(
                          children: <Widget>[
                            Icon(Icons.fitness_center,color: Colors.grey,),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _noServerTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(margin: EdgeInsets.only(top: 20)),
            Text(
              _noServerDetail,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            RaisedButton(
                child: Icon(Icons.refresh),
                onPressed: () {
                  _serverConnectCheck();
                }),
          ],
        ),
      ),
    );
  }
}
