import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:needz_india_delivery/Class/DeliveryItemsResponse.dart';
import 'package:needz_india_delivery/Class/UpdateDeliveryBoyData.dart';
import 'package:needz_india_delivery/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryDetailsListener extends ChangeNotifier {
  List<Orders> _deliveryOrders =[];
  List<Bookings> _bookingsDetails = [];
  List get deliveryOrders => _deliveryOrders;
  List get bookingsDetails => _bookingsDetails;



  Future<DeliveryItemsResponse> GetDeliveryItems(startDate,endDate,offset) async {
    var _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    var mobile = _prefs.getString('mobile');
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
        print(response1.data);
        print(response1.success);
        print(response1.message);
        print(response1.userFriendlyMessage);
        print(response1.status);
        print(response1.data);
        _deliveryOrders = response1.data.orders;
        _bookingsDetails = response1.data.bookings;
        return response1;
      } else {
        print(response1.userFriendlyMessage);
      }
  }


  Future<DeliveryItemsResponse> GetDeliveryItemsOffset(startDate,endDate,offset) async {
      var _prefs = await SharedPreferences.getInstance();
      var token = _prefs.getString('token');
      var mobile = _prefs.getString('mobile');

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
          print(response1.data);
          print(response1.success);
          print(response1.message);
          print(response1.userFriendlyMessage);
          print(response1.status);
          print(response1.data);
          _deliveryOrders.addAll(response1.data.orders);
          _bookingsDetails.addAll(response1.data.bookings);
          return response1;
        } else {
          print(response1.userFriendlyMessage);
        }
  }



  set deliveryOrders(List deliveryDetails){
    _deliveryOrders = deliveryDetails;
    notifyListeners();
  }
  set bookings(List bookings){
    _bookingsDetails = bookings;
    notifyListeners();
  }

  statusChanged(index){
    _deliveryOrders[index].isDelivered = true;
    notifyListeners();
  }

  rejectsStatusChanged(index){
    _deliveryOrders[index].isCancelled = true;
    notifyListeners();
  }

  bookingStatusChanged(index){
    _bookingsDetails[index].isDelivered = true;
    notifyListeners();
  }

  bookingRejectsStatusChanged(index){
    _bookingsDetails[index].isCancelled = true;
    notifyListeners();
  }

}