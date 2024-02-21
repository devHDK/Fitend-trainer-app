import 'package:dio/dio.dart';
import 'package:fitend_trainer_app/common/dio/dio_upload.dart';
import 'package:fitend_trainer_app/thread/model/comment/thread_comment_create_model.dart';
import 'package:fitend_trainer_app/thread/model/comment/thread_comment_get_params_model.dart';
import 'package:fitend_trainer_app/thread/model/comment/thread_comment_model.dart';
import 'package:fitend_trainer_app/thread/model/common/gallery_model.dart';
import 'package:fitend_trainer_app/thread/model/common/thread_trainer_model.dart';
import 'package:fitend_trainer_app/thread/model/emojis/emoji_model.dart';
import 'package:fitend_trainer_app/thread/model/emojis/emoji_params_model.dart';
import 'package:fitend_trainer_app/thread/model/exception/exceptios.dart';
import 'package:fitend_trainer_app/thread/model/thread_family_model.dart';
import 'package:fitend_trainer_app/thread/model/threads/thread_create_model.dart';
import 'package:fitend_trainer_app/thread/model/threads/thread_list_model.dart';
import 'package:fitend_trainer_app/thread/model/threads/thread_model.dart';
import 'package:fitend_trainer_app/thread/provider/thread_provider.dart';
import 'package:fitend_trainer_app/thread/repository/thread_comment_repository.dart';
import 'package:fitend_trainer_app/thread/repository/thread_emoji_repository.dart';
import 'package:fitend_trainer_app/thread/repository/thread_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final threadDetailProvider = StateNotifierProvider.family<
    ThreadDetailStateNotifier,
    ThreadModelBase,
    ThreadFamilyModel>((ref, family) {
  final threadRepository = ref.watch(threadRepositoryProvider);
  final commentRepository = ref.watch(commentRepositoryProvider);
  final emojiRepository = ref.watch(emojiRepositoryProvider);
  final dioUpload = ref.watch(dioUploadProvider);
  final threadListState = ref.watch(threadProvider(family.user).notifier);

  return ThreadDetailStateNotifier(
    family: family,
    threadListState: threadListState,
    threadRepository: threadRepository,
    commentRepository: commentRepository,
    emojiRepository: emojiRepository,
    dioUpload: dioUpload,
  );
});

class ThreadDetailStateNotifier extends StateNotifier<ThreadModelBase> {
  final ThreadFamilyModel family;
  final ThreadStateNotifier threadListState;
  final ThreadRepository threadRepository;
  final ThreadCommentRepository commentRepository;
  final EmojiRepository emojiRepository;
  final Dio dioUpload;

  ThreadDetailStateNotifier({
    required this.family,
    required this.threadListState,
    required this.threadRepository,
    required this.commentRepository,
    required this.emojiRepository,
    required this.dioUpload,
  }) : super(ThreadModelLoading()) {
    getThreadDetail(family: family);
  }

  Future<void> getThreadDetail({required ThreadFamilyModel family}) async {
    try {
      try {
        var thread =
            await threadRepository.getThreadWithId(id: family.threadId);
        var comments = await commentRepository.getComments(
            model: CommentGetListParamsModel(threadId: family.threadId));

        thread.comments = comments.data;

        state = thread.copyWith();
      } on DioException {
        throw CommonException(message: 'not_found');
      }
    } catch (e) {
      debugPrint('$e');
      if (e is CommonException) {
        state = ThreadModelError(message: '삭제된 thread 입니다.');
      } else {
        state = ThreadModelError(message: '데이터를 불러올수 없습니다');
      }
    }
  }

  void addComment({
    required int id,
    required String content,
    required String createdAt,
    List<GalleryModel>? gallery,
    List<EmojiModel>? emojis,
    required ThreadTrainer trainer,
  }) {
    final pstate = state as ThreadModel;

    pstate.comments ??= [];

    final tempComments = [
      ...pstate.comments!,
      ThreadCommentModel(
        id: id,
        threadId: family.threadId,
        content: content,
        createdAt: createdAt,
        gallery: gallery,
        emojis: emojis,
        trainer: trainer,
      ),
    ];

    pstate.comments = tempComments;

    state = pstate;
  }

  void updateThreadWithModel(int threadId, ThreadCreateModel model) {
    if (state is ThreadModel) {
      var pstate = state as ThreadModel;

      pstate = pstate.copyWith(
        title: model.title,
        content: model.content,
        gallery: model.gallery,
      );

      state = pstate.copyWith();
    }
  }

  void updateComment(int commentId, ThreadCommentCreateModel model) async {
    var pstate = state as ThreadModel;

    final index = pstate.comments!.indexWhere((e) => e.id == commentId);

    pstate.comments![index] = pstate.comments![index].copyWith(
      content: model.content,
      gallery: model.gallery,
    );

    state = pstate.copyWith();
  }

  Future<Map<dynamic, dynamic>> updateThreadEmoji(
      int threadId, int trainerId, String inputEmoji) async {
    try {
      final pstate = state as ThreadModel;

      final response = await emojiRepository.putEmoji(
        model: PutEmojiParamsModel(
          emoji: inputEmoji,
          threadId: threadId,
        ),
      );

      Map result = {'type': 'add', 'emojiId': 0};

      if (pstate.emojis != null && pstate.emojis!.isNotEmpty) {
        final emojiIndex = pstate.emojis!.indexWhere((emoji) {
          return emoji.emoji == inputEmoji && emoji.trainerId == trainerId;
        });
        if (emojiIndex == -1) {
          //이모지 추가
          addThreadEmoji(null, trainerId, inputEmoji, response.emojiId);
          result['type'] = 'add';
        } else {
          //이모지 취소
          removeThreadEmoji(null, trainerId, inputEmoji, response.emojiId);
          result['type'] = 'remove';
        }
      } else if (pstate.emojis != null && pstate.emojis!.isEmpty) {
        addThreadEmoji(null, trainerId, inputEmoji, response.emojiId);
        result['type'] = 'add';
      }

      result['emojiId'] = response.emojiId;

      state = pstate;

      return result;
    } catch (e) {
      debugPrint('$e');
      return {'type': 'error'};
    }
  }

  Future<Map<dynamic, dynamic>> updateCommentEmoji(
      int commentId, int trainerId, String inputEmoji) async {
    try {
      final pstate = state as ThreadModel;

      final response = await emojiRepository.putEmoji(
        model: PutEmojiParamsModel(
          emoji: inputEmoji,
          commentId: commentId,
        ),
      );

      final commentIndex =
          pstate.comments!.indexWhere((e) => e.id == commentId);

      Map result = {'type': 'add', 'emojiId': 0};

      if (pstate.comments!.isNotEmpty) {
        final emojiIndex =
            pstate.comments![commentIndex].emojis!.indexWhere((emoji) {
          return emoji.emoji == inputEmoji && emoji.trainerId == trainerId;
        });
        if (emojiIndex == -1) {
          //이모지 추가
          addCommentEmoji(
              null, trainerId, inputEmoji, commentIndex, response.emojiId);
          result['type'] = 'add';
        } else {
          //이모지 취소
          removeCommentEmoji(
              null, trainerId, inputEmoji, commentIndex, response.emojiId);
          result['type'] = 'remove';
        }
      }

      result['emojiId'] = response.emojiId;

      state = pstate;

      return result;
    } catch (e) {
      debugPrint('$e');
      return {'type': 'error'};
    }
  }

  void addThreadEmoji(
      int? userId, int? trainerId, String inputEmoji, int emojiId) {
    final pstate = state as ThreadModel;

    pstate.emojis!.add(
      EmojiModel(
        id: emojiId,
        emoji: inputEmoji,
        userId: userId,
        trainerId: trainerId,
      ),
    );

    state = pstate.copyWith();
  }

  void removeThreadEmoji(
      int? userId, int? trainerId, String inputEmoji, int emojiId) {
    final pstate = state as ThreadModel;
    pstate.emojis!.removeWhere((emoji) {
      return emoji.id == emojiId &&
          (emoji.userId == userId || emoji.trainerId == trainerId);
    });

    state = pstate.copyWith();
  }

  void addCommentEmoji(
      int? userId, int? trainerId, String inputEmoji, int index, int emojiId) {
    final pstate = state as ThreadModel;

    pstate.comments![index].emojis!.add(
      EmojiModel(
        id: emojiId,
        emoji: inputEmoji,
        userId: userId,
        trainerId: trainerId,
      ),
    );

    state = pstate.copyWith();
  }

  void removeCommentEmoji(
      int? userId, int? trainerId, String inputEmoji, int index, int emojiId) {
    final pstate = state as ThreadModel;
    pstate.comments![index].emojis!.removeWhere((emoji) {
      return emoji.id == emojiId &&
          (emoji.userId == userId || emoji.trainerId == trainerId);
    });

    state = pstate.copyWith();
  }

  Future<void> deleteThread() async {
    try {
      await threadRepository.deleteThreadWithId(id: family.threadId);

      if (threadListState.state is ThreadListModel) {
        final pstate = threadListState.state as ThreadListModel;

        final index = pstate.data.indexWhere((e) => e.id == family.threadId);
        if (index != -1) {
          threadListState.removeThreadWithId(family.threadId, index);
        }
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      await commentRepository.deleteCommentWithId(id: commentId);

      threadListState.updateUserCommentCount(family.threadId, -1);

      final pstate = state as ThreadModel;

      final index = pstate.comments!.indexWhere((e) => e.id == commentId);

      pstate.comments!.removeAt(index);

      state = pstate.copyWith();
    } catch (e) {
      debugPrint('$e');
    }
  }
}
