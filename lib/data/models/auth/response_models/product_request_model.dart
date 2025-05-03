class ProductRequestModel {
  ProductRequestModel({
    required this.id,
    required this.buyer,
    required this.seller,
    required this.buyerUsername,
    required this.sellerUsername,
    required this.product,
    required this.productName,
    required this.status,
     this.chatRoomId,
     this.groupName,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int buyer;
  late final int seller;
  late final String buyerUsername;
  late final String sellerUsername;
  late final int product;
  late final String productName;
  late final String status;
  late final Null chatRoomId;
  late final Null groupName;
  late final String createdAt;
  late final String updatedAt;
  
  ProductRequestModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    buyer = json['buyer'];
    seller = json['seller'];
    buyerUsername = json['buyer_username'];
    sellerUsername = json['seller_username'];
    product = json['product'];
    productName = json['product_name'];
    status = json['status'];
    chatRoomId = null;
    groupName = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['buyer'] = buyer;
    _data['seller'] = seller;
    _data['buyer_username'] = buyerUsername;
    _data['seller_username'] = sellerUsername;
    _data['product'] = product;
    _data['product_name'] = productName;
    _data['status'] = status;
    _data['chat_room_id'] = chatRoomId;
    _data['group_name'] = groupName;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}