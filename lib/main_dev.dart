import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:photopin/core/di/di_setup.dart';
import 'package:photopin/core/router.dart';

import 'firebase_options.dart';

const String hostIp = '192.168.0.32';
const runMode = String.fromEnvironment("mode", defaultValue: 'dev');

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications',
  importance: Importance.max,
);

Future<void> _showNotification(RemoteMessage message) async {
  final androidDetails = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  final platformDetails = NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.data['title'],
    message.data['body'],
    platformDetails,
    payload: jsonEncode(message.data),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드에서도 Firebase 앱이 초기화되어 있어야 합니다
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _showNotification(message);
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  final payload = response.payload;
  if (payload != null) {
    debugPrint('Background notification payload: $payload');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) .env 로드
  await dotenv.load(fileName: 'assets/.env');

  // 2) Firebase 앱 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final String projectId = 'survival-photopin';
  late final String functionsBaseUrl;

  if (Platform.isAndroid) {
    if (runMode == 'device') {
      FirebaseFirestore.instance.useFirestoreEmulator(hostIp, 8080);
      await FirebaseAuth.instance.useAuthEmulator(hostIp, 9099);
      await FirebaseStorage.instance.useStorageEmulator(hostIp, 9199);
      functionsBaseUrl = 'http://$hostIp:5001/$projectId/us-central1';
    } else {
      FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);
      await FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
      await FirebaseStorage.instance.useStorageEmulator('10.0.2.2', 9199);
      functionsBaseUrl = 'http://10.0.2.2:5001/$projectId/us-central1';
    }
  } else {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    functionsBaseUrl = 'http://localhost:5001/$projectId/us-central1';
  }

  getIt.registerSingleton<String>(
    functionsBaseUrl,
    instanceName: 'FunctionsBaseUrl',
  );

  // 3) 로컬 알림 초기화
  const androidInit = AndroidInitializationSettings('photopin_icon');
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: androidInit),
    onDidReceiveNotificationResponse: (resp) {
      if (resp.payload != null) {
        debugPrint('Notification tapped: ${resp.payload}');
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // 4) FCM 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 5) DI 설정 (FirebaseAuth.instance 등 안전히 사용 가능)
  di();

  // 6) 앱 실행
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // 포그라운드 메시지 리스너
    FirebaseMessaging.onMessage.listen(_showNotification);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white38),
      ),
      routerConfig: appRouter,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
