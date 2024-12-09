import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:studentgate2/login_page.dart';
import 'package:studentgate2/student_page.dart';
import 'package:studentgate2/classes_page.dart';
import 'package:studentgate2/messages_page.dart';

final ThemeData iOSTheme = ThemeData(
  primaryColor : Colors.red,
  accentColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme = ThemeData(
  primaryColor: Colors.blue[800],
  accentColor: Colors.green[100],
);

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar", "AE")
      ],
      theme: defaultTargetPlatform == TargetPlatform.iOS
        ? iOSTheme
        : androidTheme,
      home: new LoginPage(),
      routes: <String, WidgetBuilder> {
        '/students' : (BuildContext context) => new StudentInfo(),
        '/classList' : (BuildContext context) => new ListOfClass(),
        '/messages' : (BuildContext context) => new MyMessages(),
        // '/financial' : (BuildContext context) => new CarouselDemo(),//MyTest(),
        // '/setup' : (BuildContext context) => new MySetup()
      },
    );
  }
}



// void _showToast(BuildContext context,String myMsg) {
//   Toast.show(
//       myMsg, context,
//       duration: Toast.LENGTH_LONG,
//       gravity:  Toast.BOTTOM,
//       backgroundColor: Color(0xFF770000),
//       textColor: Colors.white,
//       backgroundRadius:32.0
//   );
//
//   // Fluttertoast.showToast(
//   //     msg: msg,
//   //     toastLength: Toast.LENGTH_SHORT,
//   //     gravity: ToastGravity.BOTTOM,
//   //     timeInSecForIosWeb: 13,
//   //     backgroundColor: Color(0xFF770000),
//   //     textColor: Colors.white,fontSize: 18.0,
//   //     backgroundRadius:16.0	);
// }

// void _showSnack(BuildContext context,String myMsg) {
//   final scaffold = Scaffold.of(context);
//   scaffold.showSnackBar(
//     SnackBar(
//       content: Text(myMsg),
//       action: SnackBarAction(
//           label: 'تراجع', onPressed: scaffold.hideCurrentSnackBar),
//     ),
//   );
// }

// class DialogBuilder {
//   DialogBuilder(this.context);
//   final BuildContext context;
//   void showLoadingIndicator(String text) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return WillPopScope(
//             onWillPop: () async => false,
//             child: AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8.0))),
//               backgroundColor: Colors.black87,
//               content: LoadingIndicator(text: text),
//             ));
//       },
//     );
//   }
//
//   void hideOpenDialog() {
//     Navigator.of(context).pop();
//   }
// }

// class LoadingIndicator extends StatelessWidget {
//   LoadingIndicator({this.text = ''});
//
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     var displayedText = text;
//
//     return Container(
//         padding: EdgeInsets.all(16),
//         color: Colors.black87,
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _getLoadingIndicator(),
//               _getHeading(context),
//               _getText(displayedText)
//             ]));
//   }
//
//   Padding _getLoadingIndicator() {
//     return Padding(
//         child: Container(
//             child: CircularProgressIndicator(strokeWidth: 3),
//             width: 32,
//             height: 32),
//         padding: EdgeInsets.only(bottom: 16));
//   }
//
//   Widget _getHeading(context) {
//     return Padding(
//         child: Text(
//           'Please wait …',
//           style: TextStyle(color: Colors.white, fontSize: 16),
//           textAlign: TextAlign.center,
//         ),
//         padding: EdgeInsets.only(bottom: 4));
//   }
//
//   Text _getText(String displayedText) {
//     return Text(
//       displayedText,
//       style: TextStyle(color: Colors.white, fontSize: 14),
//       textAlign: TextAlign.center,
//     );
//   }
// }
