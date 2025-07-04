class ProductModel{
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List sizes;
  final List productImages;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;



  ProductModel({
    required this.productId,required this.categoryId,required this.productName,
    required this.categoryName,required this.salePrice,required this.fullPrice,required this.sizes,
    required this.productImages,required this.deliveryTime,required this.isSale,
    required this.productDescription,required this.createdAt,required this.updatedAt,
    });

  Map<String,dynamic> toMap(){
    return {
      "productId":productId,
      "categoryId":categoryId,
      "productName":productName,
      "categoryName":categoryName,
      "salePrice":salePrice,
      "fullPrice":fullPrice,
      "sizes":sizes,
      "productImages":productImages,
      "deliveryTime":deliveryTime,
      "isSale":isSale,
      "productDescription":productDescription,
      "createdAt":createdAt,
      "updatedAt":updatedAt,
    };
  }

  factory ProductModel.fromMap(Map<String,dynamic> json){
    return ProductModel(
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      salePrice: json['salePrice'],
      fullPrice: json['fullPrice'],
      sizes: json['sizes'],
      productImages: json['productImages'],
      deliveryTime: json['deliveryTime'],
      isSale: json['isSale'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],

    );
  }
}