import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/products/screens/product_list_screen.dart';
import '../../features/products/screens/product_details_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String products = '/products';
  static const String productDetails = '/product-details';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      products: (context) => const ProductListScreen(),
      productDetails: (context) => const ProductDetailsScreen(),
    };
  }
}