import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/theme/ui.dart';

class FillButton extends StatelessWidget {
  const FillButton(
      {super.key,
      this.onTap,
      this.bgColor,
      required this.title,
      this.iconpath});
  final void Function()? onTap;
  final Color? bgColor;
  final String title;
  final String? iconpath;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: Theme.of(context)
            .elevatedButtonTheme
            .style!
            .copyWith(backgroundColor: WidgetStatePropertyAll(bgColor)),
        onPressed: onTap ?? () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconpath?.isEmpty ?? true
                ? const SizedBox()
                : SvgPicture.asset(
                    iconpath!,
                    height: 25,
                  ),
            iconpath?.isEmpty ?? true
                ? const SizedBox()
                : const SizedBox(
                    width: 8,
                  ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: AppColors.white),
            ),
          ],
        ));
  }
}
