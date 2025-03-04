import 'package:flutter/material.dart';

import 'app_bars/settings_app_bar.dart';
import 'app_bars/billing_app_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final int selectedIndex;
  const CustomAppBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedIndex == 0) {
      return const BillingAppBar();
    }
    return const SizedBox.shrink();
  }
}
