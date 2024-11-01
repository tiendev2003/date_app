import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackButtons extends StatelessWidget {
  const BackButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: SvgPicture.asset(
          "assets/icons/BackIcon.svg",
          height: 25,
          width: 25,
          colorFilter: ColorFilter.mode(
              Theme.of(context).indicatorColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
