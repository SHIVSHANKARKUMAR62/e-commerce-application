// ignore_for_file: file_names

class ProductModel {
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
  final String quantity;
  final String userUid;
  final bool isCart;

  ProductModel({
    required this.isCart,
    required this.quantity,
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
    required this.userUid
  });

  Map<String, dynamic> toMap() {
    return {
      'isCart' : isCart,
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
      'quantity': quantity,
      'userUid' : userUid
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      isCart: json['isCart'],
      quantity: json['quantity'],
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
      userUid: json['userUid']
    );
  }
}