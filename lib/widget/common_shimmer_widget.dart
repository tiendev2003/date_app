import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmerWidget extends StatelessWidget {
  const CommonShimmerWidget(
      {super.key,
      required this.height,
      required this.width,
      this.radius,
      this.customGeometry});
  final double height;
  final double width;
  final double? radius;
  final BorderRadiusGeometry? customGeometry;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black45,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: customGeometry ?? BorderRadius.circular(radius ?? 12),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [],
        ),
      ),
    );
  }
}
