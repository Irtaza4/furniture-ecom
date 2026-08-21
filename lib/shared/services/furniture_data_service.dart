import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/order.dart';
import '../../core/theme/app_colors.dart';

class FurnitureDataService {
  // Color Swatches
  static const ProductColorOption colorPink = ProductColorOption(
    id: 'c_pink',
    name: 'Dusty Rose',
    color: AppColors.accentPink,
  );

  static const ProductColorOption colorCyan = ProductColorOption(
    id: 'c_cyan',
    name: 'Teal Cyan',
    color: AppColors.accentCyan,
  );

  static const ProductColorOption colorMustard = ProductColorOption(
    id: 'c_mustard',
    name: 'Warm Ochre',
    color: AppColors.accentMustard,
  );

  static const ProductColorOption colorCharcoal = ProductColorOption(
    id: 'c_charcoal',
    name: 'Charcoal Navy',
    color: AppColors.primaryDark,
  );

  static const ProductColorOption colorMint = ProductColorOption(
    id: 'c_mint',
    name: 'Soft Mint',
    color: AppColors.cardMint,
  );

  static const ProductColorOption colorGrey = ProductColorOption(
    id: 'c_grey',
    name: 'Heather Grey',
    color: Color(0xFF9E9EA7),
  );

  // Material Options
  static const ProductMaterialOption materialLeather = ProductMaterialOption(
    id: 'm_leather',
    name: 'Leather sheet',
    subtitle: 'Full-grain Italian leather',
    imageAsset: 'assets/images/leather_swatch.jpg',
    priceOffset: 0.0,
  );

  static const ProductMaterialOption materialBoucle = ProductMaterialOption(
    id: 'm_boucle',
    name: 'Bouclé fabric',
    subtitle: 'Tactile wool weave',
    imageAsset: 'assets/images/fabric_swatch.jpg',
    priceOffset: 25.0,
  );

  static const ProductMaterialOption materialOak = ProductMaterialOption(
    id: 'm_oak',
    name: 'Solid Oak Wood',
    subtitle: 'Sustainably sourced ash/oak',
    imageAsset: 'assets/images/wood_swatch.jpg',
    priceOffset: 45.0,
  );

  // Products catalog
  static final List<Product> products = [
    const Product(
      id: 'p_hero_chair',
      name: 'Accent Lounge Chair',
      subtitle: 'Dining Chair',
      category: 'Chairs',
      price: 230.0,
      originalPrice: 280.0,
      rating: 4.9,
      reviewCount: 218,
      description:
          'Sculptural curved armchair designed for deep ergonomic comfort. Crafted with premium heather woven fabric, high-resilience foam core, and tapered solid oak legs with protective floor glides.',
      images: [
        'assets/images/armchair_grey.jpg',
        'assets/images/leather_swivel_chair.jpg',
        'assets/images/nordic_stool.jpg',
      ],
      colors: [colorGrey, colorCharcoal, colorCyan, colorPink],
      materials: [materialBoucle, materialLeather, materialOak],
      cardBackgroundColor: AppColors.cardWarmGray,
      isFeatured: true,
      dimensions: 'W: 68cm × D: 72cm × H: 82cm',
    ),
    const Product(
      id: 'p_leather_swivel',
      name: 'Leather Swivel Chair',
      subtitle: 'Dining Chair',
      category: 'Chairs',
      price: 299.0,
      originalPrice: 349.0,
      rating: 5.0,
      reviewCount: 340,
      description:
          'Iconic butterfly-wing silhouette crafted with supple saddle leather and refined matte black steel legs. Engineered with 360-degree silent swivel mechanism for versatile dining and studio environments.',
      images: [
        'assets/images/leather_swivel_chair.jpg',
        'assets/images/armchair_grey.jpg',
        'assets/images/welcome_sofa.jpg',
      ],
      colors: [colorPink, colorCyan, colorMustard, colorCharcoal],
      materials: [materialLeather, materialBoucle, materialOak],
      cardBackgroundColor: AppColors.cardLavender,
      isFeatured: true,
      dimensions: 'W: 62cm × D: 58cm × H: 86cm',
    ),
    const Product(
      id: 'p_stool_table',
      name: 'Stool Table',
      subtitle: 'Side Table',
      category: 'Tables',
      price: 105.0,
      originalPrice: 130.0,
      rating: 4.8,
      reviewCount: 95,
      description:
          'Minimalist Japanese-Nordic tripod accent table. Solid natural white ash wood with beveled bullnose edges, smooth satin natural lacquer finish, and quick twist-assembly legs.',
      images: [
        'assets/images/stool_table.jpg',
        'assets/images/nordic_stool.jpg',
      ],
      colors: [colorMint, colorMustard, colorCharcoal],
      materials: [materialOak, materialLeather],
      cardBackgroundColor: AppColors.cardMint,
      dimensions: 'Ø: 45cm × H: 52cm',
    ),
    const Product(
      id: 'p_ceiling_lamp',
      name: 'Ceiling Lamp',
      subtitle: 'Lighting',
      category: 'Lighting',
      price: 85.0,
      originalPrice: 110.0,
      rating: 4.7,
      reviewCount: 82,
      description:
          'Architectural cone pendant fixture with natural terracotta ceramic exterior and spun copper warm reflective interior. Emits a soft, downward focused glow ideal for dining tables and reading nooks.',
      images: [
        'assets/images/ceiling_lamp.jpg',
      ],
      colors: [colorMustard, colorCharcoal, colorCyan],
      materials: [materialOak, materialLeather],
      cardBackgroundColor: AppColors.cardPeach,
      dimensions: 'Ø: 28cm × H: 34cm (Cord: 180cm)',
    ),
    const Product(
      id: 'p_nordic_stool',
      name: 'Nordic Stool',
      subtitle: 'Living & Bedroom',
      category: 'Chairs',
      price: 140.0,
      originalPrice: 165.0,
      rating: 4.9,
      reviewCount: 154,
      description:
          'Multi-functional companion stool and nightstand. Features a plush lavender upholstered seat top resting on turned solid beech wood legs.',
      images: [
        'assets/images/nordic_stool.jpg',
        'assets/images/stool_table.jpg',
      ],
      colors: [colorPink, colorCyan, colorGrey],
      materials: [materialBoucle, materialLeather, materialOak],
      cardBackgroundColor: AppColors.cardLavender,
      dimensions: 'Ø: 40cm × H: 48cm',
    ),
    const Product(
      id: 'p_cloud_sofa',
      name: 'Curved Cloud Sofa',
      subtitle: '3-Seater Sofa',
      category: 'Sofa',
      price: 890.0,
      originalPrice: 1050.0,
      rating: 5.0,
      reviewCount: 420,
      description:
          'Organic sculptural 3-seater sofa wrapped in textured ivory bouclé. Gently curved backrest creates an intimate lounging experience with feather-down filled lumbar support.',
      images: [
        'assets/images/velvet_sofa.jpg',
        'assets/images/welcome_sofa.jpg',
      ],
      colors: [colorGrey, colorCharcoal, colorPink],
      materials: [materialBoucle, materialLeather],
      cardBackgroundColor: AppColors.cardCream,
      dimensions: 'W: 220cm × D: 98cm × H: 76cm',
    ),
    const Product(
      id: 'p_platform_bed',
      name: 'Minimalist Oak Bed',
      subtitle: 'Platform Bed',
      category: 'Bed',
      price: 750.0,
      originalPrice: 890.0,
      rating: 4.8,
      reviewCount: 168,
      description:
          'Low-profile floating platform bed crafted from solid white oak timber. Rounded outer corners ensure shin protection while integrated slat ventilation prolongs mattress life.',
      images: [
        'assets/images/bed_frame.jpg',
      ],
      colors: [colorMustard, colorCharcoal, colorGrey],
      materials: [materialOak, materialLeather],
      cardBackgroundColor: AppColors.cardIce,
      dimensions: 'W: 168cm × L: 215cm × H: 24cm',
    ),
    const Product(
      id: 'p_ceramic_vases',
      name: 'Terracotta Art Vases',
      subtitle: 'Ceramic Decor Set',
      category: 'Decoration',
      price: 65.0,
      originalPrice: 80.0,
      rating: 4.9,
      reviewCount: 92,
      description:
          'Handmade organic ceramic vases with raw matte stoneware finish and sculptural fluid contouring. Set of two complimentary shapes for dry florals or standalone display.',
      images: [
        'assets/images/vase_set.jpg',
      ],
      colors: [colorMustard, colorPink, colorCharcoal],
      materials: [materialOak],
      cardBackgroundColor: AppColors.cardPeach,
      dimensions: 'Tall: H: 26cm, Wide: H: 18cm',
    ),
  ];

  // Categories
  static final List<Category> categories = [
    const Category(
      id: 'cat_all',
      name: 'All',
      icon: Icons.grid_view_rounded,
      image: 'assets/images/armchair_grey.jpg',
      itemCount: 24,
      backgroundColor: AppColors.primaryDark,
    ),
    const Category(
      id: 'cat_sofa',
      name: 'Sofa',
      icon: Icons.weekend_outlined,
      image: 'assets/images/velvet_sofa.jpg',
      itemCount: 8,
      backgroundColor: AppColors.cardCream,
    ),
    const Category(
      id: 'cat_chair',
      name: 'Chair',
      icon: Icons.chair_outlined,
      image: 'assets/images/leather_swivel_chair.jpg',
      itemCount: 12,
      backgroundColor: AppColors.cardLavender,
    ),
    const Category(
      id: 'cat_table',
      name: 'Table',
      icon: Icons.table_restaurant_outlined,
      image: 'assets/images/stool_table.jpg',
      itemCount: 6,
      backgroundColor: AppColors.cardMint,
    ),
    const Category(
      id: 'cat_lighting',
      name: 'Lighting',
      icon: Icons.lightbulb_outline_rounded,
      image: 'assets/images/ceiling_lamp.jpg',
      itemCount: 9,
      backgroundColor: AppColors.cardPeach,
    ),
    const Category(
      id: 'cat_bed',
      name: 'Bed',
      icon: Icons.bed_outlined,
      image: 'assets/images/bed_frame.jpg',
      itemCount: 5,
      backgroundColor: AppColors.cardIce,
    ),
    const Category(
      id: 'cat_decor',
      name: 'Decoration',
      icon: Icons.yard_outlined,
      image: 'assets/images/vase_set.jpg',
      itemCount: 14,
      backgroundColor: AppColors.cardWarmGray,
    ),
  ];

  // Default Addresses
  static const List<Address> savedAddresses = [
    Address(
      id: 'addr_1',
      title: 'Home',
      recipientName: 'Alex Morgan',
      street: '742 Evergreen Terrace, Apt 4B',
      city: 'San Francisco, CA',
      postalCode: '94107',
      phone: '+1 (555) 389-4021',
      isDefault: true,
    ),
    Address(
      id: 'addr_2',
      title: 'Design Studio',
      recipientName: 'Alex Morgan',
      street: '580 Howard Street, Suite 300',
      city: 'San Francisco, CA',
      postalCode: '94105',
      phone: '+1 (555) 772-9104',
      isDefault: false,
    ),
  ];

  // Delivery Methods
  static const List<DeliveryMethod> deliveryMethods = [
    DeliveryMethod(
      id: 'del_standard',
      name: 'Standard White Glove',
      duration: '3–5 Business Days',
      price: 15.0,
      description: 'Scheduled delivery with inside room placement and packaging removal.',
    ),
    DeliveryMethod(
      id: 'del_express',
      name: 'Priority Express Delivery',
      duration: '1–2 Business Days',
      price: 35.0,
      description: 'Guaranteed priority time slot with full assembly included.',
    ),
    DeliveryMethod(
      id: 'del_free',
      name: 'Economy Shipping',
      duration: '5–7 Business Days',
      price: 0.0,
      description: 'Curbside contactless ground drop-off.',
    ),
  ];

  // Payment Methods
  static const List<PaymentMethodOption> paymentMethods = [
    PaymentMethodOption(
      id: 'pay_card',
      title: 'Mastercard •••• 8492',
      subtitle: 'Expires 08/28',
      icon: 'credit_card',
      isCard: true,
    ),
    PaymentMethodOption(
      id: 'pay_apple',
      title: 'Apple Pay',
      subtitle: 'alex.morgan@icloud.com',
      icon: 'apple',
    ),
    PaymentMethodOption(
      id: 'pay_google',
      title: 'Google Pay',
      subtitle: 'alex.morgan@gmail.com',
      icon: 'google',
    ),
    PaymentMethodOption(
      id: 'pay_cod',
      title: 'Cash on Delivery',
      subtitle: 'Pay upon home arrival',
      icon: 'cash',
    ),
  ];
}
