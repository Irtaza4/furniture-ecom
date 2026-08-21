import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final ProductColorOption selectedColor;
  final ProductMaterialOption selectedMaterial;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.selectedColor,
    required this.selectedMaterial,
    this.quantity = 1,
  });

  double get unitPrice => product.price + selectedMaterial.priceOffset;
  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    ProductColorOption? selectedColor,
    ProductMaterialOption? selectedMaterial,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedMaterial: selectedMaterial ?? this.selectedMaterial,
      quantity: quantity ?? this.quantity,
    );
  }
}
