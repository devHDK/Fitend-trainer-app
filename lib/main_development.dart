import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitend_trainer_app/app.dart';
import 'package:fitend_trainer_app/common/const/data_constants.dart';
import 'package:fitend_trainer_app/common/utils/data_utils.dart';
import 'package:fitend_trainer_app/common/utils/shared_pref_utils.dart';
import 'package:fitend_trainer_app/firebase_options.dart';
import 'package:fitend_trainer_app/firebase_setup.dart';
import 'package:fitend_trainer_app/thread/model/threads/thread_push_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flavors.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  processPushMessage(message);
}

void processPushMessage(RemoteMessage message) async {
  final type = message.data['type'].toString();
  SharedPreferences pref = await SharedPreferences.getInstance();

  debugPrint('type: $type');
  debugPrint('message: ${message.toMap()}');

  final pushData = ThreadPushData.fromJson(message.data);
  if (type.contains('thread')) {
    switch (DataUtils.getThreadPushType(type)) {
      case ThreadPushType.threadCreate:
        await SharedPrefUtils.updateIsNeedUpdate(
            StringConstants.needNotificationUpdate, pref, true);
        await SharedPrefUtils.addOneNeedUpdateList(
          StringConstants.needThreadUpdateUserList,
          pref,
          json.encode(pushData),
        );

        break;
      case ThreadPushType.threadDelete:
        await SharedPrefUtils.addOneNeedUpdateList(
          StringConstants.needThreadDelete,
          pref,
          json.encode(pushData),
        );
        break;
      case ThreadPushType.threadUpdate:
        await SharedPrefUtils.addOneNeedUpdateList(
          StringConstants.needThreadUpdateUserList,
          pref,
          json.encode(pushData),
        );
        await SharedPrefUtils.addOneNeedUpdateList(
          StringConstants.needThreadUpdateList,
          pref,
          json.encode(pushData),
        );
        break;

      default:
        break;
    }
  } else if (type.contains('comment')) {
    switch (DataUtils.getCommentPushType(type)) {
      case CommentPushType.commentCreate:
        await SharedPrefUtils.updateIsNeedUpdate(
            StringConstants.needNotificationUpdate, pref, true);

        await SharedPrefUtils.addOneNeedUpdateList(
          StringConstants.needCommentCreate,
          pref,
          json.encode(pushData),
        );

        break;
      case CommentPushType.commentDelete:
        await SharedPrefUtils.addOneNeedUpdateList(
          StringConstants.needCommentDelete,
          pref,
          json.encode(pushData),
        );
        break;
      case CommentPushType.commentUpdate:
        await SharedPrefUtils.addOneNeedUpdateList(
          StringConstants.needThreadUpdateList,
          pref,
          json.encode(pushData),
        );

        break;

      default:
        break;
    }
  } else if (type.contains('emoji')) {
    switch (DataUtils.getEmojiPushType(type)) {
      case EmojiPushType.emojiCreate:
        final pushData = ThreadPushData.fromJson(message.data);

        await SharedPrefUtils.addOneNeedUpdateList(
            StringConstants.needEmojiCreate,
            pref,
            json.encode(pushData.toJson()));

        var deleteList = SharedPrefUtils.getNeedUpdateList(
            StringConstants.needEmojiDelete, pref);

        final tempList = deleteList;

        for (var emoji in tempList) {
          Map<String, dynamic> emojiMap = jsonDecode(emoji);
          final deleteEmoji = ThreadPushData.fromJson(emojiMap);

          if (deleteEmoji.id == pushData.id &&
              deleteEmoji.userId == pushData.userId) {
            deleteList.remove(json.encode(emojiMap));
          }
        }

        SharedPrefUtils.updateNeedUpdateList(
            StringConstants.needEmojiDelete, pref, deleteList);

        break;
      case EmojiPushType.emojiDelete:
        final pushData = ThreadPushData.fromJson(message.data);
        await SharedPrefUtils.addOneNeedUpdateList(
            StringConstants.needEmojiDelete,
            pref,
            json.encode(pushData.toJson()));

        var createList = SharedPrefUtils.getNeedUpdateList(
            StringConstants.needEmojiCreate, pref);

        final tempList = createList;

        for (var emoji in tempList) {
          Map<String, dynamic> emojiMap = jsonDecode(emoji);
          final deleteEmoji = ThreadPushData.fromJson(emojiMap);

          if (deleteEmoji.id == pushData.id &&
              deleteEmoji.userId == pushData.userId) {
            createList.remove(json.encode(emojiMap));
          }
        }

        SharedPrefUtils.updateNeedUpdateList(
            StringConstants.needEmojiCreate, pref, createList);

        break;

      default:
        break;
    }
  } else if (type.contains('meeting')) {
    //알림, 스케줄 업데이트
    await SharedPrefUtils.updateIsNeedUpdate(
        StringConstants.needNotificationUpdate, pref, true);
    await SharedPrefUtils.updateIsNeedUpdate(
        StringConstants.needScheduleUpdate, pref, true);
  }
}

void showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  AppleNotification? ios = message.notification?.apple;

  if (notification != null && (android != null || ios != null) && !kIsWeb) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body!,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.development;

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //firebase 세팅
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupFlutterNotifications();
  // foreground 수신처리
  FirebaseMessaging.onMessage.listen(
    (message) {
      processPushMessage(message);
      if (Platform.isAndroid) showFlutterNotification(message);
    },
  );

  // background 수신처리
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  runApp(
    ProviderScope(
      child: App(initialMessage: initialMessage),
    ),
  );
}
