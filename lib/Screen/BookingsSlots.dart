import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:needz_india_delivery/Screen/BookedSlotDetails.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../DeliveryDetailsListener.dart';


class BookingSlots extends StatefulWidget {
  @override
  _BookingSlots createState() => _BookingSlots();
}

class _BookingSlots extends State<BookingSlots> {
  bool loading = false;
  bool load = true;
  int offset =0;
  final scrollController = ScrollController();
  var mobile;
  String formattedDate="";

  @override
  void initState() {
    super.initState();
    loadingDetails();
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        offset++;
        if(!loading){
          if(mounted){
            setState(() {
              loading = true;
            });
          }
        }
        loadingOffset(offset);
      }
    });
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  loadingDetails() async {
    try{
      final deliveryDetails = Provider.of<DeliveryDetailsListener>(context,listen: false);
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      print(formattedDate);
      var response = await deliveryDetails.GetDeliveryItems(formattedDate,formattedDate,offset);
      if(response.success == true){
        if(mounted){
          setState(() {
            load = false;
          });
        }
      }
      else{
        Toast.show(response.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        if(mounted){
          setState(() {
            load = false;
          });
        }
      }
    }on Exception catch (e){
      Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

  loadingOffset(offset) async {
    try{
      final deliveryDetails = Provider.of<DeliveryDetailsListener>(context,listen: false);
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);
      print(formattedDate);
      var response = await deliveryDetails.GetDeliveryItemsOffset(formattedDate,formattedDate,offset);
      if(response.success == true){
        if(mounted){
          setState(() {
            loading = false;
          });
        }
      }
      else{
        Toast.show(response.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
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



  @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<DeliveryDetailsListener>(context);
    return Scaffold(
      backgroundColor:  Colors.blueGrey[50],
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: FittedBox(fit:BoxFit.fitWidth,
          child:Container(
            child:  Text('Bookings', style: GoogleFonts.quicksand()),
          ),
        ),
        backgroundColor: Colors.cyan[600],
      ),
      body: load ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[600]),),):bookings.bookingsDetails.isEmpty == true?
      Center(
        child:Text('No Bookings Assigned!',style: GoogleFonts.quicksand(
            textStyle: TextStyle(fontSize: 18),color: Colors.blueGrey),textAlign: TextAlign.center,),
      ): SafeArea(
        child: ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount:  bookings.bookingsDetails.isEmpty == true ? 0 : bookings.bookingsDetails.length+1,
            itemBuilder: (BuildContext context, int index) {
              if(index == bookings.bookingsDetails.length){
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
                                      child: Text("Booking ID: "+bookings.bookingsDetails[index].serviceBookingId.toString(),style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey,fontWeight: FontWeight.bold),),),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 3, 0, 5),
                                      alignment: Alignment.topLeft,
                                      child:Text(toBeginningOfSentenceCase(
                                          bookings.bookingsDetails[index].shippingAddress.name.toUpperCase() +' , '+bookings.bookingsDetails[index].shippingAddress.mobileNumber
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
                                                bookings.bookingsDetails[index].shippingAddress.street.toUpperCase()+','),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookings.bookingsDetails[index].shippingAddress.landmark.toUpperCase() + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookings.bookingsDetails[index].shippingAddress.district.toUpperCase() + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookings.bookingsDetails[index].shippingAddress.city.toUpperCase() + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookings.bookingsDetails[index].shippingAddress.pincode + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                bookings.bookingsDetails[index].shippingAddress.country.toUpperCase()),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: bookings.bookingsDetails[index].shippingAddress.alternateMobileNumber.isEmpty == true?Text(''):Text(toBeginningOfSentenceCase(','+
                                                bookings.bookingsDetails[index].shippingAddress.alternateMobileNumber),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> BookedSlotDetails(bookingDetails: bookings.bookingsDetails[index],bookedAddress: bookings.bookingsDetails[index].shippingAddress,index:index)),
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
          opacity: loading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
