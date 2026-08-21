import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/order.dart';
import 'furniture_data_service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Order> _orders = [];

  String? _appliedPromoCode;
  double _discountPercentage = 0.0;

  CartProvider() {
    _initSampleCart();
  }

  void _initSampleCart() {
    // Pre-populate with sample items matching the Dribbble prototype
    final leatherChair = FurnitureDataService.products.firstWhere(
      (p) => p.id == 'p_leather_swivel',
    );
    final stoolTable = FurnitureDataService.products.firstWhere(
      (p) => p.id == 'p_stool_table',
    );
    final ceilingLamp = FurnitureDataService.products.firstWhere(
      (p) => p.id == 'p_ceiling_lamp',
    );

    _items.addAll([
      CartItem(
        id: 'cart_1',
        product: leatherChair,
        selectedColor: FurnitureDataService.colorPink,
        selectedMaterial: FurnitureDataService.materialLeather,
        quantity: 1,
      ),
      CartItem(
        id: 'cart_2',
        product: stoolTable,
        selectedColor: FurnitureDataService.colorMint,
        selectedMaterial: FurnitureDataService.materialOak,
        quantity: 1,
      ),
      CartItem(
        id: 'cart_3',
        product: ceilingLamp,
        selectedColor: FurnitureDataService.colorMustard,
        selectedMaterial: FurnitureDataService.materialOak,
        quantity: 2,
      ),
    ]);
  }

  List<CartItem> get items => List.unmodifiable(_items);
  List<Order> get orders => List.unmodifiable(_orders);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => subtotal > 500 ? 0.0 : (subtotal > 0 ? 15.0 : 0.0);

  double get discountAmount => subtotal * _discountPercentage;

  double get grandTotal => (subtotal - discountAmount + deliveryFee).clamp(0.0, double.infinity);

  String? get appliedPromoCode => _appliedPromoCode;

  void addItem({
    required Product product,
    required ProductColorOption color,
    required ProductMaterialOption material,
    int quantity = 1,
  }) {
    // Check if matching item exists
    final index = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedColor.id == color.id &&
          item.selectedMaterial.id == material.id,
    );

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
          product: product,
          selectedColor: color,
          selectedMaterial: material,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int delta) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index >= 0) {
      final newQuantity = _items[index].quantity + delta;
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'MODERN10' || cleanCode == 'COMFORT10') {
      _appliedPromoCode = cleanCode;
      _discountPercentage = 0.10;
      notifyListeners();
      return true;
    } else if (cleanCode == 'VIP20') {
      _appliedPromoCode = cleanCode;
      _discountPercentage = 0.20;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
    notifyListeners();
  }

  Order placeOrder({
    required Address address,
    required DeliveryMethod deliveryMethod,
    required PaymentMethodOption paymentMethod,
  }) {
    final currentSubtotal = subtotal;
    final currentDiscount = discountAmount;
    final currentDelivery = deliveryMethod.price;
    final finalTotal = currentSubtotal - currentDiscount + currentDelivery;

    final order = Order(
      id: 'FUR-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}',
      items: List.from(_items),
      subtotal: currentSubtotal,
      deliveryFee: currentDelivery,
      discount: currentDiscount,
      total: finalTotal,
      address: address,
      deliveryMethod: deliveryMethod,
      paymentMethod: paymentMethod,
      orderDate: DateTime.now(),
      estimatedDelivery: '3–5 Business Days',
      status: OrderStatus.placed,
    );

    _orders.insert(0, order);
    clearCart();
    return order;
  }
}
