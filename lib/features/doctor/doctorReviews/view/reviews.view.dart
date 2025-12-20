import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/cubit/doctorReviews.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/cubit/doctorReviews.state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorReviewsView extends StatelessWidget {
  final String doctorId;

  const DoctorReviewsView({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviews"),
        actions: [
          BlocBuilder<DoctorReviewsCubit, DoctorReviewsState>(
            builder: (context, state) {
              return state.maybeWhen(
                success: (reviews) {
                  final myUserId = AuthManager().currentUser!.id;
                  final alreadyReviewed = reviews.any(
                    (r) => r.patientId == myUserId,
                  );

                  if (alreadyReviewed) return const SizedBox();

                  return IconButton(
                    icon: const Icon(Icons.rate_review_outlined),
                    onPressed: () {
                      _showAddReviewSheet(context);
                    },
                  );
                },
                orElse: () => const SizedBox(),
              );
            },
          ),
        ],
      ),

      body: BlocBuilder<DoctorReviewsCubit, DoctorReviewsState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox(),
            initial: () => const SizedBox(),
            loading:
                () => const Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primaryColor,
                  ),
                ),

            success: (reviews) {
              if (reviews.isEmpty) {
                return const Center(child: Text("No reviews yet"));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: reviews.length,
                separatorBuilder: (_, __) => 16.verticalSpace,
                itemBuilder: (_, index) {
                  return _ReviewCard(review: reviews[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
// class _ReviewComments extends StatelessWidget {
//   final int reviewId;

//   const _ReviewComments({required this.reviewId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//           ReviewCommentsCubit(context.read<AppDatabase>(), reviewId)
//             ..loadComments(),
//       child: BlocBuilder<ReviewCommentsCubit, ReviewCommentsState>(
//         builder: (context, state) {
//           return state.when(
//             initial: () => const SizedBox(),
//             loading: () => const SizedBox(),
//             error: (_) => const SizedBox(),
//             success: (comments) {
//               if (comments.isEmpty) {
//                 return const SizedBox();
//               }

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: comments.map((c) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8, left: 8),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(
//                           c.type.name == 'doctor'
//                               ? Icons.medical_services
//                               : Icons.person,
//                           size: 16,
//                           color: Colors.grey,
//                         ),
//                         6.horizontalSpace,
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 c.content,
//                                 style: TextStyle(fontSize: 13.sp),
//                               ),
//                               2.verticalSpace,
//                               Text(
//                                 c.createdAt.split('T').first,
//                                 style: TextStyle(
//                                   fontSize: 11.sp,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ⭐ Rating
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 18,
              ),
            ),
          ),

          8.verticalSpace,
          if (review.content != null)
            Text(review.content!, style: TextStyle(fontSize: 14.sp)),

          10.verticalSpace,
          Text(
            review.createdAt.split('T').first,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          12.verticalSpace,
          //  _ReviewComments(reviewId: review.id),
        ],
      ),
    );
  }
}

void _showAddReviewSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: context.read<DoctorReviewsCubit>(),
        child: const AddReviewSheet(),
      );
    },
  );
}

class AddReviewSheet extends StatefulWidget {
  const AddReviewSheet({super.key});

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  int rating = 5;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Review",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          /// ⭐ Rating
          Row(
            children: List.generate(
              5,
              (i) => IconButton(
                icon: Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() => rating = i + 1);
                },
              ),
            ),
          ),

          /// ✍️ Comment
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Write your review...",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          /// 🚀 Submit
          BlocBuilder<DoctorReviewsCubit, DoctorReviewsState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  context.read<DoctorReviewsCubit>().addReview(
                    rating: rating,
                    content: controller.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
