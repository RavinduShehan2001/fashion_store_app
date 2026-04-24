import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Checkout Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                hintText: 'Full Name',
              ),
            ),
            SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                hintText: 'Phone Number',
              ),
            ),
            SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                hintText: 'Address',
              ),
            ),
            SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                hintText: 'City',
              ),
            ),
          ],
        ),
      ),
    );
  }
}