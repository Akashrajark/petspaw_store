import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomViewButton extends StatelessWidget {
  const CustomViewButton({
    super.key,
    required this.ontap,
  });
  final Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Material(
        borderRadius: BorderRadiusDirectional.circular(20),
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            'View details',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
