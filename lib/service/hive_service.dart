import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:aynaclient/model/user_model.dart';
import 'package:aynaclient/model/chat_message.dart';

class HiveService {
  static final HiveService _HiveService = HiveService._internal();
  static const String _boxName = 'userBox';
  static Box<dynamic>? _box;
  static String? userName;
  factory HiveService() {
    return _HiveService;
  }

  HiveService._internal();
  static Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    final appDocumentDir = await getDirectory();
    Hive.init(appDocumentDir.path);
    await adapterRegistration();
    _box = await Hive.openBox(_boxName);
    await setUsername();
  }

  static Future<Directory> getDirectory() async {
    if (kIsWeb) {
      return Directory(html.window.navigator.vendor);
    }

    return await path_provider.getApplicationDocumentsDirectory();
  }

  static Future<void> adapterRegistration() async {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ChatMessageAdapter());
  }

  static Future<void> saveUsername(User user) async {
    await init();
    userName = user.username;
    await _box!.put('username', user);
  }

  static Future<void> setUsername() async {
    await init();
    userName = (_box!.get('username') as User?)?.username;
  }

  static Future<void> clearDB() async {
    await init();
    await _box!.delete('username');
    await clearChatMessages();
  }

  static Future<void> saveChatMessage(ChatMessage message) async {
    await init();
    final List<ChatMessage> messages = await getChatMessages();
    messages.add(message);
    await _box!.put('chat_messages', messages);
  }

  static Future<List<ChatMessage>> getChatMessages() async {
    await init();
    final List<dynamic>? messages = _box!.get('chat_messages');
    if (messages != null) {
      return messages.cast<ChatMessage>();
    }
    return [];
  }

  static Future<void> clearChatMessages() async {
    await init();
    await _box!.delete('chat_messages');
  }
}
