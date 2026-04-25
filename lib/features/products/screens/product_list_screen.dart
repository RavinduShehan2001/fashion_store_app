import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final List<Map<String, String>> products = [
      {
        'name': 'Casual T-Shirt',
        'price': '\$25',
        'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
      },
      {
        'name': 'Stylish Jacket',
        'price': '\$60',
        'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',
      },
      {
        'name': 'Women Handbag',
        'price': '\$40',
        'image': 'https://images.unsplash.com/photo-1584917865442-de89df76afd3',
      },
      {
        'name': 'Sneakers',
        'price': '\$55',
        'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
      },
      {
        'name': 'Denim Shirt',
        'price': '\$35',
        'image': 'https://images.unsplash.com/photo-1603252109303-2751441dd157',
      },
      {
        'name': 'Classic Watch',
        'price': '\$80',
        'image': 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49',
      },
    ];

    final List<Map<String, dynamic>> categories = [
      {'name': 'All', 'icon': Icons.grid_view},
      {'name': 'Men', 'icon': Icons.man},
      {'name': 'Women', 'icon': Icons.woman},
      {'name': 'Shoes', 'icon': Icons.snowshoeing},
      {'name': 'Bags', 'icon': Icons.shopping_bag_outlined},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
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
                decoration: InputDecoration(
                  hintText: 'Search for clothes...',
                  hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkPrimary.withOpacity(0.1) : AppColors.lightPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.tune,
                      size: 20,
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    ),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ).animate().fade(duration: 500.ms).slideY(begin: -0.1),
            
            const SizedBox(height: 24),

            // Categories List
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: categories.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String categoryName = entry.value['name'];
                  IconData categoryIcon = entry.value['icon'];
                  bool isSelected = idx == _selectedCategoryIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = idx;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                            : (isDark ? AppColors.darkInputFill : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isSelected && !isDark
                            ? [
                                BoxShadow(
                                  color: AppColors.lightPrimary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            categoryIcon,
                            size: 18,
                            color: isSelected 
                                ? Colors.black 
                                : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            categoryName,
                            style: TextStyle(
                              color: isSelected 
                                  ? Colors.black 
                                  : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fade(duration: 500.ms, delay: 100.ms).slideX(begin: 0.1),

            const SizedBox(height: 24),
            
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.productDetails,
                        arguments: product,
                      );
                    },
                    child: Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    product['image']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade800,
                                        child: const Center(
                                          child: Icon(Icons.image_not_supported),
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.favorite_border,
                                        size: 16,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product['price']!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(duration: 600.ms, delay: (200 + (index * 50)).ms).slideY(begin: 0.1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}