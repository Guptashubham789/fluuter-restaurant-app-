// ignore_for_file: file_names

class CartModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String comboPrice;
  final String fullPrice;
  final List productImages;
  final String deliveryTime;
  final bool isComboSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int productQuantity;
  final double productTotalPrice;

  CartModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.comboPrice,
    required this.fullPrice,
    required this.productImages,
    required this.deliveryTime,
    required this.isComboSale,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.productQuantity,
    required this.productTotalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'comboPrice': comboPrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'isComboSale': isComboSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      comboPrice: json['comboPrice'],
      fullPrice: json['fullPrice'],
      productImages: json['productImages'],
      deliveryTime: json['deliveryTime'],
      isComboSale: json['isComboSale'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
    );
  }
}