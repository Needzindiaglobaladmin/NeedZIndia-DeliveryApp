class MarkDeliveryResponse  {
  final int status;
  final bool success;
  final String message;
  final String userFriendlyMessage;
  final String data;

  MarkDeliveryResponse({this.status,this.success, this.message,this.userFriendlyMessage,this.data});

  factory MarkDeliveryResponse.fromJson(Map<String, dynamic> json) {
    return MarkDeliveryResponse(
      status: json['status'],
      success: json['success'],
      message: json['message'],
      userFriendlyMessage: json['userFriendlyMessage'],
      data: json['data'],
    );
  }
}