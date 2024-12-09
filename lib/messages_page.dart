// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:studentgate2/global_variable.dart';


class MyMessages extends StatefulWidget {
  @override
  _MyMessages createState() => _MyMessages();
}

class _MyMessages extends State<MyMessages> {
  String myMsgTitle, myMsgBody, myMsgDate;
  Future<MessageList> futureMessage;
  @override
  void initState() {
    super.initState();
    futureMessage = fetchInfoMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('المواد الدراسية'),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Colors.white70, Colors.blue])),
              ),
            ),
            body: Center(
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              Colors.blue.withOpacity(0.3)
                            ])),
                    child: FutureBuilder<MessageList>(
                        future: futureMessage,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data.result == 1) {
                            return ListView.builder(
                                itemCount: snapshot.data.message.length == null
                                    ? 0
                                    : snapshot.data.message.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 10,
                                    color: Colors.white70.withOpacity(0.6),
                                    margin: const EdgeInsets.fromLTRB(
                                        15, 10, 15, 0),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child: FlatButton(
                                                  color: Colors.transparent,
                                                  onPressed: () async {
                                                    myMsgTitle = snapshot
                                                        .data
                                                        .message[index]
                                                    ['msgTitle']
                                                        .toString();
                                                    myMsgBody = snapshot
                                                        .data.message[index]
                                                    ['msgBody'];
                                                    myMsgDate = snapshot
                                                        .data.message[index]
                                                    ['msgDate'];
                                                    _showMessage();
                                                  },
                                                  child: Text(
                                                    snapshot
                                                        .data
                                                        .message[index]
                                                    ['msgTitle']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  snapshot.data
                                                      .message[index]['msgDate']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.red),
                                                  textAlign: TextAlign.left,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                          return showProgress();//Center(child: CircularProgressIndicator());
                        })))));
  }

  void _showMessage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text(myMsgTitle),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Colors.white70, Colors.blue])),
                ),
              ),
              backgroundColor: Colors.white,
              body: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.blue.withOpacity(0.3)
                              ])),
                      child: Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(myMsgBody,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            myMsgDate,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        )
                      ]))));
        }, // ...to here.
      ),
    );
  }
}


Future<MessageList> fetchInfoMessage() async {
  var myUrl = basicUrl + 'ws_get_message_info.php?receipt=' + studNo;
  final response = await http.get(myUrl);
  if (response.statusCode == 200) {
    return MessageList.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class MessageList {
  final List message;
  final int result;
  MessageList({this.message, this.result});
  factory MessageList.fromJson(Map<String, dynamic> json) {
    return MessageList(
      message: json['data'],
      result: json['success'],
    );
  }
}

Widget showProgress() => Center(
  child: CircularProgressIndicator(
    backgroundColor: Colors.red,
  ),
);