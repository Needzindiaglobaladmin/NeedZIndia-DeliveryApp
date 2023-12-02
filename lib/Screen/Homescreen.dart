import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:needz_india_delivery/Screen/BookingHistory.dart';
import 'package:needz_india_delivery/Screen/DeliveryHistory.dart';
import 'package:needz_india_delivery/Screen/DeliveryItems.dart';
import 'package:needz_india_delivery/Screen/Login.dart';
import 'package:needz_india_delivery/Screen/MyAccount.dart';
import 'package:needz_india_delivery/Screen/BookingsSlots.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:needz_india_delivery/updateDetailsNotifier.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final newVersion = NewVersion(
    androidId: 'needz.needz_india_delivery',
  );
  static const simpleBehavior = true;

  @override
  void initState() {
    super.initState();
    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }
    userData();
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    print( newVersion.getVersionStatus());
    if (status != null) {
      newVersion.showUpdateDialog(
        allowDismissal: false,
        context: context,
        versionStatus: status,
        dialogTitle: 'Update available',
        dialogText: 'Update your app to explore new features',
        dismissButtonText: 'Download Now',
        dismissAction: () => appLink(),
      );
    }
  }

  appLink() async{
    String url = 'https://play.google.com/store/apps/details?id=needz.needz_india_delivery';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true,
        enableJavaScript: true,);
    } else {
      throw 'Could not launch $url';
    }
  }

  userData() async {
  final userDetails = Provider.of<UpdateDetailsNotifier>(context, listen: false);
  await userDetails.getJsonData();
  userDetails.loaded(false);
}



  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UpdateDetailsNotifier>(context);
    return Scaffold(
      backgroundColor:  Colors.blueGrey[50],
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: FittedBox(fit:BoxFit.fitWidth,
          child:GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()),
              );
            },
            child:Container(
              height: 65,
              width:110,
              child: Image.asset("assets/images/logo.ico",fit: BoxFit.contain
              ),
            ),
          ),
        ),
        backgroundColor: Colors.cyan[600],
      ),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/drawerpic.jpg"),
                          fit: BoxFit.cover)
                  ),
                  child: userDetails.loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)
                  ): Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children:<Widget> [
                            SizedBox(height: 5,),
                            Container(
                              child:CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage:userDetails.imageUrl == '' ? AssetImage('assets/images/avatar.png')
                                    :CachedNetworkImageProvider( userDetails.imageUrl + "?a="+ DateTime.now().millisecondsSinceEpoch.toString()),
                              ) ,
                            ),
                            Container(
                                alignment: Alignment.center,
                                child:Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(95, 0, 0, 0),
                                      child: Text('Hey,',style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),
                                      ),textAlign: TextAlign.center,),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child:userDetails.userName == '' ? Text(toBeginningOfSentenceCase('Dear' ),style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),
                                      ),textAlign: TextAlign.center,): Text(toBeginningOfSentenceCase(userDetails.userName),style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),
                                      ),textAlign: TextAlign.center,),
                                    ),
                                  ],
                                ) ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
              ListTile(
                leading: Icon(Icons.home_filled),
                title: Text('Home',style: GoogleFonts.quicksand(
                  textStyle: TextStyle(fontSize: 20),
                ),),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('My Account',style: GoogleFonts.quicksand(
                  textStyle: TextStyle(fontSize: 20),
                ),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MyAccount()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.lock_open),
                title: Text('Log Out',style: GoogleFonts.quicksand(
                  textStyle: TextStyle(fontSize: 20),
                ),),
                onTap: () async {
                  Navigator.pop(context);
                  var _prefs =await SharedPreferences.getInstance();
                  var token = _prefs.remove('token');
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Login()), (e) => false);
                },
              ),
            ]),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DeliveryItems()),
                  );
                },
                child: Container(
                  height: 100,
                  margin: EdgeInsets.fromLTRB(10,5,10,0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:Container(
                            child: Icon(Icons.delivery_dining,size: 80,color: Colors.blueGrey,),
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child:ListTile(
                            title: Text('Delivery Items', style: GoogleFonts.quicksand(
                              textStyle: TextStyle(fontSize: 30,color:  Colors.blueGrey),),),
                            trailing: Icon(Icons.navigate_next_rounded,color: Colors.blueGrey),
                          )
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DeliveryHistory()),
                  );
                },
                child: Container(
                  height:  100,
                  margin: EdgeInsets.fromLTRB(10,5,10,0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:Container(
                            child: Icon(Icons.shopping_bag,size: 80,color: Colors.blueGrey,),
                          )
                      ),
                      Expanded(
                          flex: 2,
                          child:ListTile(
                            title: Text('Delivery History', style: GoogleFonts.quicksand(
                              textStyle: TextStyle(fontSize: 30,color:  Colors.blueGrey),),),
                            trailing: Icon(Icons.navigate_next_rounded,color: Colors.blueGrey),
                          )
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> BookingSlots()),
                  );
                },
                child: Container(
                  height: 100,
                  margin: EdgeInsets.fromLTRB(10,5,10,0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:Container(
                            child: Icon(Icons.check_box_outlined,size: 80,color: Colors.blueGrey,),
                          )
                      ),
                      Expanded(
                        flex: 2,
                        child:ListTile(
                          title: Text('Bookings', style: GoogleFonts.quicksand(
                            textStyle: TextStyle(fontSize: 30,color:  Colors.blueGrey),),),
                          trailing: Icon(Icons.navigate_next_rounded,color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> BookingHistory()),
                  );
                },
                child: Container(
                  height: 100,
                  margin: EdgeInsets.fromLTRB(10,5,10,0),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child:Container(
                            child: Icon(Icons.check_circle,size: 80,color: Colors.blueGrey,),
                          )
                      ),
                      Expanded(
                        flex: 2,
                        child:ListTile(
                          title: Text('Bookings History', style: GoogleFonts.quicksand(
                            textStyle: TextStyle(fontSize: 30,color:  Colors.blueGrey),),),
                          trailing: Icon(Icons.navigate_next_rounded,color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
