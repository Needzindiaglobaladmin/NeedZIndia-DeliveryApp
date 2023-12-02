import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:needz_india_delivery/DeliveryDetailsListener.dart';
import 'package:needz_india_delivery/Screen/DeliveryItemDetails.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';


class DeliveryItems extends StatefulWidget {
  @override
  _DeliveryItems createState() => _DeliveryItems();
}

class _DeliveryItems extends State<DeliveryItems> {
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
        print(response.data);
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
    final deliveryDetails = Provider.of<DeliveryDetailsListener>(context);
    return Scaffold(
      backgroundColor:  Colors.blueGrey[50],
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: FittedBox(fit:BoxFit.fitWidth,
          child:Container(
            child:  Text('Delivery Items', style: GoogleFonts.quicksand()),
          ),
        ),
        backgroundColor: Colors.cyan[600],
      ),
      body: load ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[600]),),):deliveryDetails.deliveryOrders.isEmpty == true?
      Center(
        child:Text('No Orders Assigned!',style: GoogleFonts.quicksand(
            textStyle: TextStyle(fontSize: 18),color: Colors.blueGrey),textAlign: TextAlign.center,),
      ):SafeArea(
        child: ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount:  deliveryDetails.deliveryOrders.isEmpty == true ? 0 : deliveryDetails.deliveryOrders.length+1,
            itemBuilder: (BuildContext context, int index) {
              if(index == deliveryDetails.deliveryOrders.length){
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
                          leading : deliveryDetails.deliveryOrders[index].isDelivered ?Icon(Icons.verified_outlined,size: 50,color: Colors.green,):deliveryDetails.deliveryOrders[index].isCancelled?Icon(Icons.cancel,size: 50,color: Colors.red,):Icon(Icons.pending_actions,size: 50,color: Colors.red,),
                          trailing:  Icon(Icons.navigate_next,color: Colors.blueGrey,),
                          title: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(3, 8, 0, 8),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Delivery Attempt ID: "+deliveryDetails.deliveryOrders[index].deliveryAttemptId.toString(),style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey,fontWeight: FontWeight.bold),),),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Order ID: "+deliveryDetails.deliveryOrders[index].orderId.toString(),style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(fontSize: 16,color: Colors.blueGrey,fontWeight: FontWeight.bold),),),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 3, 0, 5),
                                      alignment: Alignment.topLeft,
                                      child:Text(toBeginningOfSentenceCase(
                                          deliveryDetails.deliveryOrders[index].shippingAddress.name.toUpperCase() +' , '+deliveryDetails.deliveryOrders[index].shippingAddress.mobileNumber
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
                                                deliveryDetails.deliveryOrders[index].shippingAddress.street.toUpperCase()+','),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                deliveryDetails.deliveryOrders[index].shippingAddress.landmark.toUpperCase() + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                deliveryDetails.deliveryOrders[index].shippingAddress.district.toUpperCase() + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                deliveryDetails.deliveryOrders[index].shippingAddress.city.toUpperCase() + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                deliveryDetails.deliveryOrders[index].shippingAddress.pincode + ","),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: Text(toBeginningOfSentenceCase(
                                                deliveryDetails.deliveryOrders[index].shippingAddress.country.toUpperCase()),
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(fontSize: 14,color: Colors.blueGrey),),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(1, 5, 0, 0),
                                            child: deliveryDetails.deliveryOrders[index].shippingAddress.alternateMobileNumber.isEmpty == true?Text(''):Text(toBeginningOfSentenceCase(','+
                                                deliveryDetails.deliveryOrders[index].shippingAddress.alternateMobileNumber),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> DeliveryItemDetails(deliveryOrdersDetails: deliveryDetails.deliveryOrders[index],deliveryAddress: deliveryDetails.deliveryOrders[index].shippingAddress,index: index)),
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
