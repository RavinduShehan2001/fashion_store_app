import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _userService = UserService();
  bool _isLoading = false;
  bool _isFetching = true;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _userService.getUserProfile();
      if (profile != null) {
        setState(() {
          _nameController.text = profile.name;
          _phoneController.text = profile.phone;
          _addressController.text = profile.address;
          _email = profile.email;
          _isFetching = false;
        });
      } else {
        // Fallback to currently logged in Firebase Auth User info if Firestore profile document isn't written yet
        final user = FirebaseAuth.instance.currentUser;
        setState(() {
          _nameController.text = user?.displayName ?? '';
          _email = user?.email ?? '';
          _isFetching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile details: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full Name field cannot be empty.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _userService.updateUserProfile(
        name: name,
        phone: phone,
        address: address,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      Navigator.pop(context); // Go back to profile screen
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required BuildContext context,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: enabled
            ? (isDark ? AppColors.darkInputFill : Colors.white)
            : (isDark ? AppColors.darkInputFill.withOpacity(0.4) : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: enabled ? Colors.transparent : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          width: 1,
        ),
        boxShadow: [
          if (!isDark && enabled)
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: TextStyle(
          color: enabled 
              ? (isDark ? Colors.white : Colors.black87)
              : (isDark ? Colors.grey.shade500 : Colors.grey.shade500),
          fontWeight: enabled ? FontWeight.normal : FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
          prefixIcon: Icon(
            icon,
            color: enabled 
                ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
          ),
          suffixIcon: enabled 
              ? null 
              : Icon(
                  Icons.lock_outline, 
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                  size: 20,
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: _isFetching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fade(duration: 500.ms).slideX(begin: -0.1),
                  const SizedBox(height: 24),

                  // Email is read only
                  const Text(
                    'Email (Read Only)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fade(duration: 500.ms, delay: 50.ms),
                  const SizedBox(height: 8),
                  _buildTextField(
                    context: context,
                    hint: 'Email Address',
                    icon: Icons.email_outlined,
                    controller: TextEditingController(text: _email),
                    enabled: false,
                  ).animate().fade(duration: 500.ms, delay: 100.ms).slideX(begin: 0.1),

                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fade(duration: 500.ms, delay: 150.ms),
                  const SizedBox(height: 8),
                  _buildTextField(
                    context: context,
                    hint: 'Enter your name',
                    icon: Icons.person_outline,
                    controller: _nameController,
                  ).animate().fade(duration: 500.ms, delay: 200.ms).slideX(begin: 0.1),

                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fade(duration: 500.ms, delay: 250.ms),
                  const SizedBox(height: 8),
                  _buildTextField(
                    context: context,
                    hint: 'Enter your phone number',
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ).animate().fade(duration: 500.ms, delay: 300.ms).slideX(begin: 0.1),

                  const Text(
                    'Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ).animate().fade(duration: 500.ms, delay: 350.ms),
                  const SizedBox(height: 8),
                  _buildTextField(
                    context: context,
                    hint: 'Enter your address',
                    icon: Icons.location_on_outlined,
                    controller: _addressController,
                  ).animate().fade(duration: 500.ms, delay: 400.ms).slideX(begin: 0.1),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      foregroundColor: Colors.black,
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
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ).animate().fade(duration: 500.ms, delay: 450.ms).scale(begin: const Offset(0.95, 0.95)),
                ],
              ),
            ),
    );
  }
}
