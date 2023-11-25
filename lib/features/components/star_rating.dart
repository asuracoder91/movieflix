import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    int filledStars = (rating / 2).round();
    int grayStars = 5 - filledStars;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) {
          if (index < filledStars) {
            return const Icon(Icons.star, color: Colors.yellow, size: 24);
          } else {
            return const Icon(Icons.star, color: Colors.grey, size: 24);
          }
        },
      ),
    );
  }
}
