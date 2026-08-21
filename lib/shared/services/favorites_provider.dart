import 'package:flutter/foundation.dart';
import '../models/product.dart';
import 'furniture_data_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteProductIds = {};

  FavoritesProvider() {
    _initSampleFavorites();
  }

  void _initSampleFavorites() {
    // Pre-populate with initial favorite items
    _favoriteProductIds.add('p_hero_chair');
    _favoriteProductIds.add('p_leather_swivel');
  }

  Set<String> get favoriteProductIds => Set.unmodifiable(_favoriteProductIds);

  List<Product> get favoriteProducts {
    return FurnitureDataService.products
        .where((product) => _favoriteProductIds.contains(product.id))
        .toList();
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteProductIds.clear();
    notifyListeners();
  }
}
