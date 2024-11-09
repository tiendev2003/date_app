import 'package:flutter/material.dart';

import '../core/theme/ui.dart';


class IndicatorWidget extends StatelessWidget {
  final bool isActive;
  const IndicatorWidget({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        // duration: const Duration(microseconds: 600),
        height: isActive ?  6 : 6,
        width: isActive  ? 15 : 6,
        decoration: BoxDecoration(
          color: isActive ? AppColors.appColor : AppColors.borderColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
