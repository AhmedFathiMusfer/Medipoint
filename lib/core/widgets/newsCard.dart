import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsCard extends StatelessWidget {
  final New news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3BAA99), Color(0xFF1F6E6C)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
              child: Image.asset(news.image, fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            start: 20,
            top: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200.w,
                  child: Text(
                    news.title,
                    softWrap: true,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: 120.w,
                  child: Text(
                    news.description,
                    softWrap: true,
                    maxLines: 3,
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
