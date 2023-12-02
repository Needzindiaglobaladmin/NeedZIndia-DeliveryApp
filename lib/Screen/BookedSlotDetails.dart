
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:needz_india_delivery/Api.dart';
import 'package:needz_india_delivery/Class/DeliveryItemsResponse.dart';
import 'package:needz_india_delivery/DeliveryDetailsListener.dart';
import 'package:needz_india_delivery/Screen/BookingsSlots.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';




class BookedSlotDetails extends StatefulWidget {
  final Bookings bookingDetails;
  final BookedShippingAddress bookedAddress;
  final int index;
  BookedSlotDetails({Key key, this.bookingDetails,this.bookedAddress,this.index}) : super(key: key );
  @override
  _BookedSlotDetails createState() => _BookedSlotDetails();
}

class _BookedSlotDetails extends State<BookedSlotDetails> {
  bool delivered  = false;
  bool reschedule = false;
  String selected = '';
  String date = '';
  bool loading = false;
  bool rejected = false;
  TextEditingController reasonController = TextEditingController();
  TextEditingController rescheduleController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    reasonController.dispose();
    rescheduleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingDetails = Provider.of<DeliveryDetailsListener>(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        titleSpacing: 0,
        title: FittedBox(fit: BoxFit.fitWidth,
          child: Text('Booking details', style: GoogleFonts.quicksand()),
        ),
        backgroundColor: Colors.cyan[600],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              SizedBox(height: 8,),
              Container(
                  color: Colors.white,
                  child:Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(20,10,0,10),
                          child: widget.bookingDetails.isCancelled? Icon(Icons.cancel,color: Colors.red,size: 30,):widget.bookingDetails.isDelivered?Icon(Icons.verified,color: Colors.green,size: 30,):Icon(Icons.delivery_dining,color: Colors.blueGrey,size: 30,),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 10),
                            alignment: Alignment.topLeft,
                            child:widget.bookingDetails.isCancelled?Text('Cancelled',style: GoogleFonts.quicksand(
                              textStyle: TextStyle(fontSize: 21,color: Colors.red,fontWeight: FontWeight.w700),),):widget.bookingDetails.isDelivered?Text('Completed',style: GoogleFonts.quicksand(
                              textStyle: TextStyle(fontSize: 21,color: Colors.green,fontWeight: FontWeight.w700),),):Text('Booking Dispatch Date',style: GoogleFonts.quicksand(
                              textStyle: TextStyle(fontSize: 21,color: Colors.blueGrey,fontWeight: FontWeight.w700),),)
                        ),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(50, 6, 0, 10),
                        alignment: Alignment.topLeft,
                        child:Text(DateFormat("EEE, d MMM yyyy").format(DateTime.parse(widget.bookingDetails.serviceDispatchingDate)),style: GoogleFonts.quicksand(
                          textStyle: TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.w700),),)
                    ),
                  ],)
              ),
              SizedBox(height: 5,),
              Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 0.5,
                              child: Container(color: Colors.blueGrey[200],),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                              alignment: Alignment.topLeft,
                              child: Text('Booking ID - '+ widget.bookingDetails.serviceBookingId.toString(),style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),),
                            ),
                            SizedBox(
                              height: 0.5,
                              child: Container(color: Colors.blueGrey[200],),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 0.5,
                              child: Container(color: Colors.blueGrey[200],),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                              alignment: Alignment.topLeft,
                              child: Text('Service Details',style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),),
                            ),
                            SizedBox(
                              height: 0.5,
                              child: Container(color: Colors.blueGrey[200],),
                            ),
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 15, 0, 5),
                                    alignment: Alignment.topLeft,
                                    child: Text(widget.bookingDetails.serviceName,style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 20,),fontWeight: FontWeight.w600),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                                    alignment: Alignment.topLeft,
                                    child: Text("Time Slot: "+ widget.bookingDetails.timeSlotName,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 18,color: Colors.blueGrey),),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                                    alignment: Alignment.topLeft,
                                    child: Text("Number of Persons: "+ widget.bookingDetails.numOfPersons.toString(),
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 18,color: Colors.blueGrey),),),
                                  ),
                                  SizedBox(height: 15,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  )
              ),
              SizedBox(height: 2,),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 15, 0, 5),
                      alignment: Alignment.topLeft,
                      child: Text('Booking Address',style: GoogleFonts.quicksand(
                          textStyle: TextStyle(fontSize: 22,),fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 8, 0, 8),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            alignment: Alignment.topLeft,
                            child:Text(toBeginningOfSentenceCase(
                                widget.bookingDetails.shippingAddress.name.toUpperCase() +' , '+widget.bookingDetails.shippingAddress.mobileNumber
                            ),
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              textAlign: TextAlign.left,),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.bookingDetails.shippingAddress.street.toUpperCase(),','),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.bookingDetails.shippingAddress.landmark.toUpperCase() + ","),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.bookingDetails.shippingAddress.district.toUpperCase() + ","),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.bookingDetails.shippingAddress.city.toUpperCase() + ","),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.bookingDetails.shippingAddress.pincode + ","),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.bookingDetails.shippingAddress.country.toUpperCase()),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: widget.bookingDetails.shippingAddress.alternateMobileNumber.isEmpty == true?Text(''):Text(toBeginningOfSentenceCase(','+
                                      widget.bookingDetails.shippingAddress.alternateMobileNumber),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                              ],
                            ),
                          ),
                        ],

                      ),
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 15, 0, 20),
                  alignment: Alignment.topLeft,
                  child: Text('Service Charge - ₹'+ widget.bookingDetails.totalBookingAmount.toString(),style: GoogleFonts.quicksand(
                      textStyle: TextStyle(fontSize: 18,color: Colors.black),fontWeight: FontWeight.bold),),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 15, 0, 20),
                      alignment: Alignment.topLeft,
                      child: Text('Payment mode - '+ widget.bookingDetails.paymentMode.toUpperCase(),style: GoogleFonts.quicksand(
                          textStyle: TextStyle(fontSize: 18,),fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              widget.bookingDetails.isDelivered || widget.bookingDetails.isCancelled ?Container(height: 40,):Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        color: Colors.white,
                        margin: EdgeInsets.fromLTRB(25, 5, 0, 5),
                        child: Text(
                          'Status',style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    delivered = true;
                                    reschedule=false;
                                    selected = "delivered";
                                    rejected = false;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: delivered ? Colors.cyan[100] : Colors.blueGrey[100],
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    child: Text("Delivered"),
                                  ),
                                ),
                              )
                          ),
                          Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    delivered = false;
                                    reschedule=false;
                                    selected = "rejected";
                                    rejected = true;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: rejected ? Colors.cyan[100] : Colors.blueGrey[100],
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    child: Text("Rejected"),
                                  ),
                                ),
                              )
                          ),
                          Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    delivered = false;
                                    reschedule=true;
                                    selected = "rescheduled";
                                    rejected = false;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: reschedule ? Colors.cyan[100] : Colors.blueGrey[100],
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    child: Text("Reschedule"),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 40,)
                    ],
                  )
              ),

              rejected ? Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10,2),
                      child: Text("Reason for Rejection",style: GoogleFonts.quicksand(
                          textStyle: TextStyle(),fontWeight: FontWeight.bold),),
                    ),
                    Form(
                      key: _formkey,
                      child: Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: TextFormField(
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            decoration: new InputDecoration(
                              hintText: "Write here.......",
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(0.0),
                                ),
                                borderSide: new BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            controller: reasonController,
                            validator: (value){
                              if(value.isEmpty){
                                return 'Enter a valid reason';
                              }
                              return null;
                            },
                          )
                      ),
                    ),
                    SizedBox(height:80,)
                  ],
                ),
              ):reschedule?Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10,2),
                      child: Text("Rescheduled Date",style: GoogleFonts.quicksand(
                          textStyle: TextStyle(),fontWeight: FontWeight.bold),),
                    ),
                    Form(
                      key: _formkey,
                      child: Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            decoration: new InputDecoration(
                              hintText: "yyyy-mm-dd",
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(0.0),
                                ),
                                borderSide: new BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            controller: rescheduleController,
                            keyboardType: TextInputType.datetime,
                            validator: (value){
                              if(value.isEmpty){
                                return 'Enter a valid reason';
                              }
                              return null;
                            },
                          )
                      ),
                    ),
                    SizedBox(height:80,)
                  ],
                ),
              ):Container(),
            ],
          ),
        ),
      ),
      bottomSheet:widget.bookingDetails.isDelivered || widget.bookingDetails.isCancelled?Container(height: 2,): Container(
        height: 30,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: RaisedButton(
          color: Colors.cyan[600],
          child: loading? Container(height:20,width:20,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),):Text('Submit',style: GoogleFonts.quicksand(
            textStyle: TextStyle(fontSize: 20,color: Colors.white),),),
          onPressed: () async {
            if(selected == "delivered"){
              var _prefs =await SharedPreferences.getInstance();
              var mobile = _prefs.getString('mobile');
              var status = selected;
              var deliveryAttemptId = widget.bookingDetails.deliveryAttemptId.toString();
              var reasonForRejection="";
              var rescheduledDate = "";
              print(mobile+status+deliveryAttemptId);
              try{
                if(mounted){
                  setState(() {
                    loading = true;
                  });
                }
                var response = await markDelivery(mobile, status, deliveryAttemptId, reasonForRejection, rescheduledDate);
                if(mounted){
                  setState(() {
                    loading = false;
                  });
                }
                if(response.success == true){
                  bookingDetails.bookingStatusChanged(widget.index);
                }
                else{
                  Toast.show(response.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                }
              } on Exception catch (e){
                Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
              }
            }
            else if(selected == "rejected"){
              if(_formkey.currentState.validate()){
                var _prefs =await SharedPreferences.getInstance();
                var mobile = _prefs.getString('mobile');
                var status = selected;
                var deliveryAttemptId = widget.bookingDetails.deliveryAttemptId.toString();
                var reasonForRejection = reasonController.text;
                var rescheduledDate = "";
                print(mobile+status+deliveryAttemptId);
                try{
                  if(mounted){
                    setState(() {
                      loading = true;
                    });
                  }
                  var response = await markDelivery(mobile, status, deliveryAttemptId, reasonForRejection, rescheduledDate);
                  if(mounted){
                    setState(() {
                      loading = false;
                    });
                  }
                  if(response.success == true){
                   bookingDetails.bookingRejectsStatusChanged(widget.index);
                    print("done");
                    if(mounted){
                      setState(() {
                        rejected = false;
                      });
                    }
                  }
                  else{
                    Toast.show(response.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                  }
                } on Exception catch (e){
                  Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                }
              }
            }
            else{
              if(_formkey.currentState.validate()){
                var _prefs =await SharedPreferences.getInstance();
                var mobile = _prefs.getString('mobile');
                var status = selected;
                var deliveryAttemptId = widget.bookingDetails.deliveryAttemptId.toString();
                var reasonForRejection = "";
                var rescheduledDate = rescheduleController.text;
                print(mobile+status+deliveryAttemptId);
                try{
                  if(mounted){
                    setState(() {
                      loading = true;
                    });
                  }
                  var response = await markDelivery(mobile, status, deliveryAttemptId, reasonForRejection, rescheduledDate);
                  if(mounted){
                    setState(() {
                      loading = false;
                    });
                  }
                  if(response.success == true){
                    print("done");
                    Toast.show(response.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                    if(mounted){
                      setState(() {
                        reschedule = false;
                      });
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => BookingSlots()));
                  }
                  else{
                    if(mounted){
                      setState(() {
                        loading = false;
                      });
                    }
                    Toast.show(response.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                  }
                } on Exception catch (e){
                  Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                  if(mounted){
                    setState(() {
                      loading = false;
                    });
                  }
                }
              }
            }
          },
        ),
      ),
    );
  }
}
