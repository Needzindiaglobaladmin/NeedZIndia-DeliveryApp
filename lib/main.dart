import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:needz_india_delivery/DeliveryDetailsListener.dart';
import 'package:needz_india_delivery/Screen/Homescreen.dart';
import 'package:needz_india_delivery/updateDetailsNotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => UpdateDetailsNotifier()),
                ChangeNotifierProvider(create: (context) => DeliveryDetailsListener()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(accentColor:  Colors.cyan[600],),
                title: 'NeedZ',
                home: SplashScreen(),
                builder: (BuildContext context, Widget widget) {
                  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                    return buildError(context, errorDetails);
                  };

                  return widget;
                },
              ),
            );
          },
        );
      },
    );
  }
}

Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 100,),
                Flexible(
                  child: Container(
                    //margin: EdgeInsets.all(10),
                    child: Image.asset('assets/images/No_internet.png'),
                  ),
                ),
                Text("Something Went Wrong", style: GoogleFonts.quicksand(
                  textStyle: TextStyle(fontSize: 20,color: Colors.black,fontWeight:FontWeight.bold),
                ),),
              ],
            ),
          )
      )
  );
}

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    if (token != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.cyan[600],
      body: Container(
        child: Center(
          child: new Column(children: <Widget>[
            Flexible(child: SizedBox(height: 200),),
            Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 120,),
                    new Image.asset(
                      'assets/images/logo.ico',
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                      width: 170.0,
                    ),
                    SizedBox(height: 10,),
                    Text('Ab Ghar baithe milegi har suvidha',
                        style: GoogleFonts.dancingScript(
                            textStyle: TextStyle(fontSize: 25),
                            color: Colors.white)),
                  ],
                )
            ),
            Flexible(child: SizedBox(height: 230),),
            Flexible(
              child: Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
              ),),
          ]),),
      ),
    );
  }
}
