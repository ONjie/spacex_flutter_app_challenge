import 'package:flutter/material.dart';


// Returns a color corresponding to a launch, capsule or rocket status.
Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
     case 'active' || 'completed':
        return Colors.green;
      case 'retired' || 'inactive':
        return Colors.red;
      case 'destroyed':
        return Colors.grey;
      case 'unknown' || 'upcoming':
        return Colors.orange;
      default:
        return Colors.blueGrey;
  }
}
