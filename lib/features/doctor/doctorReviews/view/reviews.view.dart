import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/cubit/doctorReviews.cubit.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/cubit/doctorReviews.state.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/view/widgets/review_card.dart';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.white,

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
            initial:
                () => const Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primaryColor,
                  ),
                ),
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
                  return ReviewCard(review: reviews[index]);
                },
              );
            },
          );
        },
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
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Review",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
            TextFormField(
              controller: controller,
              maxLines: 3,

              decoration: const InputDecoration(
                hintText: "Write your review...",
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Please enter your review'
                          : null,
            ),
            const SizedBox(height: 20),
            BlocBuilder<DoctorReviewsCubit, DoctorReviewsState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    if (!_formKey.currentState!.validate()) return;
                    context.read<DoctorReviewsCubit>().addReview(
                      rating: rating,
                      content: controller.text,
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
