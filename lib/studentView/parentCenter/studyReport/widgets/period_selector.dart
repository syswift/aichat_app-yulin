import 'package:flutter/material.dart';
import '../../../../utils/responsive_size.dart';

class PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final String selectedPeriod;
  final Function(String) onPeriodSelected;

  const PeriodSelector({
    super.key,
    required this.periods,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.w(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: periods.map((period) {
          return GestureDetector(
            onTap: () => onPeriodSelected(period),
            child: Container(
              width: ResponsiveSize.w(200),
              height: ResponsiveSize.h(80),
              decoration: BoxDecoration(
                color: selectedPeriod == period
                    ? const Color(0xFF88c5fd)
                    : Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveSize.w(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: ResponsiveSize.w(8),
                    spreadRadius: ResponsiveSize.w(2),
                    offset: Offset(0, ResponsiveSize.h(4)),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  period,
                  style: TextStyle(
                    color: selectedPeriod == period
                        ? Colors.white
                        : Colors.black87,
                    fontSize: ResponsiveSize.sp(32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
} 