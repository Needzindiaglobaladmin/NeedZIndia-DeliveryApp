import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:needz_india_delivery/Class/UpdateDeliveryBoyData.dart';
import 'package:needz_india_delivery/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateDetailsNotifier extends ChangeNotifier {
  String _userName;
  String _imageUrl;
  bool _loading = true;
  String get userName => _userName;
  String get imageUrl => _imageUrl;
  bool get loading => _loading;



  Future<UpdateDeliveryBoyResponse> getJsonData() async {
    var _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    print(token);
    var mobile = _prefs.getString('mobile');
    var firstName = _prefs.getString('firstName');
    var imageUrl =  _prefs.getString('imageUrl');
    print(mobile);
    if(firstName == null){
      try{
        final response = await http.post(Uri.parse(Constant.GET_USERDATA_API),
            headers: <String, String>{HttpHeaders.authorizationHeader: token,
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            },  body: {'mobile': mobile}
        );
        print(response.body);
        var responseUser = UpdateDeliveryBoyResponse.fromJson(json.decode(response.body));
        if (responseUser.success == true) {
          print('response body : ${response.body}');
          _userName = responseUser.data.firstName;
          print(responseUser.data.imageUrl);
          if(responseUser.data.imageUrl == null){
            _imageUrl = 'https://www.needzindia.com/images/pp.png';
          }
          else{
            _imageUrl = responseUser.data.imageUrl;
            print(_imageUrl);
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('firstName', responseUser.data.firstName );
          prefs.setString('lastName', responseUser.data.lastName );
          prefs.setString('gender', responseUser.data.gender );
          prefs.setString('emailId', responseUser.data.emailId );
          prefs.setString('imageUrl', responseUser.data.imageUrl);
          return responseUser;

        } else {
          _loading = false;
          print(responseUser.userFriendlyMessage);
        }
      }on Exception catch (e){
        print("Something went wrong");
      }
    }
    else{
      print(token);
      _loading = false;
      _userName = firstName;
      if(imageUrl==null){
        _imageUrl ='https://www.needzindia.com/images/pp.png';
      }
      else{
        _imageUrl = imageUrl;
      }
    }
  }


  set userName(String userName){
    _userName = userName;
    notifyListeners();
  }
  set imageUrl(String imageUrl){
    _imageUrl = imageUrl;
    notifyListeners();
  }
  set loading(bool loading){
    _loading = loading;
    notifyListeners();
  }

  nameChanged(userName){
    _userName = userName;
    print(_userName);
    notifyListeners();
  }

  imageChanged(imageUrl){
    _imageUrl = imageUrl;
    notifyListeners();
  }
  loaded(loading){
    _loading = false;
    notifyListeners();
  }
}