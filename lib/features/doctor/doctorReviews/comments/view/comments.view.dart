import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/comments.cubit.dart';
import '../cubit/comments.state.dart';

class ReviewComments extends StatelessWidget {
  final int reviewId;

  const ReviewComments({super.key, required this.reviewId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              CommentsCubit(db: AppDatabase(), reviewId: reviewId)..loadAll(),
      child: BlocBuilder<CommentsCubit, CommentsState>(
        builder: (context, state) {
          return state.maybeWhen(
            success: (comments) {
              if (comments.isEmpty) return const SizedBox();

              return Column(
                children:
                    comments.map((c) {
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            c.content,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                      );
                    }).toList(),
              );
            },
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }
}
