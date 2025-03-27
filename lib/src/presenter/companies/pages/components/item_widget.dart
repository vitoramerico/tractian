import 'package:flutter/material.dart';

import '../../../../core/ui/themes/colors.dart';
import '../../../../core/utils/constants/assets.dart';
import '../../../../data/models/company_model.dart';

class ItemWidget extends StatelessWidget {
  final CompanyModel company;
  final void Function(String companyId) onPressed;

  const ItemWidget({super.key, required this.company, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(5);

    return InkWell(
      onTap: () => onPressed(company.id),
      customBorder: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Container(
        key: Key(company.id),
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.brandBlueLight,
          borderRadius: borderRadius,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppAssets.company, width: 24, height: 24),
            const SizedBox(width: 16),
            Text(
              company.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
