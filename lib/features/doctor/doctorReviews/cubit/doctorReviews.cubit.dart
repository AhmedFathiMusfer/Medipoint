import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/doctor/doctorReviews/cubit/doctorReviews.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorReviewsCubit extends Cubit<DoctorReviewsState> {
  AppDatabase db = AppDatabase();
  final String doctorId;

  DoctorReviewsCubit(this.doctorId) : super(const DoctorReviewsState.initial());
  Future<void> loadAll() async {
    try {
      if (!isClosed) {
        emit(DoctorReviewsState.loading());
      }
      await loadLocalData();
      await loadOnLineData();
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected) +
            e.toString(),
      );
    }
  }

  loadLocalData() async {
    final reviews = await getReviews();
    if (!isClosed) {
      emit(DoctorReviewsState.success(reviews: reviews));
    }
  }

  loadOnLineData() async {
    var isConnection = await NetworkHelper.isConnected();
    if (!isConnection) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
      return;
    }
    await fetchReviewByDoctorId("5");
    await loadLocalData();
  }

  // ******************************************Api************************************************************
  Future<void> fetchReviewByDoctorId(String id) async {
    await RemoteProvider().send(
      request: Request(url: '${ApiConstants.reviewEndpoint(doctorId)}'),
      method: RemoteMethod.get,
      onSuccess: (res, statsCode) async {
        try {
          if (res.data['results'].isNotEmpty) {
            await insertReviews(res.data['results']);
          }
        } catch (ex) {
          AppSnackBar.error(
            ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
          );
        }
      },
      onError: (_, statsCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
      },
    );
  }

  Future<void> addReview({required int rating, String? content}) async {
    try {
      await RemoteProvider().send(
        request: Request(
          url: ApiConstants.reviewEndpoint(doctorId),
          body: {"doctor": doctorId, "rating": rating, "content": content},
        ),
        method: RemoteMethod.post,
        onSuccess: (reponse, statusCode) async {
          await insertreview(reponse.data);
          await loadLocalData();
          AppSnackBar.success("success_review_added".tr());
        },
        onError: (_, statusCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
        },
      );
    } catch (_) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  Future<void> updateReview({
    required int reviewId,
    required int rating,
    String? content,
  }) async {
    try {
      await RemoteProvider().send(
        request: Request(
          url: ApiConstants.reviewItemEndpoint(reviewId),
          body: {"rating": rating, "content": content},
        ),
        method: RemoteMethod.put,
        onSuccess: (reponse, statusCode) async {
          await insertreview(reponse.data);
          await loadLocalData();
          AppSnackBar.success("review_updated_successfully".tr());
        },
        onError: (_, statusCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
        },
      );
    } catch (_) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
      await RemoteProvider().send(
        request: Request(url: ApiConstants.reviewItemEndpoint(reviewId)),
        method: RemoteMethod.delete,
        onSuccess: (reponse, statusCode) async {
          await deleteLocalReview(reviewId);
          await loadLocalData();
          AppSnackBar.success("review_deleted_successfully".tr());
        },
        onError: (_, statusCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
        },
      );
    } catch (_) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  // ******************************************db************************************************************
  Future<List<Review>> getReviews() async {
    final reviews =
        await (db.select(db.reviews)
              ..where((tbl) => tbl.doctorId.equals(doctorId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    return reviews;
  }

  insertreview(review) async {
    return await db
        .into(db.reviews)
        .insert(
          Review.fromJson({
            ...review,
            'doctorId': review['doctor'],
            'patientId': review['patient']['user']['id'],
            'patientName': review['patient']['user']['full_name'],
            'patientImage': review['patient']['user']['image'],
            'createdAt': review['created_at'],
            'updatedAt': review['updated_at'],
          }),
          mode: InsertMode.insertOrReplace,
        );
  }

  insertReviews(reviews) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.reviews,
        reviews.map<Review>((review) {
          return Review.fromJson({
            ...review,
            'doctorId': review['doctor'],
            'patientId': review['patient']['user']['id'],
            'patientName': review['patient']['user']['full_name'],
            'patientImage': review['patient']['user']['image'],
            'createdAt': review['created_at'],
            'updatedAt': review['updated_at'],
          });
        }),
      );
    });
  }

  deleteLocalReview(int id) async {
    return await (db.delete(db.reviews)..where((t) => t.id.equals(id))).go();
  }
}
