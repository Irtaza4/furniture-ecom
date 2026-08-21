import 'cart_item.dart';

enum OrderStatus {
  placed,
  inProduction,
  shipped,
  outForDelivery,
  delivered,
}

class Address {
  final String id;
  final String title;
  final String recipientName;
  final String street;
  final String city;
  final String postalCode;
  final String phone;
  final bool isDefault;

  const Address({
    required this.id,
    required this.title,
    required this.recipientName,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.phone,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $postalCode';
}

class DeliveryMethod {
  final String id;
  final String name;
  final String duration;
  final double price;
  final String description;

  const DeliveryMethod({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.description,
  });
}

class PaymentMethodOption {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final bool isCard;

  const PaymentMethodOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isCard = false,
  });
}

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final Address address;
  final DeliveryMethod deliveryMethod;
  final PaymentMethodOption paymentMethod;
  final DateTime orderDate;
  final String estimatedDelivery;
  final OrderStatus status;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.address,
    required this.deliveryMethod,
    required this.paymentMethod,
    required this.orderDate,
    required this.estimatedDelivery,
    this.status = OrderStatus.placed,
  });
}
