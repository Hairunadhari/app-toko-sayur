import 'package:flutter/material.dart';

class MyBottomNavBar extends StatelessWidget {
  final Function(int) onTabChange;
  final int selectedIndex;

  const MyBottomNavBar({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildNavBarItem(IconData icon, String text, int index) {
      final bool isSelected = selectedIndex == index;
      return GestureDetector(
        onTap: () => onTabChange(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey[600],
              size: 26,
            ),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildNavBarItem(Icons.home, 'Home', 0),
          buildNavBarItem(Icons.shopping_bag, 'Booking', 1),
          buildNavBarItem(Icons.grid_view, 'Products  ', 2),
          buildNavBarItem(Icons.settings, 'Settings', 3),
          buildNavBarItem(Icons.person, 'Profile', 4),
        ],
      ),
    );
  }
}