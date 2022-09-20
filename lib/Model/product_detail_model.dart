import 'dart:convert';

import 'package:flutter/cupertino.dart';

class ProductDetailModel{
  final Image? image;
  ProductDetailModel({this.image});

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      image: json['Image']!=null&&json['Image']!=""?Image.memory(base64Decode(json['Image'])):Image.asset('assets/img/veg.png'),
    );
  }
}