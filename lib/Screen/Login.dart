import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:needz_india_delivery/Screen/Homescreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../Api.dart';
import '../constant.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final phonenumberController = TextEditingController();
  final passwordController = TextEditingController();
  String message='';
  String message1='';
  var deviceKey1;
  var token1;

  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }


  @override
  void dispose(){
    phonenumberController.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.cyan[600],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Form(key: _formkey,
          child: Center(
            child: Column(
              children: <Widget>[
                Flexible(
                  child:Container(
                    color: Colors.cyan[600],
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset('assets/images/logo.ico'),
                  ), ),
                SizedBox(height: 20,),
                Flexible(child:Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  child: Text(
                    'Log in to Get Started',style: GoogleFonts.quicksand(
                    textStyle: TextStyle(fontSize: 22),),),
                ),),
                SizedBox(height: 30,),
                Flexible(child: Container(
                  margin: EdgeInsets.fromLTRB(10,0,20,0),
                  child:TextFormField(
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixText: '+91 ',
                      prefixStyle: TextStyle(fontSize: 17,color: Colors.black),
                      icon: Icon(Icons.phone, color: Colors.black),
                      hintText: "Enter your Phone number",
                      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    keyboardType: TextInputType.phone,maxLength: 10,
                    controller: phonenumberController,
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter a Valid Number';
                      }
                      return null;
                    },
                  ),
                ),
                ),
                SizedBox(height: 15,),
                Flexible(child: Container(
                  margin: EdgeInsets.fromLTRB(10,0,20,0),
                  child:TextFormField(
                    obscureText: !_showPassword,
                    cursorColor: Colors.black,
                    obscuringCharacter: "*",
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.black),
                      hintText: "Enter your Password",
                      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _togglevisibility();
                        },
                        child: Icon(
                          _showPassword ? Icons.visibility : Icons
                              .visibility_off, color: Colors.blueGrey,),
                      ),
                    ),
                    controller: passwordController ,
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter correct password';
                      }
                      return null;
                    },
                  ),
                ),
                ),
                SizedBox(height: 25,),
                Flexible(child: Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  //height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    textColor: Colors.white,
                    color: Colors.cyan[600],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Login',style: GoogleFonts.quicksand(
                      textStyle: TextStyle(fontSize: 20),),),
                    onPressed: () async {
                      if(_formkey.currentState.validate()){
                        var username = phonenumberController.text;
                        var password = passwordController.text;
                        var accessLevel = "delivery_person";
                        try{
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(child: CircularProgressIndicator(),);
                              });
                          var rsp1= await loginuser(username ,password,accessLevel);
                          Navigator.pop(context);
                          if(rsp1.success==false){
                            Toast.show(rsp1.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                          }
                          else{
                            print(rsp1);
                            token1 = rsp1.data.token;
                            print(token1);
                            if(token1==Null){
                              setState(() {
                                message1= 'Login Failed';
                              });
                            }
                            else{
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('token', token1);
                              prefs.setString('mobile', username);
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                  HomeScreen()), (Route<dynamic> route) => false);
                            }
                          }
                        }
                        on Exception catch (e){
                          Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
                        }
                      }
                    },
                  ),
                ),),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  alignment: Alignment.center,
                  child: Text('Forgot password?',style: GoogleFonts.quicksand(
                    textStyle: TextStyle(fontSize: 20,color: Colors.blueGrey),),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}