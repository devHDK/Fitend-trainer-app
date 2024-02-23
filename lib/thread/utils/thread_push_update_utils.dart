import 'dart:convert';

import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/utils/shared_pref_utils.dart';
import 'package:fitend_trainer_app/notifications/provider/notification_home_screen_provider.dart';
import 'package:fitend_trainer_app/thread/model/common/thread_user_model.dart';
import 'package:fitend_trainer_app/thread/model/thread_family_model.dart';
import 'package:fitend_trainer_app/thread/model/threads/thread_list_model.dart';
import 'package:fitend_trainer_app/thread/model/threads/thread_model.dart';
import 'package:fitend_trainer_app/thread/model/threads/thread_push_data.dart';
import 'package:fitend_trainer_app/thread/provider/thread_detail_provider.dart';
import 'package:fitend_trainer_app/thread/provider/thread_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThreadUpdateUtils {
  static Future<void> checkThreadNeedUpdate(WidgetRef ref) async {
    final pref = await SharedPreferences.getInstance();

    var isNeedUpdateNoti = SharedPrefUtils.getIsNeedUpdate(
        StringConstants.needNotificationUpdate, pref);

    var threadUpdateUserList = SharedPrefUtils.getNeedUpdateList(
        StringConstants.needThreadUpdateUserList, pref);
    var threadUpdateList = SharedPrefUtils.getNeedUpdateList(
        StringConstants.needThreadUpdateList, pref);
    var threadDeleteList = SharedPrefUtils.getNeedUpdateList(
        StringConstants.needThreadDelete, pref);
    var commentCreateList = SharedPrefUtils.getNeedUpdateList(
        StringConstants.needCommentCreate, pref);
    var commentDeleteList = SharedPrefUtils.getNeedUpdateList(
        StringConstants.needCommentDelete, pref);
    var emojiCreateList = SharedPrefUtils.getNeedUpdateList(
        StringConstants.needEmojiCreate, pref);
    var emojiDeleteList = SharedPrefUtils.getNeedUpdateList(
        StringConstants.needEmojiDelete, pref);

    List<String> userRefreshList = [];
    List<String> detailRefreshedList = [];

    if (isNeedUpdateNoti) {
      print('ThreadUpdateUtils - isNeedUpdateNoti ');
      ref.read(notificationHomeProvider.notifier).updateIsConfirm(false);
    }

    if (threadUpdateUserList.isNotEmpty) {
      for (var pushData in threadUpdateUserList) {
        Map<String, dynamic> pushMap = jsonDecode(pushData);
        final data = ThreadPushData.fromJson(pushMap);

        if (data.userId != null &&
            data.nickname != null &&
            data.gender != null) {
          ref
              .read(threadProvider(
                ThreadUser(
                    id: int.parse(data.userId!),
                    nickname: data.nickname!,
                    gender: data.gender!),
              ).notifier)
              .paginate(startIndex: 0, isRefetch: true);

          userRefreshList.add(pushData);
        }
      }

      // ref.read(notificationHomeProvider.notifier).addBageCount(1);
      ref.read(notificationHomeProvider.notifier).updateIsConfirm(false);

      await SharedPrefUtils.updateNeedUpdateList(
          StringConstants.needThreadUpdateUserList, pref, []);
      await SharedPrefUtils.updateNeedUpdateList(
          StringConstants.needThreadDelete, pref, []);
      threadDeleteList = [];
      debugPrint('[debug] Thread List updated');
    }

    if (threadUpdateList.isNotEmpty) {
      for (var pushData in threadUpdateList) {
        Map<String, dynamic> pushMap = jsonDecode(pushData);
        final data = ThreadPushData.fromJson(pushMap);
        final user = ThreadUser(
          id: int.parse(data.userId!),
          nickname: data.nickname!,
          gender: data.gender!,
        );
        final tempState = ref.read(
          threadProvider(user),
        );

        debugPrint('[debug] Thread List updated');

        final model = tempState as ThreadListModel;
        final index = model.data.indexWhere((thread) {
          return thread.id == int.parse(data.threadId!);
        });

        if (index != -1) {
          ref
              .read(threadDetailProvider(ThreadFamilyModel(
                      threadId: int.parse(data.threadId!), user: user))
                  .notifier)
              .getThreadDetail();

          detailRefreshedList.add(pushData);

          debugPrint('[debug] Thread Detail updated! threadId: $pushData');
        }
      }
      await SharedPrefUtils.updateNeedUpdateList(
          StringConstants.needThreadUpdateList, pref, []);
    }

    if (threadDeleteList.isNotEmpty) {
      for (var pushData in threadDeleteList) {
        if (userRefreshList.contains(pushData)) {
          Map<String, dynamic> pushMap = jsonDecode(pushData);
          final data = ThreadPushData.fromJson(pushMap);
          final user = ThreadUser(
            id: int.parse(data.userId!),
            nickname: data.nickname!,
            gender: data.gender!,
          );

          final tempState = ref.read(threadProvider(user));

          final model = tempState as ThreadListModel;
          final index = model.data.indexWhere((thread) {
            return thread.id == int.parse(data.threadId!);
          });

          if (index != -1) {
            ref
                .read(threadProvider(user).notifier)
                .removeThreadWithId(int.parse(data.threadId!), index);

            debugPrint('[debug] Thread Deleted! threadId: ${data.threadId}');
          }
        }
      }
    }

    if (commentCreateList.isNotEmpty) {
      for (var pushData in commentCreateList) {
        Map<String, dynamic> pushMap = jsonDecode(pushData);
        final data = ThreadPushData.fromJson(pushMap);
        final user = ThreadUser(
          id: int.parse(data.userId!),
          nickname: data.nickname!,
          gender: data.gender!,
        );

        if (ref.read(threadDetailProvider(ThreadFamilyModel(
                threadId: int.parse(data.threadId!),
                user: user))) is ThreadModel &&
            !detailRefreshedList.contains(pushData)) {
          ref
              .read(threadDetailProvider(ThreadFamilyModel(
                      threadId: int.parse(data.threadId!), user: user))
                  .notifier)
              .getThreadDetail();

          detailRefreshedList.add(pushData);

          debugPrint(
              '[debug] Thread Detail updated! threadId: ${data.threadId}');
        }

        // ref.read(notificationHomeProvider.notifier).addBageCount(1);
        ref.read(notificationHomeProvider.notifier).updateIsConfirm(false);

        var tempState = ref.read(threadProvider(user));
        var model = tempState as ThreadListModel;

        int index = model.data
            .indexWhere((thread) => thread.id == int.parse(data.threadId!));

        if (index != -1 && userRefreshList.contains(pushData)) {
          ref
              .read(threadProvider(user).notifier)
              .updateTrainerCommentCount(int.parse(data.threadId!), 1);
        }
      }
      await SharedPrefUtils.updateNeedUpdateList(
          StringConstants.needCommentCreate, pref, []);
      commentCreateList = [];
    }

    if (commentDeleteList.isNotEmpty) {
      for (var pushData in commentDeleteList) {
        Map<String, dynamic> pushMap = jsonDecode(pushData);
        final data = ThreadPushData.fromJson(pushMap);
        final user = ThreadUser(
          id: int.parse(data.userId!),
          nickname: data.nickname!,
          gender: data.gender!,
        );

        if (ref.read(threadDetailProvider(ThreadFamilyModel(
                threadId: int.parse(data.threadId!),
                user: user))) is ThreadModel &&
            !detailRefreshedList.contains(pushData)) {
          ref
              .read(threadDetailProvider(ThreadFamilyModel(
                      threadId: int.parse(data.threadId!), user: user))
                  .notifier)
              .getThreadDetail();

          detailRefreshedList.add(pushData);

          debugPrint(
              '[debug] Thread Detail updated! threadId: ${data.threadId}');
        }

        var tempState = ref.read(threadProvider(user));
        var model = tempState as ThreadListModel;

        int index = model.data
            .indexWhere((thread) => thread.id == int.parse(data.threadId!));

        if (index != -1 && (userRefreshList.contains(pushData))) {
          ref
              .read(threadProvider(user).notifier)
              .updateTrainerCommentCount(int.parse(data.threadId!), -1);
        }
      }
    }

    if (emojiCreateList.isNotEmpty) {
      var tempList = emojiCreateList;

      for (var pushData in tempList) {
        Map<String, dynamic> pushMap = jsonDecode(pushData);
        final data = ThreadPushData.fromJson(pushMap);
        final user = ThreadUser(
          id: int.parse(data.userId!),
          nickname: data.nickname!,
          gender: data.gender!,
        );
        final family = ThreadFamilyModel(
          threadId: int.parse(data.threadId!),
          user: user,
        );

        if (data.commentId == null) {
          //thread에 추가
          if (!userRefreshList.contains(pushData)) {
            final tempState = ref.read(threadProvider(user)) as ThreadListModel;
            int index = tempState.data.indexWhere(
                (element) => element.id == int.parse(data.threadId!));

            ref.read(threadProvider(user).notifier).addEmoji(
                  int.parse(data.userId!),
                  null,
                  data.emoji!,
                  index,
                  int.parse(data.id!),
                );
          }

          if (!detailRefreshedList.contains(pushData)) {
            ref.read(threadDetailProvider(family).notifier).addThreadEmoji(
                  int.parse(data.userId!),
                  null,
                  data.emoji!,
                  int.parse(data.id!),
                );
          }

          debugPrint('[debug] Add Thread Emoji! threadId: ${data.threadId}');
        } else if (data.commentId != null &&
            !detailRefreshedList.contains(data.threadId)) {
          ThreadModel? tempState;
          if (ref.read(threadDetailProvider(family)) is ThreadModel) {
            tempState = ref.read(threadDetailProvider(family)) as ThreadModel;
          }

          if (tempState != null &&
              tempState.comments != null &&
              tempState.comments!.isNotEmpty) {
            final index = tempState.comments!.indexWhere(
                (element) => element.id == int.parse(data.commentId!));

            if (index != -1) {
              ref.read(threadDetailProvider(family).notifier).addCommentEmoji(
                    int.parse(data.userId!),
                    null,
                    data.emoji!,
                    index,
                    int.parse(data.id!),
                  );
            }
          }
          debugPrint('[debug] Add comment Emoji! threadId: ${data.threadId}');
        }

        // emojiCreateList.remove(emoji);
      }

      await SharedPrefUtils.updateNeedUpdateList(
          StringConstants.needEmojiCreate, pref, []);
    }

    if (emojiDeleteList.isNotEmpty) {
      var tempList = emojiDeleteList;

      for (var pushData in tempList) {
        Map<String, dynamic> pushMap = jsonDecode(pushData);
        final data = ThreadPushData.fromJson(pushMap);
        final user = ThreadUser(
          id: int.parse(data.userId!),
          nickname: data.nickname!,
          gender: data.gender!,
        );
        final family = ThreadFamilyModel(
          threadId: int.parse(data.threadId!),
          user: user,
        );

        if (data.commentId == null) {
          //thread에서 삭제
          if (!userRefreshList.contains(pushData)) {
            final tempState = ref.read(threadProvider(user)) as ThreadListModel;
            int index = tempState.data.indexWhere(
                (element) => element.id == int.parse(data.threadId!));

            ref.read(threadProvider(user).notifier).removeEmoji(
                  int.parse(data.userId!),
                  null,
                  data.emoji!,
                  index,
                  int.parse(data.id!),
                );
          }

          if (!detailRefreshedList.contains(data.threadId!)) {
            ref.read(threadDetailProvider(family).notifier).removeThreadEmoji(
                  int.parse(data.userId!),
                  null,
                  data.emoji!,
                  int.parse(data.id!),
                );
          }

          debugPrint('[debug] Delete Thread Emoji! threadId: ${data.threadId}');
        } else if (data.commentId != null &&
            !detailRefreshedList.contains(data.threadId)) {
          ThreadModel? tempState;
          if (ref.read(threadDetailProvider(family)) is ThreadModel) {
            tempState = ref.read(threadDetailProvider(family)) as ThreadModel;
          }

          if (tempState != null &&
              tempState.comments != null &&
              tempState.comments!.isNotEmpty) {
            final index = tempState.comments!.indexWhere(
                (element) => element.id == int.parse(data.commentId!));

            if (index != -1) {
              ref
                  .read(threadDetailProvider(family).notifier)
                  .removeCommentEmoji(
                    int.parse(data.userId!),
                    null,
                    data.emoji!,
                    index,
                    int.parse(data.id!),
                  );
            }
          }
          debugPrint(
              '[debug] Delete Comment Emoji! threadId: ${data.threadId}');
        }

        // emojiDeleteList.remove(emoji);
      }

      await SharedPrefUtils.updateNeedUpdateList(
          StringConstants.needEmojiDelete, pref, []);
    }
  }
}
