import 'package:deviflix/core/core.dart';
import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          buildRatingStars(rating),
          const SizedBox(width: 8),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: DFColors.starYellowColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Row buildRatingStars(double rating) {
  // 전체 별의 수
  int totalStars = 5;
  // 전체 별점을 2로 나눈 후 반올림하여 반개 단위로 계산
  int fullStars = rating ~/ 2;
  // 남은 점수가 0.5 이상이면 반개를 추가
  int halfStars = (rating % 2) >= 0.5 ? 1 : 0;
  // 빈 별의 수 계산
  int emptyStars = totalStars - fullStars - halfStars;

  return Row(
    children: [
      // 전체 별 그리기
      for (int i = 0; i < fullStars; i++)
        const Icon(Icons.star, color: DFColors.starYellowColor, size: 24),
      // 반개 별 그리기
      if (halfStars == 1)
        const Icon(Icons.star_half, color: DFColors.starYellowColor, size: 24),
      // 빈 별 그리기
      for (int i = 0; i < emptyStars; i++)
        const Icon(Icons.star_border,
            color: DFColors.starYellowColor, size: 24),
    ],
  );
}
