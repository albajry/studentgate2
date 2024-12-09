import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:studentgate2/global_variable.dart';
import 'package:studentgate2/courses_page.dart';


class ListOfClass extends StatefulWidget {
  @override
  _ListOfClass createState() => _ListOfClass();
}

class _ListOfClass extends State<ListOfClass> {
  final _biggerFont = const TextStyle(fontSize: 25.0, color: Colors.white,
  );
  Future<ClassInfo> futureClass;

  @override
  void initState() {
    futureClass = fetchClassInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('الفصول الدراسية'),
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
                        colors: [Colors.white, Colors.blue.withOpacity(0.3)])),
                child: FutureBuilder<ClassInfo>(
                    future: futureClass,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data.result == 1) {
                        return ListView.builder(
                            itemCount: snapshot.data.classNo.length == null
                                ? 0
                                : snapshot.data.classNo.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(20, 6, 20, 6),
                                  child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Color(0xff01A0C7).withOpacity(0.4),
                                      child: MaterialButton(
                                        padding: EdgeInsets.all(15.0),
                                        onPressed: () async {
                                          String myClass = snapshot.data
                                              .classNo[index]['semName'].toString();
                                          Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ListOfCourses(myClass)),
                                            );
                                          },
                                        child: Text('الفصل '+
                                            snapshot.data
                                                .classNo[index]['semName'].toString(),
                                            style: _biggerFont,
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ));
                            });
                      }
                      return showProgress();//Center(child: CircularProgressIndicator());
                    })
            )
        )
    );
  }
}

Future<ClassInfo> fetchClassInfo() async {
  var myUrl = basicUrl + 'ws_get_semester_name.php?studNo=' + studNo;
  final response = await http.get(myUrl);
  if (response.statusCode == 200) {
    return ClassInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class ClassInfo {
  final List classNo;
  final int result;
  ClassInfo({this.classNo, this.result});
  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      classNo: json['data'],
      result: json['success'],
    );
  }
}

Widget showProgress() => Center(
  child: CircularProgressIndicator(
    backgroundColor: Colors.red,
  ),
);
