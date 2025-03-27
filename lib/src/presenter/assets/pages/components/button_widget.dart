import 'package:flutter/material.dart';

import '../../../../core/ui/themes/colors.dart';

class ButtonWidget extends StatelessWidget {
  final bool filled;
  final VoidCallback? onPressed;
  final String text;
  final IconData iconData;
  final double? height;
  final double? width;

  const ButtonWidget({
    super.key,
    required this.filled,
    this.onPressed,
    required this.text,
    required this.iconData,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final iconAndTextColor = Color(filled ? 0xffffffff : 0xFF77818C);

    return IntrinsicWidth(
      stepWidth: width,
      stepHeight: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12),
          iconColor: iconAndTextColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: filled ? AppColors.brandBlueLight : Colors.white,
          side: BorderSide(
            width: 2,
            color: filled ? AppColors.brandBlueLight : Color(0xFFD8DFE6),
          ),
        ),
        child: Row(
          children: [
            Icon(iconData, color: filled ? Colors.white : null),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(color: iconAndTextColor)),
          ],
        ),
      ),
    );
  }
}
