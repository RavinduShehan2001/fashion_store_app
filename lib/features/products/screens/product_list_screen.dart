import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/product_card.dart';
import '../../../data/dummy_products.dart';

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
                itemCount: dummyProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = dummyProducts[index];

                  return ProductCard(product: product)
                      .animate()
                      .fade(duration: 600.ms, delay: (200 + (index * 50)).ms)
                      .slideY(begin: 0.1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}