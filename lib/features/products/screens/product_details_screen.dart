import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../models/product_model.dart';
import '../../cart/services/cart_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String _selectedSize = 'M';
  Color _selectedColor = Colors.black;
  bool _isFavorite = false;

  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final List<Color> _colors = [
    Colors.black,
    Colors.white,
    Colors.red.shade700,
    Colors.blue.shade700,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final product =
        ModalRoute.of(context)!.settings.arguments as ProductModel?;

    final String name = product?.name ?? 'Product Name';
    final String price = product?.price ?? '\$0';
    final String image = product?.image ?? '';
    final String description = product?.description ??
        'This fashion item is designed with modern style and comfort. '
        'It is suitable for casual wear, daily use, and stylish outings. '
        'Experience the future of fashion today with premium materials and sleek aesthetics.';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
            ),
          ).animate().fade().scale(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 120 + MediaQuery.of(context).padding.bottom), // Space for floating bar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Image Gallery
                Hero(
                  tag: image,
                  child: Container(
                    width: double.infinity,
                    height: 450,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      child: image.startsWith('http://') || image.startsWith('https://')
                          ? Image.network(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                                );
                              },
                            )
                          : Image.asset(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ).animate().fade(duration: 600.ms),

                Padding(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.displayLarge?.color,
                                height: 1.2,
                              ),
                            ).animate().fade(duration: 500.ms, delay: 200.ms).slideX(begin: -0.1),
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                            ),
                          ).animate().fade(duration: 500.ms, delay: 300.ms).slideX(begin: 0.1),
                        ],
                      ),
                      
                      const SizedBox(height: 24),

                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fade(duration: 500.ms, delay: 400.ms),

                      const SizedBox(height: 12),

                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                        ),
                      ).animate().fade(duration: 500.ms, delay: 500.ms),

                      const SizedBox(height: 32),

                      // Size Selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Select Size',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ).animate().fade(duration: 500.ms, delay: 600.ms),
                          Text(
                            'Size Guide',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                            ),
                          ).animate().fade(duration: 500.ms, delay: 600.ms),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: _sizes.map((size) {
                          bool isSelected = _selectedSize == size;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSize = size;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              width: 55,
                              height: 55,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                                    : (isDark ? AppColors.darkInputFill : Colors.white),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isSelected && !isDark
                                    ? [
                                        BoxShadow(
                                          color: AppColors.lightPrimary.withOpacity(0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    : [
                                        if (!isDark)
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          )
                                      ],
                              ),
                              child: Text(
                                size,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isSelected 
                                      ? Colors.black // Dark text on bright neon
                                      : Theme.of(context).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ).animate().fade(duration: 500.ms, delay: 700.ms).slideX(begin: 0.1),

                      const SizedBox(height: 32),

                      // Color Selection
                      const Text(
                        'Select Color',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fade(duration: 500.ms, delay: 800.ms),

                      const SizedBox(height: 16),

                      Row(
                        children: _colors.map((color) {
                          bool isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected 
                                      ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: color == Colors.white ? Colors.black : Colors.white,
                                      size: 20,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ).animate().fade(duration: 500.ms, delay: 900.ms).slideX(begin: 0.1),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24, 
                right: 24, 
                top: 20, 
                bottom: MediaQuery.of(context).padding.bottom + 20
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
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (product != null) {
                    try {
                      await CartService().addToCart(product);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                                const SizedBox(width: 12),
                                const Text('Added to Cart Successfully!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            backgroundColor: Colors.black87,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            action: SnackBarAction(
                              label: 'VIEW',
                              textColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.cart);
                              },
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add to cart: $e'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  foregroundColor: Colors.black, // Dark text on neon
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.shopping_bag_outlined, size: 24),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ).animate().fade(duration: 500.ms, delay: 1000.ms).slideY(begin: 0.2),
          ),
        ],
      ),
    );
  }
}