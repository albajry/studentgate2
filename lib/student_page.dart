import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:studentgate2/global_variable.dart';


class StudentInfo extends StatefulWidget {
  @override
  _StudentInfo createState() => _StudentInfo();
}

class _StudentInfo extends State<StudentInfo> {
  Future<InfoAlbum> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
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
                        colors: <Color>[Colors.white70, Colors.blue],
                    )
                ),
              ),
            ),
            body: Center(
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Colors.blue.withOpacity(0.3)]
                        )),
                    child: SingleChildScrollView(
                        child: Stack(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: FutureBuilder<InfoAlbum>(
                                  future: futureAlbum,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data.success == 1) {
                                      return Column(children: <Widget>[
                                        TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            labelText:
                                            "الرقم : " + snapshot.data.studNo,
                                            labelStyle: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            labelText:
                                            "الاسم : " + snapshot.data.studName,
                                            labelStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            labelText: "الفرع : " +
                                                snapshot.data.branchName,
                                            labelStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            labelText: "الكلية : " +
                                                snapshot.data.facultyName,
                                            labelStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            labelText:
                                            "القسم : " + snapshot.data.deptName,
                                            labelStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            labelText: "البرنامج : " +
                                                snapshot.data.progName,
                                            labelStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            labelText: "المؤهل : " +
                                                snapshot.data.awardName,
                                            labelStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            labelText: "النظام : " +
                                                snapshot.data.modeName,
                                            labelStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                        TextField(
                                          textDirection: TextDirection.rtl,
                                          decoration: InputDecoration(
                                            labelText: "الحالة : " +
                                                snapshot.data.studStatus,
                                            labelStyle: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ]);
                                      //snapshot.data.title);
                                    } else if (snapshot.hasError) {
                                      return Text("${snapshot.error}");
                                    } else if (snapshot.hasData &&
                                        snapshot.data.success != 1) {
                                      return Text(' لا توجد بيانات');
                                    }

                                    // By default, show a loading spinner.
                                    return showProgress();//Center(child: CircularProgressIndicator());
                                  })),
                        ]))))));
  }
}

Future<InfoAlbum> fetchAlbum() async {
  final response = await http.get(myUrl);
  if (response.statusCode == 200) {
    return InfoAlbum.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class InfoAlbum {
  final String studNo;
  final String studName;
  final String studStatus;
  final String branchName;
  final String facultyName;
  final String deptName;
  final String progName;
  final String modeName;
  final String awardName;
  final int success;
  InfoAlbum(
      {this.studNo,
        this.studName,
        this.studStatus,
        this.branchName,
        this.facultyName,
        this.deptName,
        this.progName,
        this.modeName,
        this.awardName,
        this.success});
  factory InfoAlbum.fromJson(Map<String, dynamic> json) {
    return InfoAlbum(
      studNo: json['data']['studNo'],
      studName: json['data']['studName'],
      studStatus: json['data']['studStatus'],
      branchName: json['data']['branchName'],
      facultyName: json['data']['facultyName'],
      deptName: json['data']['deptName'],
      progName: json['data']['progName'],
      modeName: json['data']['modeName'],
      awardName: json['data']['awardName'],
      success: json['success'],
    );
  }
}

Widget showProgress() => Center(
  child: CircularProgressIndicator(
    backgroundColor: Colors.red,
  ),
);
