import 'package:diagno_bot/core/database/tables/comments_tables.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diagno_bot/core/database/drift_db.dart';

import 'comments.state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final AppDatabase db;
  final int reviewId;

  CommentsCubit({required this.db, required this.reviewId})
    : super(const CommentsState.initial());

  /// 🔹 load all
  Future<void> loadAll() async {
    emit(const CommentsState.loading());
    await loadLocal();
    await loadOnline();
  }

  /// 🔹 local
  Future<void> loadLocal() async {
    final comments =
        await (db.select(db.comments)
              ..where((t) => t.reviewId.equals(reviewId))
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();

    emit(CommentsState.success(comments));
  }

  /// 🔹 online
  Future<void> loadOnline() async {
    if (!await NetworkHelper.isConnected()) return;

    await RemoteProvider().send(
      request: Request(url: ApiConstants.reviewComments(reviewId)),
      method: RemoteMethod.get,
      onSuccess: (res, _) async {
        if (res.data['results'] != null) {
          await insertComments(res.data['results']);
          await loadLocal();
        }
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
      },
    );
  }

  /// ➕ add comment
  Future<void> addComment({
    required String content,
    required CommentType type,
  }) async {
    await RemoteProvider().send(
      request: Request(
        url: ApiConstants.reviewComments(reviewId),
        body: {"review": reviewId, "content": content, "type": type.name},
      ),
      method: RemoteMethod.post,
      onSuccess: (res, _) async {
        await insertComments([res.data]);
        await loadLocal();
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
      },
    );
  }

  /// ✏️ update comment
  Future<void> updateComment({
    required int commentId,
    required String content,
  }) async {
    await RemoteProvider().send(
      request: Request(
        url: ApiConstants.reviewComment(commentId),
        body: {"content": content},
      ),
      method: RemoteMethod.put,
      onSuccess: (res, _) async {
        await db
            .update(db.comments)
            .replace(
              Comment.fromJson({
                ...res.data,
                'reviewId': res.data['review'],
                'userId': res.data['user'],
                'createdAt': res.data['created_at'],
                'updatedAt': res.data['updated_at'],
              }),
            );
        await loadLocal();
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
      },
    );
  }

  /// 🗑️ delete comment
  Future<void> deleteComment(int commentId) async {
    await RemoteProvider().send(
      request: Request(url: ApiConstants.reviewComment(commentId)),
      method: RemoteMethod.delete,
      onSuccess: (_, __) async {
        await (db.delete(db.comments)
          ..where((t) => t.id.equals(commentId))).go();
        await loadLocal();
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
      },
    );
  }

  Future<void> insertComments(List comments) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.comments,
        comments.map((c) {
          return Comment.fromJson({
            ...c,
            'reviewId': c['review'],
            'userId': c['user'],
            'type': CommentTypeConverter().fromSql(c['type']),
            'createdAt': c['created_at'],
            'updatedAt': c['updated_at'],
          });
        }).toList(),
      );
    });
  }
}
