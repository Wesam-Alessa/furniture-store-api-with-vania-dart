import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  int? id;
  String? title;
  String? thumbnail;
  String? description;
  int? categoryId;
  String? price;
  int? review;
  int? cartNumber;
  double? score;
  bool? isWishList;
  String? cretedAt;
  String? updatedAt;
  String? deletedAt;
  ProductModel({
    this.id,
    this.title,
    this.thumbnail,
    this.description,
    this.categoryId,
    this.price,
    this.review,
    this.cartNumber,
    this.score,
    this.isWishList,
    this.cretedAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'description': description,
      'categoryId': categoryId,
      'price': price,
      'review': review,
      'cartNumber': cartNumber,
      'score': score,
      'isWishList': isWishList,
      'cretedAt': cretedAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
      thumbnail: map['thumbnail'] != null ? map['thumbnail'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      categoryId: map['category_id'] != null ? map['category_id'] as int : null,
      price: map['price'] != null ? map['price'] as String : null,
      review: map['review'] != null ? map['review'] as int : null,
      cartNumber: map['cart_number'] != null ? map['cart_number'] as int : null,
      score: map['score'] != null ? map['score'] as double : null,
      isWishList: map['is_wishlist'] != null ? map['is_wishlist'] as bool : null,
      cretedAt: map['created_at'] != null ? map['created_at'] as String : null,
      updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
      deletedAt: map['deleted_at'] != null ? map['deleted_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
  }
