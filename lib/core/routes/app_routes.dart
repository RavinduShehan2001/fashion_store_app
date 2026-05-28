import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/main/screens/main_screen.dart';
import '../../features/products/screens/product_list_screen.dart';
import '../../features/products/screens/product_details_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/order_history_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String products = '/products';
  static const String productDetails = '/product-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String orderHistory = '/order-history';
  static const String editProfile = '/edit-profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const MainScreen(),
      products: (context) => const ProductListScreen(),
      productDetails: (context) => const ProductDetailsScreen(),
      cart: (context) => const CartScreen(),
      checkout: (context) => const CheckoutScreen(),
      profile: (context) => const ProfileScreen(),
      orderHistory: (context) => const OrderHistoryScreen(),
      editProfile: (context) => const EditProfileScreen(),
    };
  }
}