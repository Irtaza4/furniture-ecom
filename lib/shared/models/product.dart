import 'package:flutter/material.dart';

class ProductColorOption {
  final String id;
  final String name;
  final Color color;

  const ProductColorOption({
    required this.id,
    required this.name,
    required this.color,
  });
}

class ProductMaterialOption {
  final String id;
  final String name;
  final String subtitle;
  final String imageAsset;
  final double priceOffset;

  const ProductMaterialOption({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imageAsset,
    this.priceOffset = 0.0,
  });
}

class Product {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> images;
  final List<ProductColorOption> colors;
  final List<ProductMaterialOption> materials;
  final Color cardBackgroundColor;
  final bool isFeatured;
  final String dimensions;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.price,
    this.originalPrice = 0.0,
    this.rating = 4.8,
    this.reviewCount = 124,
    required this.description,
    required this.images,
    required this.colors,
    required this.materials,
    required this.cardBackgroundColor,
    this.isFeatured = false,
    this.dimensions = 'W: 68cm × D: 72cm × H: 84cm',
    this.inStock = true,
  });

  String get mainImage => images.isNotEmpty ? images.first : '';
}
