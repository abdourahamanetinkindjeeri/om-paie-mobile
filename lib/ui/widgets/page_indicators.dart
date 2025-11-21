import 'package:flutter/material.dart';
import 'package:om_paie_flutter/constants/app_colors.dart';

class PageIndicators extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final Function(int) onPageChanged;

  const PageIndicators({
    Key? key,
    required this.currentPage,
    this.pageCount = 3,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List<Widget>.generate(pageCount, (int index) {
        final bool isActive = currentPage == index;
        return GestureDetector(
          onTap: () => onPageChanged(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 16 : 12,
            height: isActive ? 16 : 12,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : AppColors.indicatorInactive,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}