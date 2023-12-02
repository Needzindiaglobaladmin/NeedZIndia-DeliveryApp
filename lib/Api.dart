import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:needz_india_delivery/Class/Login.dart';
import 'package:needz_india_delivery/Class/MarkDeliveryResponse.dart';
import 'package:needz_india_delivery/Screen/EditDetails.dart';
import 'package:needz_india_delivery/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<LoginResponse> loginuser(String username,String password,String accessLevel ) async {
  var url = Uri.parse(Constant.LOGIN_API);
  print(url);
  final response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },  body: {'username':username,'password':password,'accessLevel':accessLevel}
  );
  var convertedDatatoJson = LoginResponse.fromJson(jsonDecode(response.body)) ;
  return convertedDatatoJson;
}

Future<UserResponse> userdata(String firstName , String lastName, String gender, String emailId,String mobile) async {
  var _prefs =await SharedPreferences.getInstance();
  final String token = _prefs.getString('token');
  print(token);
  var url = Uri.parse(Constant.UPDATE_USERDATA_API);
  final response = await http.post(url,
      headers: <String, String>{HttpHeaders.authorizationHeader: token,
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },  body: {'firstName': firstName,'lastName':lastName,'gender':gender,emailId ==''?'':'emailId':emailId,'mobile': mobile}
  );

  var convertedDatatoJson = UserResponse.fromJson(jsonDecode(response.body)) ;
  return convertedDatatoJson;
}

Future<MarkDeliveryResponse> markDelivery(String mobile , String status, String deliveryAttemptId, String reasonForRejection,String rescheduledDate) async {
  var _prefs =await SharedPreferences.getInstance();
  final String token = _prefs.getString('token');
  print(token);
  var url = Uri.parse(Constant.MARK_DELIVERY_API);
  final response = await http.post(url,
      headers: <String, String>{HttpHeaders.authorizationHeader: token,
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },  body: {'mobile': mobile,'status':status,'deliveryAttemptId':deliveryAttemptId,'reasonForRejection':reasonForRejection,'rescheduledDate': rescheduledDate}
  );

  var convertedDatatoJson = MarkDeliveryResponse.fromJson(jsonDecode(response.body)) ;
  return convertedDatatoJson;
}

