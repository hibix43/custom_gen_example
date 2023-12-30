import 'package:annotations/annotations.dart';

part 'product.g.dart';

@customAnnotation
class Product {
  final String name;
  final double price;

  const Product({required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
