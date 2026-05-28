import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../main.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../widgets/product_card.dart';
import '../../../models/product_model.dart';
import '../../products/services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ).animate().fade(duration: 500.ms).scale(),
        title: const Text(
          'N E X U S',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Good Morning ☀️',
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         color: Theme.of(context).textTheme.bodySmall?.color,
                  //       ),
                  //     ).animate().fade(duration: 500.ms).slideX(begin: -0.2),
                  //     const SizedBox(height: 4),
                  //     Text(
                  //       'Discover Fashion',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.w900,
                  //         color: Theme.of(context).textTheme.displayLarge?.color,
                  //       ),
                  //     ).animate().fade(duration: 600.ms, delay: 100.ms).slideX(begin: -0.2),
                  //   ],
                  // ),
                  // CircleAvatar(
                  //   radius: 24,
                  //   backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  //   child: const Icon(Icons.person, color: Colors.white),
                  // ).animate().fade(duration: 600.ms, delay: 200.ms).scale(),
                ],
              ),
              const SizedBox(height: 30),

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
              ).animate().fade(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2),

              const SizedBox(height: 30),

              // Promotional Banner
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/offer_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ).animate().fade(duration: 600.ms, delay: 200.ms).scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 30),
              
              // Categories Header
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fade(duration: 600.ms, delay: 400.ms),
              const SizedBox(height: 16),

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
                          borderRadius: BorderRadius.circular(30), // fully rounded pills
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
                                    ? Colors.black // Dark text on bright neon cyan for contrast
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
              ).animate().fade(duration: 600.ms, delay: 500.ms).slideX(begin: 0.2),
              
              const SizedBox(height: 35),
              
              // Featured Products Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Trending Now',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.products);
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ).animate().fade(duration: 600.ms, delay: 600.ms),
              
              const SizedBox(height: 20),
              
              // Featured Products Grid
              FutureBuilder<List<ProductModel>>(
                future: ProductService().getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'Failed to load products',
                          style: TextStyle(
                            color: isDark ? Colors.red.shade400 : Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text('No products available'),
                      ),
                    );
                  }

                  final featured = products.take(4).toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: featured.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final product = featured[index];

                      return ProductCard(product: product)
                          .animate()
                          .fade(duration: 600.ms, delay: (600 + (index * 100)).ms)
                          .slideY(begin: 0.2);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}