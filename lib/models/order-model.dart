// ignore_for_file: file_names

class OrderModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List productImages;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  final String productQuantity;
  final String productTotalPrice;
  final String customerId;
  final bool status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceToken;
  final String totalProduct;
  final String sellerId;
  final String orderId;
  final bool deliveryBoy;
  final bool shop;
  final String lat;
  final String lot;
  final String shopAddress;

  OrderModel({
    required this.shopAddress,
    required this.lat,
    required this.lot,
    required this.shop,
    required this.deliveryBoy,
    required this.orderId,
    required this.sellerId,
    required this.totalProduct,
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.salePrice,
    required this.fullPrice,
    required this.productImages,
    required this.deliveryTime,
    required this.isSale,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.productQuantity,
    required this.productTotalPrice,
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerDeviceToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'shopAddress' : shopAddress,
      'lat' : lat,
      'lot' : lot,
      'shop' : shop,
      'deliveryBoy' : deliveryBoy,
      'orderId' : orderId,
      'sellerId' : sellerId,
      'totalProduct' : totalProduct,
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerDeviceToken': customerDeviceToken,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
      shopAddress: json['shopAddress'],
      lat: json['lat'],
      lot: json['lot'],
      shop: json['shop'],
      deliveryBoy: json['deliveryBoy'],
      orderId: json['orderId'],
      sellerId: json['sellerId'],
      totalProduct: json['totalProduct'],
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      salePrice: json['salePrice'],
      fullPrice: json['fullPrice'],
      productImages: json['productImages'],
      deliveryTime: json['deliveryTime'],
      isSale: json['isSale'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
      customerId: json['customerId'],
      status: json['status'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      customerDeviceToken: json['customerDeviceToken'],
    );
  }
}