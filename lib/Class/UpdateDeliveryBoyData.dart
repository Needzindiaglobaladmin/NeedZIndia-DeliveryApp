class UpdateDeliveryBoy {
  final String firstName;
  final String lastName;
  final String countryCode;
  final String mobile;
  final String emailId;
  final String gender;
  final String imageUrl;

  UpdateDeliveryBoy({this.firstName,this.lastName,this.countryCode,this.mobile,this.emailId, this.gender,this.imageUrl});

  factory UpdateDeliveryBoy.fromJson(Map<String, dynamic> json) {
    return UpdateDeliveryBoy(
      firstName: json['firstName'],
      lastName: json['lastName'],
      countryCode: json['countryCode'],
      mobile: json['mobile'],
      emailId: json['emailId'],
      gender: json['gender'],
      imageUrl: json['imageUrl'],
    );
  }
}
class UpdateDeliveryBoyResponse  {
  final int status;
  final bool success;
  final String message;
  final String userFriendlyMessage;
  final UpdateDeliveryBoy data;

  UpdateDeliveryBoyResponse({this.status,this.success, this.message,this.userFriendlyMessage,this.data});

  factory UpdateDeliveryBoyResponse.fromJson(Map<String, dynamic> json) {
    return UpdateDeliveryBoyResponse(
      status: json['status'],
      success: json['success'],
      message: json['message'],
      userFriendlyMessage: json['userFriendlyMessage'],
      data: UpdateDeliveryBoy.fromJson(json['data']),
    );
  }
}