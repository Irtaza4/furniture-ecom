import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_ecom/main.dart';
import 'package:furniture_ecom/shared/services/cart_provider.dart';
import 'package:furniture_ecom/shared/services/favorites_provider.dart';
import 'package:furniture_ecom/shared/services/furniture_data_service.dart';

void main() {
  group('CartProvider Tests', () {
    test('Cart initializes with sample items and calculates subtotal correctly', () {
      final cart = CartProvider();
      expect(cart.items.isNotEmpty, true);
      expect(cart.itemCount > 0, true);
      expect(cart.subtotal > 0, true);
      expect(cart.grandTotal > 0, true);
    });

    test('Adding and removing items from CartProvider updates totals', () {
      final cart = CartProvider();
      final initialCount = cart.itemCount;
      final product = FurnitureDataService.products.last;

      cart.addItem(
        product: product,
        color: FurnitureDataService.colorPink,
        material: FurnitureDataService.materialLeather,
        quantity: 2,
      );

      expect(cart.itemCount, initialCount + 2);

      final addedItem = cart.items.firstWhere((i) => i.product.id == product.id);
      cart.removeItem(addedItem.id);

      expect(cart.itemCount, initialCount);
    });

    test('Promo codes apply discounts properly', () {
      final cart = CartProvider();
      final initialGrandTotal = cart.grandTotal;

      final success = cart.applyPromoCode('MODERN10');
      expect(success, true);
      expect(cart.discountAmount > 0, true);
      expect(cart.grandTotal < initialGrandTotal, true);
    });
  });

  group('FavoritesProvider Tests', () {
    test('Toggling favorites updates wishlist state correctly', () {
      final favs = FavoritesProvider();
      const testId = 'p_stool_table';

      final initialFav = favs.isFavorite(testId);
      favs.toggleFavorite(testId);
      expect(favs.isFavorite(testId), !initialFav);

      favs.toggleFavorite(testId);
      expect(favs.isFavorite(testId), initialFav);
    });
  });

  group('App Widget Smoke Tests', () {
    testWidgets('App renders WelcomeScreen on initial launch', (WidgetTester tester) async {
      await tester.pumpWidget(const FurnitureEcomApp());
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
    });
  });
}
