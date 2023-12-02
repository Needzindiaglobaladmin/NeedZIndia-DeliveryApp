class BookedShippingAddress {
  final String id;
  final String type;
  final String name;
  final String mobileNumber;
  final String alternateMobileNumber;
  final String street;
  final String landmark;
  final String district;
  final String city;
  final String state;
  final String country;
  final String pincode;

  BookedShippingAddress({this.id,this.type,this.name,this.mobileNumber,this.alternateMobileNumber,this.state,this.street,
    this.city,this.country,this.district,this.landmark,this.pincode});

  factory BookedShippingAddress.fromJson(Map<String, dynamic> json) {
    return BookedShippingAddress(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      alternateMobileNumber: json['alternateMobileNumber'],
      state: json['state'],
      street: json['street'],
      city: json['city'],
      country: json['country'],
      district: json['district'],
      landmark: json['landmark'],
      pincode: json['pincode'],
    );
  }
}



class Bookings {
  final int serviceBookingId;
  final int userId;
  final int serviceId;
  final int deliveryAttemptId;
  final String serviceName;
  final String serviceDispatchingDate;
  final int pricePerPerson;
  final String paymentMode;
  bool isCancelled;
  bool isDelivered;
  final int timeSlotId;
  final String timeSlotName;
  final int startTimeInSecond;
  final int endTimeInSeconds;
  final int totalBookingAmount;
  final int numOfPersons;
  final BookedShippingAddress shippingAddress;

  Bookings({this.serviceBookingId,this.userId,this.serviceId,this.serviceName,this.serviceDispatchingDate, this.pricePerPerson,this.paymentMode,this.isDelivered,
    this.isCancelled,this.timeSlotId,this.timeSlotName,this.startTimeInSecond,this.endTimeInSeconds,this.shippingAddress,this.totalBookingAmount,this.numOfPersons,this.deliveryAttemptId});

  factory Bookings.fromJson(Map<String, dynamic> json) {
    return Bookings(
      serviceBookingId: json['serviceBookingId'],
      userId: json['userId'],
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
      serviceDispatchingDate: json['serviceDispatchingDate'],
      pricePerPerson: json['pricePerPerson'],
      paymentMode: json['paymentMode'],
      isCancelled: json['isCancelled'],
      isDelivered: json['isDelivered'],
      timeSlotId: json['timeSlotId'],
      timeSlotName: json['timeSlotName'],
      startTimeInSecond: json['startTimeInSecond'],
      endTimeInSeconds: json['endTimeInSeconds'],
      totalBookingAmount:json['totalBookingAmount'],
      numOfPersons: json["numOfPersons"],
      deliveryAttemptId: json["deliveryAttemptId"],
      shippingAddress: BookedShippingAddress.fromJson(json['shippingAddress']),
    );
  }
}


class OrderItems {
  final int basketId;
  final int productId;
  final int categoryId;
  final int stockId;
  final int variantId;
  final int unitId;
  final int quantityOrdered;
  final String productName;
  final String categoryName;
  final String variantName;
  final String unitName;
  final double priceAtTheTimeOfOrdering;
  final double discountedPriceAtTheTimeOfOrdering;
  final double totalPriceAtTheTimeOfOrdering;
  final double totalDiscountedPriceAtTheTimeOfOrdering;
  final double discountPercentageAtTheTimeOfOrdering;
  final String imageUrl;
  final String description;
  final String brand;
  final double quantity;
  final String unitSymbol;
  //final dynamic variants;

  OrderItems({this.basketId,this.productId, this.categoryId,this.stockId,
    this.variantId,this.unitId,this.quantityOrdered,this.productName,this.categoryName,this.variantName,
    this.unitName,this.priceAtTheTimeOfOrdering,this.discountedPriceAtTheTimeOfOrdering,this.totalPriceAtTheTimeOfOrdering,
    this.totalDiscountedPriceAtTheTimeOfOrdering,this.discountPercentageAtTheTimeOfOrdering,this.description,this.brand,this.imageUrl,
    this.quantity,this.unitSymbol});

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      basketId: json['basketId'],
      productId: json['productId'],
      categoryId: json['categoryId'],
      stockId: json['stockId'],
      variantId: json['variantId'],
      unitId: json['unitId'],
      quantityOrdered: json['quantityOrdered'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      variantName: json['variantName'],
      unitName: json['unitName'],
      priceAtTheTimeOfOrdering: json['priceAtTheTimeOfOrdering'].toDouble(),
      discountedPriceAtTheTimeOfOrdering: json['discountedPriceAtTheTimeOfOrdering'].toDouble(),
      totalPriceAtTheTimeOfOrdering: json['totalPriceAtTheTimeOfOrdering'].toDouble(),
      totalDiscountedPriceAtTheTimeOfOrdering: json['totalDiscountedPriceAtTheTimeOfOrdering'].toDouble(),
      discountPercentageAtTheTimeOfOrdering: json['discountPercentageAtTheTimeOfOrdering'].toDouble(),
      description: json['description'],
      brand: json['brand'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'].toDouble(),
      unitSymbol: json['unitSymbol'],
    );
  }
}



class ShippingAddress {
  final String id;
  final String type;
  final String name;
  final String mobileNumber;
  final String alternateMobileNumber;
  final String street;
  final String landmark;
  final String district;
  final String city;
  final String state;
  final String country;
  final String pincode;

  ShippingAddress({this.id,this.type,this.name,this.mobileNumber,this.alternateMobileNumber,this.state,this.street,
    this.city,this.country,this.district,this.landmark,this.pincode});

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      alternateMobileNumber: json['alternateMobileNumber'],
      state: json['state'],
      street: json['street'],
      city: json['city'],
      country: json['country'],
      district: json['district'],
      landmark: json['landmark'],
      pincode: json['pincode'],
    );
  }
}



class Orders{
  final int orderId;
  final String baitOrderId;
  final int deliveryAttemptId;
  final String lastDeliveryAttemptDate;
  final String couponApplied;
  final double discountOnCoupon;
  final double amountPaidByUser;
  final String expectedDeliveryDate;
  final bool isShipped;
  bool isDelivered;
  bool isCancelled;
  final String paymentMode;
  final bool isPaid;
  final double netOrderAmount;
  final double totalOrderAmount;
  final double totalPayableAmount;
  final double deliveryCharge;
  final ShippingAddress shippingAddress;
  final List<OrderItems> orderItems;

  Orders({this.orderId,this.couponApplied,this.discountOnCoupon,this.amountPaidByUser,this.expectedDeliveryDate,
    this.isShipped,this.isDelivered,this.isPaid,this.paymentMode,this.netOrderAmount,this.totalOrderAmount,this.totalPayableAmount,
    this.deliveryCharge,this.shippingAddress,this.orderItems,this.baitOrderId,this.deliveryAttemptId,this.lastDeliveryAttemptDate,this.isCancelled});

  factory Orders.fromJson(Map<String, dynamic> json) {
    var orderList = json['orderItems'] as List;
    return Orders(
      orderId: json['orderId'],
      baitOrderId: json['baitOrderId'],
      couponApplied: json['couponApplied'],
      isCancelled: json['isCancelled'],
      deliveryAttemptId: json['deliveryAttemptId'],
      lastDeliveryAttemptDate: json['lastDeliveryAttemptDate'],
      discountOnCoupon: json['discountOnCoupon'].toDouble(),
      amountPaidByUser: json['amountPaidByUser'].toDouble(),
      expectedDeliveryDate: json['expectedDeliveryDate'],
      isShipped:json['isShipped'],
      isDelivered: json['isDelivered'],
      isPaid:json['isPaid'],
      paymentMode: json['paymentMode'],
      netOrderAmount: json['netOrderAmount'].toDouble(),
      totalOrderAmount: json['totalOrderAmount'].toDouble(),
      totalPayableAmount: json['totalPayableAmount'].toDouble(),
      deliveryCharge: json['deliveryCharge'].toDouble(),
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
      orderItems: orderList.map((e) => OrderItems.fromJson(e)).toList(),
    );
  }
}


class DeliveryItemsData {
  final List<Orders> orders;
  final List<Bookings> bookings;

  DeliveryItemsData({this.orders,this.bookings,});

  factory DeliveryItemsData.fromJson(Map<String, dynamic> json) {
    var ordersArray = json['orders'] as List;
    var bookingsArray = json['bookings'] as List;
    return DeliveryItemsData(
      orders: ordersArray.map((e) => Orders.fromJson(e)).toList(),
      bookings: bookingsArray.map((e) => Bookings.fromJson(e)).toList(),
    );
  }
}
class DeliveryItemsResponse {
  final int status;
  final bool success;
  final String message;
  final String userFriendlyMessage;
  final DeliveryItemsData data;

  DeliveryItemsResponse({this.status,this.success, this.message,this.userFriendlyMessage,this.data});

  factory DeliveryItemsResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryItemsResponse(
      status: json['status'],
      success: json['success'],
      message: json['message'],
      userFriendlyMessage: json['userFriendlyMessage'],
      data: DeliveryItemsData.fromJson(json['data']),
    );
  }
}