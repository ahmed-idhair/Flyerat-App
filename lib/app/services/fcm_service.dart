import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  // Singleton instance
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  // Properties
  late final FirebaseMessaging _messaging;
  late final FlutterLocalNotificationsPlugin _localNotifications;

  // Flag to check initialization status
  bool _isInitialized = false;

  // Android notification channel
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  // Callback for receiving foreground notifications
  Function(RemoteMessage)? onMessageCallback;

  // Callback for notification click
  Function(RemoteMessage)? onNotificationOpenedCallback;

  // Initialize notification service
  Future<void> init() async {
    // Check if service is already initialized
    if (_isInitialized) return;

    // Initialize Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // Request notification permissions
    await _requestPermissions();

    // Setup local notifications
    await _setupLocalNotifications();

    // Get device token (FCM token)
    String? token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    // Subscribe to required topics
    await subscribeToTopics();

    // Register notification handlers
    _registerForegroundHandler();
    _registerBackgroundHandler();
    _registerOpenedAppHandler();
    _registerTerminatedAppHandler();

    // Update initialization state
    _isInitialized = true;
  }

  // Request notification permissions
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User notification settings: ${settings.authorizationStatus}');
  }

  // Setup local notifications
  Future<void> _setupLocalNotifications() async {
    _localNotifications = FlutterLocalNotificationsPlugin();

    // Setup notification channels for Android
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
      >()
          ?.createNotificationChannel(channel);
    }

    // Android and iOS initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings
    initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      // onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      //   // Handle local notification if needed
      // },
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
          NotificationResponse notificationResponse,
          ) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          debugPrint('Notification payload: $payload');
          final data = json.decode(payload);
          final message = RemoteMessage.fromMap(data);

          if (onNotificationOpenedCallback != null) {
            onNotificationOpenedCallback!(message);
          }
        }
      },
    );
  }

  // Register foreground notification handler
  void _registerForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.notification?.title}');

      // Show local notification
      _showLocalNotification(message);

      // Execute callback if set
      if (onMessageCallback != null) {
        onMessageCallback!(message);
      }
    });
  }

  // Register background notification handler
  void _registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Register handler for notifications that open the app
  void _registerOpenedAppHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
        'App opened from notification: ${message.notification?.title}',
      );
      if (onNotificationOpenedCallback != null) {
        onNotificationOpenedCallback!(message);
      }
    });
  }

  // Check for notifications that opened the app from terminated state
  Future<void> _registerTerminatedAppHandler() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint(
        'App opened from terminated state: ${initialMessage.notification?.title}',
      );

      if (onNotificationOpenedCallback != null) {
        onNotificationOpenedCallback!(initialMessage);
      }
    }
  }

  // Display a local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null && Platform.isAndroid) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // icon: 'launch_background',
            icon: '@mipmap/ic_launcher',
            // Additional options can be added here
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: json.encode(message.toMap()),
      );
    } else if (notification != null && Platform.isIOS) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: json.encode(message.toMap()),
      );
    }
  }

  // Subscribe to required topics
  Future<void> subscribeToTopics() async {
    // Subscribe to general topic
    await _messaging.subscribeToTopic('general');
    debugPrint('Subscribed to topic: general');
  }

  // Subscribe to country topic
  Future<void> subscribeToCountry(int countryId) async {
    String topic = 'country_$countryId';
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  // Subscribe to city topic
  Future<void> subscribeToCity(int cityId) async {
    String topic = 'city_$cityId';
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  // Subscribe to users topic
  Future<void> subscribeToUsers() async {
    await _messaging.subscribeToTopic('users');
    debugPrint('Subscribed to topic: users');
  }

  // Subscribe to specific user topic
  Future<void> subscribeToUser(int userId) async {
    String topic = 'user_$userId';
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  // Unsubscribe from country topic
  Future<void> unsubscribeFromCountry(int countryId) async {
    String topic = 'country_$countryId';
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  // Unsubscribe from city topic
  Future<void> unsubscribeFromCity(int cityId) async {
    String topic = 'city_$cityId';
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  // Unsubscribe from users topic
  Future<void> unsubscribeFromUsers() async {
    await _messaging.unsubscribeFromTopic('users');
    debugPrint('Unsubscribed from topic: users');
  }

  // Unsubscribe from specific user topic
  Future<void> unsubscribeFromUser(int userId) async {
    String topic = 'user_$userId';
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }

  // Get FCM token
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  // Set callback for foreground notifications
  void setOnMessageCallback(Function(RemoteMessage) callback) {
    onMessageCallback = callback;
  }

  // Set callback for notification clicks
  void setOnNotificationOpenedCallback(Function(RemoteMessage) callback) {
    onNotificationOpenedCallback = callback;
  }
}

// Background notification handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized
  await Firebase.initializeApp();

  debugPrint('Handling background message: ${message.messageId}');
}