import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:needz_india_delivery/Api.dart';
import 'package:needz_india_delivery/Screen/MyAccount.dart';
import 'package:needz_india_delivery/constant.dart';
import 'package:needz_india_delivery/updateDetailsNotifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart';


class User {
  final String firstName;
  final String lastName;
  final String countryCode;
  final String mobile;
  final String emailId;
  final String gender;
  final String imageUrl;

  User({this.firstName,this.lastName,this.countryCode,this.mobile,this.emailId, this.gender,this.imageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: json['firstName'],
        lastName: json['lastName'],
        countryCode: json['countryCode'],
        mobile: json['mobile'],
        emailId: json['emailId'],
        gender: json['gender'],
        imageUrl: json['imageUrl']
    );
  }
}
class UserResponse  {
  final int status;
  final bool success;
  final String message;
  final String userFriendlyMessage;
  final User data;

  UserResponse({this.status,this.success, this.message,this.userFriendlyMessage,this.data});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'],
      success: json['success'],
      message: json['message'],
      userFriendlyMessage: json['userFriendlyMessage'],
      data: User.fromJson(json['data']),
    );
  }
}


class EditDetails extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String gender;
  final String emailId;
  final String imageUrl;
  EditDetails({Key key, this.firstName,this.lastName,this.gender,this.emailId,this.imageUrl}) : super(key: key);


  @override
  _EditDetails createState() => _EditDetails();
}

class _EditDetails extends State<EditDetails> {
  final _formkey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  final emailIdController = TextEditingController();
  final dobController = TextEditingController();
  String message='';
  File file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  String result = '';
  bool male = false;
  bool female = false;
  bool others = false;
  String genderSelected = '';
  String date="";
  final picker = ImagePicker();
  DateTime selectedDate = DateTime.now();

  @override
  void initState(){
    super.initState();
    print(widget.imageUrl);
    firstNameController.text=widget.firstName;
    lastNameController.text=widget.lastName;
    emailIdController.text=widget.emailId;
    if(widget.gender == "male"){
      setState(() {
        male=true;
      });
    }
    if(widget.gender == "female"){
      setState(() {
        female=true;
      });
    }
    if(widget.gender == "others"){
      setState(() {
        others=true;
      });
    }
  }


  Future<UserResponse> userprofiledata() async {
    var _prefs = await SharedPreferences.getInstance();
    final String token = _prefs.getString('token');
    print(token);
    print(tmpFile.path);
    var stream =
    new http.ByteStream(tmpFile.openRead());
    stream.cast();
    // get file length
    var length = await tmpFile.length(); //imageFile is your image file
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: token,
    }; // ignore thi
    String url = Constant.UPDATE_USERDATA_API;
    var uri = Uri.parse(Constant.apiShort_Url+ url);
    var request = new http.MultipartRequest("POST", uri);

    var multipartFileSign = new http.MultipartFile('image', stream, length,
        filename: basename(tmpFile.path)); //returns a Future<MultipartFile>
    var mobile = _prefs.getString('mobile');
    request.files.add(multipartFileSign);
    request.fields['mobile'] = mobile;
    request.headers.addAll(headers);
    var rsp = await request.send();
    var rsp2 = await rsp.stream.bytesToString();
    print("=-=-=-=-=-=-=-=-=-=");
    print(rsp2);
    print("=-=-=-=-=-=-=-=-=-=");
    print(jsonDecode(rsp2));
    return UserResponse.fromJson(jsonDecode(rsp2));
    // await request.send().then(f).catchError((e) {
    //   print(e);
    // throw e;
    //});
  }
  Future chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 30);
    if(pickedFile!=null){
      setState((){
        file = File(pickedFile.path);
        print(file);
        tmpFile = file;
      });
    }
  }

  Widget showImage() {
    return FutureBuilder<File>(
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          print(snapshot.data);
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return GestureDetector(
            onTap: chooseImage,
            child: CircleAvatar(
              radius: 55,
              backgroundImage:FileImage(
                snapshot.data,
              ),
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return CircleAvatar(
            radius: 55.0,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(widget.imageUrl + "?a="+ DateTime.now().millisecondsSinceEpoch.toString()),
          );
        }
      },
    );
  }

  @override
  void dispose(){
    firstNameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    emailIdController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UpdateDetailsNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0.0,
        title: FittedBox(fit:BoxFit.fitWidth,
          child: Text('Edit Details',style: GoogleFonts.quicksand(
            textStyle: TextStyle(fontSize: 22),),),
        ),
        backgroundColor: Colors.cyan[600],
      ),
      body: WillPopScope(
        onWillPop: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyAccount())),
        child: SafeArea(
          child: Form(key: _formkey,
            child: ListView(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    color: Colors.cyan[600],
                    child: Center(
                      child:Column(
                        children: <Widget>[
                          SizedBox(
                            height: 28,
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                file !=null ? showImage():
                                GestureDetector(
                                  onTap: (){
                                    chooseImage();
                                    print("clicked");
                                  },
                                  child: CircleAvatar(
                                    radius: 50.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage : NetworkImage(widget.imageUrl),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  alignment: Alignment.center,
                                  child: RaisedButton(
                                    textColor: Colors.cyan[600],
                                    color: Colors.white,
                                    child: Text('Upload profile image'),
                                    onPressed: ()  async {
                                      if(file == null){
                                        Toast.show('Select Image by clicking on camera icon', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                      }
                                      else{
                                        try{
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Center(child: CircularProgressIndicator(),);
                                              });
                                          var rsp2 =  await userprofiledata();
                                          print(rsp2.data);
                                          print(rsp2.success);
                                          print(rsp2.userFriendlyMessage);
                                          print(rsp2.message);
                                          if(rsp2.success==false){
                                            Toast.show(rsp2.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                          }
                                          else{
                                            Toast.show(rsp2.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                            print(rsp2);
                                            userDetails.imageChanged(rsp2.data.imageUrl);
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setString('imageUrl', rsp2.data.imageUrl);
                                            print(rsp2.data.imageUrl);
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyAccount()));
                                          }
                                        }
                                        on Exception catch (e){
                                          Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 15.0,
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      'First Name',style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child:TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      ),
                      textInputAction: TextInputAction.next,
                      controller: firstNameController,
                      validator: (value){
                        if(value.isEmpty){
                          return 'Fill firstname';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 25,),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 15.0,
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      'Last Name',style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      ),
                      controller: lastNameController,
                      validator: (value){
                        if(value.isEmpty){
                          return 'Fill lastname';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 25,),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 15.0,
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      'Gender',style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    male = true;
                                    female=false;
                                    others = false;
                                    genderSelected = "Male";
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
                                    color: male ? Colors.cyan[100] : Colors.blueGrey[100],
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    child: Text("Male"),
                                  ),
                                ),
                              )
                          ),
                          Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    male = false;
                                    female=true;
                                    others = false;
                                    genderSelected = "Female";
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
                                    color: female ? Colors.cyan[100] : Colors.blueGrey[100],
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    child: Text("Female"),
                                  ),
                                ),
                              )
                          ),
                          Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    male = false;
                                    female=false;
                                    others = true;
                                    genderSelected = "Others";
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
                                    color: others? Colors.cyan[100] : Colors.blueGrey[100],
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    child: Text("Others"),
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 15.0,
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      'Email ID',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      ),
                      controller: emailIdController,
                    ),
                  ),
                  SizedBox(height: 55,),
                ]
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        height: 40,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: RaisedButton(
          textColor: Colors.white,
          color: Colors.cyan[600],
          child: Text('Save'),
          onPressed: ()  async {
            if (_formkey.currentState.validate()) {
              var _prefs =await SharedPreferences.getInstance();
              var mobile = _prefs.getString('mobile');
              var firstName= firstNameController.text;
              var lastName= lastNameController.text;
              var gender = genderSelected;
              var emailId = emailIdController.text;
              print(gender);
              try{
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(child: CircularProgressIndicator(),);
                    });
                var rsp = await userdata(firstName,lastName,gender,emailId,mobile
                );
                print(rsp);
                Navigator.pop(context);
                if(rsp.success==false){
                  Toast.show(rsp.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                }
                else{
                  Toast.show(rsp.userFriendlyMessage, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                  print(rsp);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('firstName', rsp.data.firstName );
                  prefs.setString('lastName', rsp.data.lastName );
                  prefs.setString('gender', rsp.data.gender );
                  prefs.setString('emailId', rsp.data.emailId );
                  userDetails.nameChanged(rsp.data.firstName);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyAccount()));
                }
              }
              on Exception catch (e){
                Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                Navigator.pop(context);
              }
            }
          },
        ),
      ),
    );
  }
}
