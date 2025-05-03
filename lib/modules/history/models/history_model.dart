class HistoryModel {
  int? id;
  Product? product;
  Buyer? buyer;
  Buyer? seller;
  String? status;
  String? createdAt;

  HistoryModel(
      {this.id,
        this.product,
        this.buyer,
        this.seller,
        this.status,
        this.createdAt});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    buyer = json['buyer'] != null ? new Buyer.fromJson(json['buyer']) : null;
    seller = json['seller'] != null ? new Buyer.fromJson(json['seller']) : null;
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.buyer != null) {
      data['buyer'] = this.buyer!.toJson();
    }
    if (this.seller != null) {
      data['seller'] = this.seller!.toJson();
    }
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Product {
  int? id;
  String? title;
  String? description;
  String? price;
  int? sellerId;
  Category? category;
  String? status;
  String? uploadDate;
  List<Null>? images;

  Product(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.sellerId,
        this.category,
        this.status,
        this.uploadDate,
        this.images});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    sellerId = json['seller_id'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    status = json['status'];
    uploadDate = json['upload_date'];
    // if (json['images'] != null) {
    //   images = <Null>[];
    //   json['images'].forEach((v) {
    //     images!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['seller_id'] = this.sellerId;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['status'] = this.status;
    data['upload_date'] = this.uploadDate;
    // if (this.images != null) {
    //   data['images'] = this.images!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? slug;
  Null? image;

  Category({this.id, this.name, this.slug, this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    return data;
  }
}

class Buyer {
  String? email;
  String? username;
  Profile? profile;

  Buyer({this.email, this.username, this.profile});

  Buyer.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['username'] = this.username;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  int? user;
  String? username;
  String? name;
  String? address;
  String? course;
  int? collegeYear;
  String? gender;
  Null? image;
  int? averageRating;

  Profile(
      {this.user,
        this.username,
        this.name,
        this.address,
        this.course,
        this.collegeYear,
        this.gender,
        this.image,
        this.averageRating});

  Profile.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    username = json['username'];
    name = json['name'];
    address = json['address'];
    course = json['course'];
    collegeYear = json['college_year'];
    gender = json['gender'];
    image = json['image'];
    averageRating = json['average_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['username'] = this.username;
    data['name'] = this.name;
    data['address'] = this.address;
    data['course'] = this.course;
    data['college_year'] = this.collegeYear;
    data['gender'] = this.gender;
    data['image'] = this.image;
    data['average_rating'] = this.averageRating;
    return data;
  }
}