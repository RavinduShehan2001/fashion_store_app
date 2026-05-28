import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../models/cart_model.dart';
import '../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: StreamBuilder<List<CartModel>>(
        stream: CartService().streamCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load cart items',
                style: TextStyle(
                  color: isDark ? Colors.red.shade400 : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final cartItems = snapshot.data ?? [];

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 80,
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  ).animate().fade(duration: 500.ms).scale(),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ).animate().fade(duration: 500.ms, delay: 100.ms),
                ],
              ),
            );
          }

          // Calculate total price dynamically
          double total = 0;
          for (var item in cartItems) {
            total += item.price * item.quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    return Dismissible(
                      key: Key(item.productId),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await CartService().removeFromCart(item.productId);
                      },
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDark 
                                  ? Colors.black.withOpacity(0.3) 
                                  : Colors.grey.withOpacity(0.08),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: item.image.startsWith('http://') || item.image.startsWith('https://')
                                  ? Image.network(
                                      item.image,
                                      width: 85,
                                      height: 85,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 85,
                                          height: 85,
                                          color: Colors.grey.shade800,
                                          child: const Icon(Icons.image_not_supported),
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      item.image,
                                      width: 85,
                                      height: 85,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 85,
                                          height: 85,
                                          color: Colors.grey.shade800,
                                          child: const Icon(Icons.image_not_supported),
                                        );
                                      },
                                    ),
                            ),
                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await CartService().removeFromCart(item.productId);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Quantity Controls
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkInputFill : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await CartService().updateQuantity(item.productId, -1);
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            size: 16,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        GestureDetector(
                                          onTap: () async {
                                            await CartService().updateQuantity(item.productId, 1);
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: 16,
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade(duration: 500.ms, delay: (100 * index).ms).slideX(begin: 0.1),
                    );
                  },
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
                    ).animate().fade(duration: 500.ms, delay: 200.ms).slideY(begin: 0.2),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.checkout);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ).animate().fade(duration: 500.ms, delay: 300.ms).scale(begin: const Offset(0.95, 0.95)),
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