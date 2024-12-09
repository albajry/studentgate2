import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:studentgate2/global_variable.dart';


class ListOfCourses extends StatefulWidget {
  final String myClass;
  ListOfCourses(this.myClass);
  @override
  _ListOfCourses createState() => _ListOfCourses(myClass);
}

class _ListOfCourses extends State<ListOfCourses> {
  final nameStyle = const TextStyle(fontSize: 20.0,
    color: Color(0xFF998800),
    fontWeight: FontWeight.bold,
  );
  final scoreStyle = const TextStyle(fontSize: 18.0,
    color: Color(0xFF00A000),
    fontWeight: FontWeight.bold,
  );
  final String myClass;
  _ListOfCourses(this.myClass);
  Future<CoursesInfo> futureCourses;
  @override
  void initState() {
    futureCourses = fetchCoursesInfo(myClass);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: FutureBuilder<CoursesInfo>(
                    future: futureCourses,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data.result == 1) {
                        return ListView.builder(
                            itemCount: snapshot.data.courses.length == null
                                ? 0
                                : snapshot.data.courses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: MediaQuery.of(context).size.width*0.8,
                                margin: EdgeInsets.fromLTRB(8.0,6.0,8.0,0.0),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.lightBlueAccent.withOpacity(0.4),
                                              Colors.white70.withOpacity(0.4)
                                            ]),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(snapshot.data
                                                  .courses[index]['course']
                                                  .toString(),
                                            style: nameStyle,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(snapshot.data
                                              .courses[index]['degree']
                                              .toString(),
                                              style: scoreStyle
                                          ),
                                          Text(snapshot.data
                                              .courses[index]['status']
                                              .toString(),
                                              style: scoreStyle
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
                    })
            )
        )
    );
  }
}

Future<CoursesInfo> fetchCoursesInfo(String myClass) async {
  var myUrl = basicUrl +
      'ws_get_last_semester.php?studNo=' +
      studNo +
      '&semName=' +
      myClass;
  final response = await http.get(myUrl);
  if (response.statusCode == 200) {
    return CoursesInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class CoursesInfo {
  final List courses;
  final int result;
  CoursesInfo({this.courses, this.result});
  factory CoursesInfo.fromJson(Map<String, dynamic> json) {
    return CoursesInfo(
      courses: json['data'],
      result: json['success'],
    );
  }
}

Widget showProgress() => Center(
  child: CircularProgressIndicator(
    backgroundColor: Colors.red,
  ),
);