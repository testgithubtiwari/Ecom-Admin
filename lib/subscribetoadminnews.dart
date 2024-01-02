// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';

void subscribeToAdminNews() async {
  await FirebaseMessaging.instance.subscribeToTopic('adminNews');
  print('Subscribed to adminNews topic');
}
