import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../models/order_model.dart';
import '../../checkout/services/order_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Recent';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color badgeColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'completed':
        badgeColor = Colors.green.withOpacity(0.15);
        textColor = isDark ? Colors.greenAccent : Colors.green;
        break;
      case 'cancelled':
        badgeColor = Colors.red.withOpacity(0.15);
        textColor = isDark ? Colors.redAccent : Colors.red;
        break;
      default: // Pending
        badgeColor = Colors.orange.withOpacity(0.15);
        textColor = isDark ? Colors.orangeAccent : Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order, bool isDark) {
    final totalItems = order.items.fold<int>(0, (sum, item) => sum + item.quantity);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id.length >= 8 
                          ? 'Order #${order.id.substring(0, 8).toUpperCase()}'
                          : 'Order #${order.id.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(order.createdAt),
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context, order.status),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length > 3 ? 3 : order.items.length,
            itemBuilder: (context, idx) {
              final item = order.items[idx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.name} x${item.quantity}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (order.items.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(
                '+ ${order.items.length - 3} more items',
                style: TextStyle(
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$totalItems ${totalItems == 1 ? "Item" : "Items"}',
                style: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderService().streamOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkPrimary.withOpacity(0.1) : AppColors.lightPrimary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      ),
                    ).animate().scale(duration: 400.ms, curve: Curves.easeInOut),
                    const SizedBox(height: 24),
                    const Text(
                      'No Orders Yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You haven\'t placed any orders yet. Start exploring our stylish collection today!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to profile or home
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Start Shopping',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(context, order, isDark)
                  .animate()
                  .fade(duration: 500.ms, delay: (index * 100).ms)
                  .slideY(begin: 0.1);
            },
          );
        },
      ),
    );
  }
}
