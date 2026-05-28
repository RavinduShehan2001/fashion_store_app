import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/app_routes.dart';
import '../../auth/services/auth_service.dart';
import '../services/user_service.dart';
import '../../../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = AuthService().currentUser;
    final fallbackName = user?.displayName ?? 'Ravindu Shehan';
    final fallbackEmail = user?.email ?? 'ravindu@example.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.editProfile);
            },
          ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: UserService().streamUserProfile(),
        builder: (context, snapshot) {
          final userModel = snapshot.data;
          
          final displayName = userModel?.name.isNotEmpty == true ? userModel!.name : fallbackName;
          final email = userModel?.email.isNotEmpty == true ? userModel!.email : fallbackEmail;
          final phone = userModel?.phone.isEmpty == true ? 'Not set' : (userModel?.phone ?? 'Not set');
          final address = userModel?.address.isEmpty == true ? 'Not set' : (userModel?.address ?? 'Not set');

          return Padding(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.8, 0.8)),
                const SizedBox(height: 16),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ).animate().fade(duration: 500.ms, delay: 100.ms),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: TextStyle(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ).animate().fade(duration: 500.ms, delay: 200.ms),
                const SizedBox(height: 30),

                _profileItem(context, Icons.phone_outlined, 'Phone', phone, isDark)
                    .animate().fade(duration: 500.ms, delay: 300.ms).slideX(begin: 0.1),
                _profileItem(context, Icons.location_on_outlined, 'Address', address, isDark)
                    .animate().fade(duration: 500.ms, delay: 400.ms).slideX(begin: 0.1),
                _profileItem(context, Icons.shopping_bag_outlined, 'Orders', 'View order history', isDark, onTap: () {
                  Navigator.pushNamed(context, AppRoutes.orderHistory);
                }).animate().fade(duration: 500.ms, delay: 500.ms).slideX(begin: 0.1),
                _profileItem(context, Icons.settings_outlined, 'Settings', 'Account preferences', isDark)
                    .animate().fade(duration: 500.ms, delay: 600.ms).slideX(begin: 0.1),

                const Spacer(),

                ElevatedButton(
                  onPressed: () async {
                    await AuthService().logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ).animate().fade(duration: 500.ms, delay: 700.ms).scale(begin: const Offset(0.95, 0.95)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _profileItem(BuildContext context, IconData icon, String title, String subtitle, bool isDark, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
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
          children: [
            Icon(icon, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}