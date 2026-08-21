import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/models/order.dart';
import '../../../shared/services/furniture_data_service.dart';
import '../../../shared/services/cart_provider.dart';
import '../../../shared/widgets/icon_button_custom.dart';
import '../../../shared/widgets/app_button.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  late Address _selectedAddress;
  late DeliveryMethod _selectedDeliveryMethod;
  late PaymentMethodOption _selectedPaymentMethod;
  final TextEditingController _promoController = TextEditingController();
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _selectedAddress = FurnitureDataService.savedAddresses.first;
    _selectedDeliveryMethod = FurnitureDataService.deliveryMethods.first;
    _selectedPaymentMethod = FurnitureDataService.paymentMethods.first;
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() async {
    setState(() {
      _isPlacingOrder = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    final cart = Provider.of<CartProvider>(context, listen: false);
    final order = cart.placeOrder(
      address: _selectedAddress,
      deliveryMethod: _selectedDeliveryMethod,
      paymentMethod: _selectedPaymentMethod,
    );

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => OrderConfirmationScreen(order: order),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Address', 'Shipping', 'Payment', 'Review'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isCompleted = _currentStep > index;
          final isCurrent = _currentStep == index;

          return Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (index < _currentStep) {
                      setState(() {
                        _currentStep = index;
                      });
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.accentMintDark
                          : (isCurrent ? AppColors.primaryDark : AppColors.secondaryGray.withValues(alpha: 0.5)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isCurrent ? Colors.white : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted ? AppColors.accentMintDark : AppColors.borderSubtle,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddressStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Delivery Address',
          style: AppTypography.sectionTitle,
        ),
        const SizedBox(height: 14),
        ...FurnitureDataService.savedAddresses.map((addr) {
          final isSelected = addr.id == _selectedAddress.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedAddress = addr),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.accentPurple : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                    color: isSelected ? AppColors.accentPurple : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(addr.title, style: AppTypography.productName),
                            if (addr.isDefault) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentMint,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'DEFAULT',
                                  style: AppTypography.labelBold.copyWith(
                                    fontSize: 9,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(addr.recipientName, style: AppTypography.bodyMedium),
                        Text(addr.fullAddress, style: AppTypography.body),
                        Text(addr.phone, style: AppTypography.label),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDeliveryMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Shipping Speed',
          style: AppTypography.sectionTitle,
        ),
        const SizedBox(height: 14),
        ...FurnitureDataService.deliveryMethods.map((method) {
          final isSelected = method.id == _selectedDeliveryMethod.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedDeliveryMethod = method),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.accentPurple : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                    color: isSelected ? AppColors.accentPurple : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(method.name, style: AppTypography.productName),
                            Text(
                              method.price == 0 ? 'FREE' : '\$${method.price.toStringAsFixed(0)}',
                              style: AppTypography.price.copyWith(
                                color: method.price == 0 ? AppColors.accentMintDark : AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(method.duration, style: AppTypography.bodyMedium.copyWith(color: AppColors.accentPurple)),
                        const SizedBox(height: 2),
                        Text(method.description, style: AppTypography.body.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Option',
          style: AppTypography.sectionTitle,
        ),
        const SizedBox(height: 14),
        ...FurnitureDataService.paymentMethods.map((pay) {
          final isSelected = pay.id == _selectedPaymentMethod.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedPaymentMethod = pay),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.accentPurple : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                    color: isSelected ? AppColors.accentPurple : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      pay.isCard ? Icons.credit_card_rounded : (pay.icon == 'apple' ? Icons.apple_rounded : Icons.account_balance_wallet_outlined),
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pay.title, style: AppTypography.productName),
                        Text(pay.subtitle, style: AppTypography.label),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReviewStep() {
    final cart = Provider.of<CartProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Overview',
          style: AppTypography.sectionTitle,
        ),
        const SizedBox(height: 14),

        // Delivery info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping to:', style: AppTypography.label),
                  GestureDetector(
                    onTap: () => setState(() => _currentStep = 0),
                    child: Text('Edit', style: AppTypography.labelBold.copyWith(color: AppColors.accentPurple)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(_selectedAddress.recipientName, style: AppTypography.bodyMedium),
              Text(_selectedAddress.fullAddress, style: AppTypography.body),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment:', style: AppTypography.label),
                  GestureDetector(
                    onTap: () => setState(() => _currentStep = 2),
                    child: Text('Edit', style: AppTypography.labelBold.copyWith(color: AppColors.accentPurple)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(_selectedPaymentMethod.title, style: AppTypography.bodyMedium),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Promo Code input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.confirmation_number_outlined, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _promoController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'Enter Promo (e.g. MODERN10)',
                    border: InputBorder.none,
                    isDense: true,
                    fillColor: Colors.transparent,
                    filled: false,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_promoController.text.isNotEmpty) {
                    final success = cart.applyPromoCode(_promoController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'Promo code applied!' : 'Invalid promo code'),
                        backgroundColor: success ? AppColors.accentMintDark : AppColors.error,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  IconButtonCustom(
                    icon: Icons.arrow_back_ios_new_rounded,
                    iconSize: 18,
                    onPressed: () {
                      if (_currentStep > 0) {
                        setState(() => _currentStep--);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Checkout',
                    style: AppTypography.screenHeading.copyWith(fontSize: 22),
                  ),
                ],
              ),
            ),

            // Step Progress
            _buildStepIndicator(),

            // Step Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: IndexedStack(
                  index: _currentStep,
                  children: [
                    _buildAddressStep(),
                    _buildDeliveryMethodStep(),
                    _buildPaymentStep(),
                    _buildReviewStep(),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount', style: AppTypography.bodyMedium),
                      Text(
                        '\$${(cart.subtotal - cart.discountAmount + _selectedDeliveryMethod.price).toStringAsFixed(0)}',
                        style: AppTypography.screenHeading.copyWith(
                          fontSize: 22,
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: _currentStep == 3 ? 'Place Order' : 'Continue',
                    isLoading: _isPlacingOrder,
                    onPressed: () {
                      if (_currentStep < 3) {
                        setState(() => _currentStep++);
                      } else {
                        _handlePlaceOrder();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
