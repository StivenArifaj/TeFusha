import 'package:flutter/material.dart';

class SportIcons {
  SportIcons._();

  static IconData getIcon(String lloji) {
    switch (lloji.toLowerCase()) {
      case 'futboll':      return Icons.sports_soccer;
      case 'basketboll':   return Icons.sports_basketball;
      case 'tenis':        return Icons.sports_tennis;
      case 'volejboll':    return Icons.sports_volleyball;
      default:             return Icons.sports;
    }
  }

  static Color getColor(String lloji) {
    switch (lloji.toLowerCase()) {
      case 'futboll':      return const Color(0xFF2E7D32);  // green
      case 'basketboll':   return const Color(0xFFE65100);  // deep orange
      case 'tenis':        return const Color(0xFFF9A825);  // yellow
      case 'volejboll':    return const Color(0xFF1565C0);  // blue
      default:             return const Color(0xFF616161);  // gray
    }
  }
}
