import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:needz_india_delivery/Class/DeliveryItemsResponse.dart';
import 'package:needz_india_delivery/Screen/BookedSlotDetails.dart';
import 'package:needz_india_delivery/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class BookingHistory extends StatefulWidget {
  @override
  _BookingHistory createState() => _BookingHistory();
}

class _BookingHistory extends State<BookingHistory> {
  List<Bookings> bookingsDetails =[];
  bool loading = true;
  bool load = false;
  int offset =0;
  final scrollController = ScrollController();
  var mobile;

  @override
  void initState() {
    super.initState();
    GetDeliveryItems();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        offset++;
        GetDeliveryItemsOffset();
        print("marked");
      }
    });
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<DeliveryItemsResponse> GetDeliveryItems() async {
    var _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    mobile = _prefs.getString('mobile');
    var now = new DateTime.now();
    var pastDate = now.subtract(Duration(days: 7));
    var formatter = new DateFormat('yyyy-MM-dd');
    var startDate = formatter.format(pastDate);
    var ending =  now.subtract(Duration(days: 1));
    var endDate = formatter.format(ending);
    print(startDate);
    print(endDate);
    try{
      Map<String, String> queryParameters = {
        'offset': offset.toString(),
        'mobile':  mobile,
        'startDate': startDate,
        'endDate': endDate,
      };
      var uri =
      Uri.https(Constant.URL, '/api/getMyDeliveries.php',queryParameters);
      print(uri);
      final response = await http.get((uri),
        headers: <String, String>{HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
      );
      print("${response.body}");
      var response1 = DeliveryItemsResponse.fromJson(json.decode(response.body));
      if (response1.success == true) {
        if(mounted){
          setState(() {
            bookingsDetails = response1.data.bookings;
            loading = false;
          });
        }
        return response1;
      } else {
        Toast.show(response1.userFriendlyMessage ,context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        if(mounted){
          setState(() {
            loading = false;
          });
        }
      }
    }on Exception catch (e){
      Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }


  Future<DeliveryItemsResponse> GetDeliveryItemsOffset() async {
    if(!load){
      if(mounted){
        setState(() {
          load = true;
        });
      }
      var _prefs = await SharedPreferences.getInstance();
      var token = _prefs.getString('token');
      var mobile = _prefs.getString('mobile');
      var now = new DateTime.now();
      var pastDate = now.subtract(Duration(days: 7));
      var formatter = new DateFormat('yyyy-MM-dd');
      var startDate = formatter.format(pastDate);
      var ending =  now.subtract(Duration(days: 1));
      var endDate = formatter.format(ending);
      print(startDate);
      print(endDate);
      try{
        Map<String, String> queryParameters = {
          'offset': offset.toString(),
          'mobile':  mobile,
          'startDate': startDate,
          'endDate': endDate,
        };
        var uri =
        Uri.https(Constant.URL, '/api/getMyDeliveries.php',queryParameters);
        print(uri);
        final response = await http.get((uri),
          headers: <String, String>{HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
        );
        print("${response.body}");
        var response1 = DeliveryItemsResponse.fromJson(json.decode(response.body));
        if (response1.success == true) {
          if(mounted){
            setState(() {
              bookingsDetails.addAll(response1.data.bookings);
              loading = false;
              load = false;
            });
          }
          return response1;
        } else {
          Toast.show(response1.userFriendlyMessage ,context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          if(mounted){
            setState(() {
              load = false;
              loading = false;
            });
          }
        }
      }on Exception catch (e){
        Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.blueGrey[50],
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: FittedBox(fit:BoxFit.fitWidth,
          child:Container(
            child:  Text('Booking History', style: GoogleFonts.quicksand()),
          ),
        ),
        backgroundColor: Colors.cyan[600],
      ),
      body: loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[600]),),):bookingsDetails.isEmpty == true?
      Center(
        child:Text('No Bookings Assigned!',style: GoogleFonts.quicksand(
            textStyle: TextStyle(fontSize: 18),color: Colors.blueGrey),textAlign: TextAlign.center,),
      ): SafeArea(
        child: ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount:  bookingsDetails.isEmpty == true ? 0 : bookingsDetails.length+1,
            itemBuilder: (BuildContext context, int index) {
              if(index == bookingsDetails.length){
                return _buildProgressIndicator();
              }
              else{
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 3,),
                        ListTile(
                          tileColor: Colors.white,
                          // leading : Icon(Icons.delivery_dining,size: 50,color: Colors.blueGrey,),
                          trailing: Icon(Icons.navigate_next,color: Colors.blueGrey,),
                          title: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(3, 8, 0, 8),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Booking ID: "+bookingsDetails[index].serviceBookingId.toString(),style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey,fontWeight: FontWeight.bold),),),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 3, 0, 5),
                                      alignment: Alignment.topLeft,
                                      child:Text(toBeginningOfSentenceCase(
                                          bookingsDetails[index].shippingAddress.name.toUpperCase() +' , '+bookingsDetails[index].shippingAddress.mobileNumber
                                      ),
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                        textAlign: TextAlign.left,),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookingsDetails[index].shippingAddress.street.toUpperCase()+','),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookingsDetails[index].shippingAddress.landmark.toUpperCase() + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookingsDetails[index].shippingAddress.district.toUpperCase() + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookingsDetails[index].shippingAddress.city.toUpperCase() + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookingsDetails[index].shippingAddress.pincode + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookingsDetails[index].shippingAddress.country.toUpperCase()),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: bookingsDetails[index].shippingAddress.alternateMobileNumber.isEmpty == true?Text(''):Text(toBeginningOfSentenceCase(','+
                                                bookingsDetails[index].shippingAddress.alternateMobileNumber),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> BookedSlotDetails(bookingDetails: bookingsDetails[index],bookedAddress: bookingsDetails[index].shippingAddress,index:index)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: load ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
