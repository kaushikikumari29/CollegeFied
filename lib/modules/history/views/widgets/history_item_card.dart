import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/history/models/history_model.dart';
import 'package:collegefied/shared/usecases/usecases.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final HistoryModel history;

  const HistoryCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final product = history.product;
    final buyer = history.buyer;
    final seller = history.seller;
    final profile = buyer?.profile;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.s6),
        color: AppColors.bg,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyTextColor.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 3,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product?.title ?? 'No title',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(product?.description ?? 'No description'),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.person, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('Buyer: ${buyer?.username ?? 'N/A'}')),
              ],
            ),
            if (profile != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.school, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Course: ${profile.course ?? 'N/A'}')),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 18),
                  const SizedBox(width: 8),
                  Text('Rating: ${profile.averageRating ?? 'N/A'}'),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.sell, size: 18),
                const SizedBox(width: 8),
                Text('Price: ₹${product?.price ?? 'N/A'}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.category, size: 18),
                const SizedBox(width: 8),
                Text('Category: ${product?.category?.name ?? 'N/A'}'),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Status: ${capitalizeFirstLetter(history.status ?? 'Unknown')}',
                    style: AppTextStyles.f14w600
                        .copyWith(color: AppColors.primary)),
                Text(
                  DateFormat.yMMMd().format(
                    DateTime.tryParse(history.createdAt ?? '') ??
                        DateTime.now(),
                  ),
                  style: const TextStyle(color: Colors.grey),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
