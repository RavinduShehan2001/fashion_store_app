import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/cart_model.dart';
import '../../cart/services/cart_service.dart';
import '../services/order_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Credit Card';
  bool _isLoading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  Widget _buildTextField(BuildContext context, String hint, IconData icon, TextEditingController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkInputFill : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
          prefixIcon: Icon(
            icon,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, IconData icon, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        if (_isLoading) return;
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? AppColors.darkPrimary.withOpacity(0.1) : AppColors.lightPrimary.withOpacity(0.1))
              : (isDark ? AppColors.darkInputFill : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (!isDark && !isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.black
                    : (isDark ? Colors.white : Colors.black87),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected 
                      ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePlaceOrder(List<CartModel> cartItems) async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty. Add products to cart first.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final city = _cityController.text.trim();

    if (fullName.isEmpty || phone.isEmpty || address.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all delivery details fields.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final orderService = OrderService();
      await orderService.placeOrder(
        fullName: fullName,
        phone: phone,
        address: address,
        city: city,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkPrimary.withOpacity(0.2) : AppColors.lightPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              size: 48,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Order Placed!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your order has been successfully placed. You can track its progress in your Order History.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to cart or home screen
            },
            child: Text(
              'Continue Shopping',
              style: TextStyle(
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ).animate().fade().scale(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: StreamBuilder<List<CartModel>>(
        stream: CartService().streamCartItems(),
        builder: (context, snapshot) {
          final cartItems = snapshot.data ?? [];
          double total = 0.0;
          for (var item in cartItems) {
            total += item.price * item.quantity;
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shipping Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fade(duration: 500.ms).slideX(begin: -0.1),
                      const SizedBox(height: 20),
                      
                      _buildTextField(context, 'Full Name', Icons.person_outline, _fullNameController)
                          .animate().fade(duration: 500.ms, delay: 100.ms).slideX(begin: 0.1),
                      _buildTextField(context, 'Phone Number', Icons.phone_outlined, _phoneController)
                          .animate().fade(duration: 500.ms, delay: 200.ms).slideX(begin: 0.1),
                      _buildTextField(context, 'Address', Icons.location_on_outlined, _addressController)
                          .animate().fade(duration: 500.ms, delay: 300.ms).slideX(begin: 0.1),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(context, 'City', Icons.location_city_outlined, _cityController)
                                .animate().fade(duration: 500.ms, delay: 400.ms).slideX(begin: 0.1),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(context, 'Zip Code', Icons.map_outlined, _zipCodeController)
                                .animate().fade(duration: 500.ms, delay: 500.ms).slideX(begin: 0.1),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fade(duration: 500.ms, delay: 600.ms).slideX(begin: -0.1),
                      const SizedBox(height: 20),

                      _buildPaymentOption(context, 'Credit Card', Icons.credit_card, 'Credit Card')
                          .animate().fade(duration: 500.ms, delay: 700.ms).slideY(begin: 0.1),
                      _buildPaymentOption(context, 'PayPal', Icons.payment, 'PayPal')
                          .animate().fade(duration: 500.ms, delay: 800.ms).slideY(begin: 0.1),
                      _buildPaymentOption(context, 'Apple/Google Pay', Icons.account_balance_wallet, 'Mobile Pay')
                          .animate().fade(duration: 500.ms, delay: 900.ms).slideY(begin: 0.1),
                    ],
                  ),
                ),
              ),

              // Floating Summary Card
              Container(
                padding: EdgeInsets.only(
                  left: 24, 
                  right: 24, 
                  top: 24, 
                  bottom: MediaQuery.of(context).padding.bottom + 24
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                          ? Colors.black.withOpacity(0.5) 
                          : Colors.grey.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          ),
                        ),
                      ],
                    ).animate().fade(duration: 500.ms, delay: 1000.ms),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _handlePlaceOrder(cartItems),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        foregroundColor: Colors.black, // Dark text on bright neon
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              ),
                            )
                          : const Text(
                              'Place Order',
                              style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    ).animate().fade(duration: 500.ms, delay: 1100.ms).scale(begin: const Offset(0.95, 0.95)),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}