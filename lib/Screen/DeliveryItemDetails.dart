import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:needz_india_delivery/Api.dart';
import 'package:needz_india_delivery/Class/DeliveryItemsResponse.dart';
import 'package:needz_india_delivery/DeliveryDetailsListener.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';


class DeliveryItemDetails extends StatefulWidget {
  final Orders deliveryOrdersDetails;
  final ShippingAddress deliveryAddress;
  final int index;
  DeliveryItemDetails({Key key, this.deliveryOrdersDetails,this.deliveryAddress,this.index}) : super(key: key );
  @override
  _DeliveryItemDetails createState() => _DeliveryItemDetails();
}

class _DeliveryItemDetails extends State<DeliveryItemDetails> {
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
    final f = new DateFormat('EEE, d MMM yyyy');
    int d = int.parse( widget.deliveryOrdersDetails.expectedDeliveryDate);
    print(d);
    print(f.format(new DateTime.fromMillisecondsSinceEpoch(d*1000)));
    date = f.format(new DateTime.fromMillisecondsSinceEpoch(d*1000)).toString();
  }

  @override
  void dispose(){
    reasonController.dispose();
    rescheduleController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final deliveryDetails = Provider.of<DeliveryDetailsListener>(context);
    return Scaffold(
      backgroundColor:  Colors.blueGrey[50],
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: FittedBox(fit:BoxFit.fitWidth,
          child:Container(
            child:  Text('Delivery Items Details', style: GoogleFonts.quicksand()),
          ),
        ),
        backgroundColor: Colors.cyan[600],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                          child:widget.deliveryOrdersDetails.isCancelled? Icon(Icons.cancel,color: Colors.red,size: 30,):widget.deliveryOrdersDetails.isDelivered?Icon(Icons.verified,color: Colors.green,size: 30,):Icon(Icons.delivery_dining,color: Colors.blueGrey,size: 30,),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 10),
                          alignment: Alignment.topLeft,
                          child:widget.deliveryOrdersDetails.isDelivered?Text('Delivered',style: GoogleFonts.quicksand(
                            textStyle: TextStyle(fontSize: 21,color: Colors.green,fontWeight: FontWeight.w700),),):widget.deliveryOrdersDetails.isCancelled ?Text('Cancelled',style: GoogleFonts.quicksand(
                            textStyle: TextStyle(fontSize: 21,color: Colors.red,fontWeight: FontWeight.w700),),):Text('Expected Delivery date',style: GoogleFonts.quicksand(
                            textStyle: TextStyle(fontSize: 21,color: Colors.blueGrey,fontWeight: FontWeight.w700),),),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(50, 6, 0, 10),
                      alignment: Alignment.topLeft,
                      child:widget.deliveryOrdersDetails.isDelivered?Text(date,style: GoogleFonts.quicksand(
                        textStyle: TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.w700),),):Text(date ,style: GoogleFonts.quicksand(
                        textStyle: TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.w700),),),
                    ),
                  ],)
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
                  child: Text('Order ID - '+ widget.deliveryOrdersDetails.orderId.toString(),style: GoogleFonts.quicksand(
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
                  child: Text('Ordered Products',style: GoogleFonts.quicksand(
                      textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),),
                ),
                SizedBox(
                  height: 0.5,
                  child: Container(color: Colors.blueGrey[200],),
                ),
              ],
            ),
          ),
              ListView.builder(
                  physics: new BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:  widget.deliveryOrdersDetails.orderItems.isEmpty == true ? 0 : widget.deliveryOrdersDetails.orderItems.length,
                  itemBuilder: (BuildContext context, int index) {
                      return SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                        height: 140,
                                        width: 100,
                                        child: Image.network(widget.deliveryOrdersDetails.orderItems[index].imageUrl),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(height:7,),
                                            Text(widget.deliveryOrdersDetails.orderItems[index].productName,style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 15,),fontWeight: FontWeight.w600),),
                                            SizedBox(height:7,),
                                            Text(widget.deliveryOrdersDetails.orderItems[index].variantName,style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 15,color: Colors.blueGrey)),),
                                            SizedBox(height:12,),
                                            Text('Qty - '+widget.deliveryOrdersDetails.orderItems[index].quantityOrdered.toString(),style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 15,color: Colors.blueGrey),fontWeight: FontWeight.w600),),
                                            SizedBox(height:10,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 3,),
                            ],
                          ),
                        ),
                      );
                  }),
              SizedBox(height: 2,),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 15, 0, 5),
                      alignment: Alignment.topLeft,
                      child: Text('Delivery Address',style: GoogleFonts.quicksand(
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
                                widget.deliveryAddress.name.toUpperCase() +' , '+widget.deliveryAddress.mobileNumber
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
                                      widget.deliveryAddress.street.toUpperCase()+','),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.deliveryAddress.landmark.toUpperCase() + ","),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.deliveryAddress.district.toUpperCase() + ","),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.deliveryAddress.city.toUpperCase() + ","),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.deliveryAddress.pincode + ","),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: Text(toBeginningOfSentenceCase(
                                      widget.deliveryAddress.country.toUpperCase()),
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey),),),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                  child: widget.deliveryAddress.alternateMobileNumber.isEmpty == true?Text(''):Text(toBeginningOfSentenceCase(','+
                                      widget.deliveryAddress.alternateMobileNumber),
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
              SizedBox(height: 5,),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 15, 0, 20),
                      alignment: Alignment.topLeft,
                      child: Text('Total Amount to be taken - '+ widget.deliveryOrdersDetails.totalPayableAmount.toStringAsFixed(2),style: GoogleFonts.quicksand(
                          textStyle: TextStyle(fontSize: 18,),fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 15, 0, 20),
                      alignment: Alignment.topLeft,
                      child: Text('Payment mode - '+ widget.deliveryOrdersDetails.paymentMode.toUpperCase(),style: GoogleFonts.quicksand(
                          textStyle: TextStyle(fontSize: 18,),fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              widget.deliveryOrdersDetails.isDelivered || widget.deliveryOrdersDetails.isCancelled ?Container(height: 40,):Container(
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
      bottomSheet:widget.deliveryOrdersDetails.isDelivered || widget.deliveryOrdersDetails.isCancelled?Container(height: 2,): Container(
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
             var deliveryAttemptId = widget.deliveryOrdersDetails.deliveryAttemptId.toString();
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
                 deliveryDetails.statusChanged(widget.index);
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
               var deliveryAttemptId = widget.deliveryOrdersDetails.deliveryAttemptId.toString();
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
                   deliveryDetails.rejectsStatusChanged(widget.index);
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
               var deliveryAttemptId = widget.deliveryOrdersDetails.deliveryAttemptId.toString();
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
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DeliveryItemDetails()));
                   if(mounted){
                     setState(() {
                       reschedule = false;
                     });
                   }
                 }
                 else{
                   Toast.show(response.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                   if(mounted){
                     setState(() {
                       reschedule = false;
                     });
                   }
                 }
               } on Exception catch (e){
                 Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                 if(mounted){
                   setState(() {
                     reschedule = false;
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
