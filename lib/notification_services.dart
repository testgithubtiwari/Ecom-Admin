// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:admin/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // Initialization settings for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        print("onSelectNotification");
        if (id!.isNotEmpty) {
          print("Router Value1234 $id");
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => DemoScreen(
          //       id: id,
          //     ),
          //   ),
          // );
        }
      },
    );
  }

  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const sound = 'pop.mp3';

      String? bigPicturePath;

      int maxRetries = 3;
      int retryCount = 0;

      while (retryCount < maxRetries) {
        try {
          bigPicturePath = await Utils.downloadFile(
            message.notification!.android!.imageUrl!,
            'bigPicture',
          );
          break; // Break the loop if download is successful
        } catch (e) {
          print("Error downloading image: $e");
          retryCount++;
          // Add a delay before retrying (adjust as needed)
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      if (bigPicturePath != null) {
        final styleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
        );
        final AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          "adminNews",
          "adminNewsChannel",
          "This channel is made to give the notifications regarding Admin.",
          icon: "@mipmap/ic_launcher",
          color: Color.fromARGB(157, 20, 21, 22),
          largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
          ledColor: const Color.fromARGB(
              255, 255, 0, 0), // Replace with your desired LED color
          ledOffMs:
              500, // Replace with the duration of the LED off time in milliseconds
          ledOnMs: 1000,
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: styleInformation,
          playSound: true,
          // sound: const UriAndroidNotificationSound("assets/tunes/pop.mp3"),
          enableVibration: false,
        );

        NotificationDetails notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: const IOSNotificationDetails(sound: sound),
        );

        await _notificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
        );
      } else {
        final styleInformation = BigPictureStyleInformation(
          DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        );

        final AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          "adminNews",
          "adminNewsChannel",
          "This channel is made to give the notifications regarding Admin",
          icon: "@mipmap/ic_launcher",
          color: Color.fromARGB(157, 20, 21, 22),
          largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
          ledColor: const Color.fromARGB(
              255, 255, 0, 0), // Replace with your desired LED color
          ledOffMs:
              500, // Replace with the duration of the LED off time in milliseconds
          ledOnMs: 1000,
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: styleInformation,
          playSound: true,
          sound: const UriAndroidNotificationSound("assets/tunes/pop.mp3"),
          enableVibration: false,
        );

        NotificationDetails notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: const IOSNotificationDetails(sound: sound),
        );

        await _notificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
        );
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
