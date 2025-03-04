import 'package:flutter/material.dart';

import '../../constants/app_language.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTapped,
  });
  final int selectedIndex;
  final Function onTapped;
  final List<IconData> icons = [
    Icons.receipt_long,
    Icons.settings,
  ];
  final List<String> labels = [
    AppLanguage.billing,
    AppLanguage.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainer),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          return buildNavItem(index, context);
        }),
      ),
    );
  }

  Widget buildNavItem(int index, BuildContext context) {
    bool isSelected = selectedIndex == index;
    final deviceWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: isSelected ? const EdgeInsets.symmetric(horizontal: 5) : null,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            Icon(
              icons[index],
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white54,
              size: deviceWidth * 0.08,
            ),
            if (isSelected) const SizedBox(width: 5),
            if (isSelected)
              Text(
                labels[index],
                style: Theme.of(context).textTheme.labelLarge,
              )
          ],
        ),
      ),
    );
  }
}
