import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:studentgate2/global_variable.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';



class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>  {
  final myController = TextEditingController();
  Future<MessageCount> futureMessage;
  @override
  void initState() {
    futureMessage = fetchCountMessage();
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //setState(() {
      //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
   // });
    return new Center( //Directionality(
      //textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('بوابة الطالب'),
              // actions: [
              //   IconButton(icon: Icon(Icons.settings),
              //       onPressed:
              //       _pushSaved
              //   ),
              // ],
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
                            colors: [Colors.white, Colors.blue.withOpacity(0.3)]
                        )
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          myUrl = basicUrl +
                                              'ws_get_student_info.php?studNo=' + studNo;
                                          Navigator.of(context).pushNamed('/students');
                                        },
                                        child: Image.asset('assets/images/student.png'),
                                      ),
                                      Center(
                                          child: Text(
                                            "بيانات الطالب",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xAA000000),
                                                fontWeight: FontWeight.bold),
                                          )
                                      ),
                                    ]
                                ),
                                Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          if(feeStatus == 1) {
                                            Navigator.of(context).pushNamed('/classList');
                                          }else{
                                            _showToast(context,'معذرة نتائجك محجوبة من قبل المالية');
                                          }
                                        },
                                        child: Image.asset('assets/images/graduated.png'),
                                      ),
                                      Center(
                                          child: Text(
                                            "درجات الطالب",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xAA000000),
                                                fontWeight: FontWeight.bold),
                                          )
                                      ),
                                    ]
                                )
                              ]
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(

                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed('/messages');
                                      },
                                      child: Stack(
                                        children: [
                                          Image.asset('assets/images/message.png'),
                                          FutureBuilder<MessageCount>(
                                            future: futureMessage,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                if(snapshot.data.msgCount != 0) {
                                                  return CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    radius: 15,
                                                    child: Text(snapshot
                                                        .data.msgCount.toString(),
                                                      style: new TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0),),
                                                  );
                                                }else{
                                                  return CircleAvatar(
                                                    radius: 0,
                                                  );
                                                }
                                              }
                                              return CircleAvatar(
                                                radius: 0,
                                              );
                                            }
                                          ),
                                        ],
                                      )
                                    ),
                                    Center(
                                        child: Text(
                                          "الرسائل والاخطارات",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xAA000000),
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    ),
                                  ]
                                ),
                                Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _showToast(context, 'هذه الصفحة تحت الإنشاء');
                                          //Navigator.of(context).pushNamed('/financial');
                                        },
                                        child: Image.asset('assets/images/money.png'),
                                      ),
                                      Center(
                                          child: Text(
                                            "البيانات المالية",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xAA000000),
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                      ),
                                    ]
                                )
                              ]
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _launchURL();
                                          //Navigator.of(context).pushNamed('/financial');
                                        },
                                        child: Image.asset('assets/images/browser.png'),
                                      ),
                                      Center(
                                          child: Text(
                                            "موقع بوابة الطالب",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xAA000000),
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                      ),
                                    ]
                                ),
                                // new FlatButton(
                                //     onPressed: _launchURL,

                                // async{
                                //   String value = await Navigator.push(context, new MaterialPageRoute<String>(
                                //       builder: (BuildContext context) {
                                //         return AlertDialog(
                                //                 title: Text("المتغيرات"),
                                //                 content: TextFormField(
                                //                     controller: myController,
                                //                     onSaved: (value) => studNo = value,    // <= NEW
                                //                     keyboardType: TextInputType.text,
                                //                     style: TextStyle(fontSize: 20),
                                //                     textAlign: TextAlign.start,
                                //                     autofocus: true,
                                //                     decoration: InputDecoration(
                                //                         contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                                //                         hintText: "المتغيرات المطلوبة",
                                //                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                                //                     )
                                //                 ),
                                //                 actions: [
                                //                   FlatButton(
                                //                     child: Text("موافق"),
                                //                     onPressed: (){
                                //                       Navigator.pop(context,myController.text);
                                //                     },
                                //                   )
                                //                 ],
                                //               );
                                //             }
                                //         )
                                //   );
                                //   _showToast(context, myController.text);
                                //   //_showToast(context, value);
                                //    },
                                //   child: new Text("موقع بوابة الطالب",
                                //     style: TextStyle(fontSize: 18,
                                //       color: Color(0xAA0000FF),
                                //       decoration: TextDecoration.underline,
                                //     ),
                                //   )
                                // ),
                                // Text('https://ustye.net',
                                //   style: TextStyle(fontSize:18.0,
                                //       color: Color(0xFF0000FF)),)
                              ]
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     RaisedButton(
                          //       onPressed: (){
                          //         _showCustomDialog(context,"أدخل القيمة");
                          //       },
                          //       child: Text('Dialog'),
                          //     )
                          //   ],
                          // )
                        ])
                ))
        )
    );
  }

  // void _pushSaved() {
  //   Navigator.pushNamed(context, '/setup');
  // }

  _launchURL() async {
    const url = 'https://ustye.net/portal';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showToast(context,'عفوا تعذر فتح الموقع المطلوب');
    }
  }
}

Widget showProgress() => Center(
  child: CircularProgressIndicator(
    backgroundColor: Colors.red,
  ),
);

// void _showDialog(BuildContext context,String myMsg){
//   showDialog(
//       context: context,
//       builder: (BuildContext context){
//         return AlertDialog(
//           title: Text("Alert Dialog"),
//           content: Text(myMsg),
//         );
//       }
//   );
// }
void _showToast(BuildContext context,String myMsg) {
  Toast.show(
      myMsg, context,
      duration: Toast.LENGTH_LONG,
      gravity:  Toast.BOTTOM,
      backgroundColor: Color(0xFF770000),
      textColor: Colors.white,
      backgroundRadius:32.0
  );

  // Fluttertoast.showToast(
  //     msg: msg,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 13,
  //     backgroundColor: Color(0xFF770000),
  //     textColor: Colors.white,fontSize: 18.0,
  //     backgroundRadius:16.0	);
}

Future<MessageCount> fetchCountMessage() async {
  var myUrl = basicUrl + 'ws_get_message_count.php?receipt=' + studNo;
  final response = await http.get(myUrl);
  if (response.statusCode == 200) {
    return MessageCount.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class MessageCount {
  final int msgCount;
  final int result;
  MessageCount({this.msgCount, this.result});
  factory MessageCount.fromJson(Map<String, dynamic> json) {
    return MessageCount(
      msgCount: json['data'],
      result: json['success'],
    );
  }
}

class AlreadyRead {
  final int msgId;
  final String msgBody;
  final int msgDate;

  AlreadyRead({this.msgId, this.msgBody, this.msgDate});
}


// void _showCustomDialog(BuildContext context,String msg){
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//               borderRadius:
//               BorderRadius.circular(20.0)), //this right here
//           child: Container(
//             height: 200,
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(msg,style: TextStyle(fontSize: 18.0,color: Colors.black),),
//                   TextField(
//                     decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: 'ماذا تريد أن تتذكر؟'),
//                   ),
//                   SizedBox(
//                     width: 320.0,
//                     child: RaisedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         "موافق",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       color: const Color(0xFF1BC0C5),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         );
//       });
// }
