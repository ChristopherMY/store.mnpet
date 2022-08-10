import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;

  StarRating({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => _buildStar(index, rating),
      ),
    );
  }

  _buildStar(int index, double rating) {
    IconData icon;
    Color color;
    if (index >= rating) {
      icon = Icons.star;
      color = Colors.grey;
    } else if (index > rating - 1 && index < rating) {
      icon = Icons.star_half;
      color = kPrimaryColorRed;
    } else {
      icon = Icons.star;
      color = kPrimaryColorRed;
    }
    return Icon(
      icon,
      color: color,
      size: size,
    );
  }
}
