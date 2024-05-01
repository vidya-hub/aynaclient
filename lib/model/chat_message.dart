import 'package:hive/hive.dart';

part 'chat_message.g.dart'; // Generated file by Hive

@HiveType(typeId: 1) // Unique typeId for ChatMessage
class ChatMessage extends HiveObject {
  @HiveField(0) // Index 0 for message
  String message;

  @HiveField(1) // Index 1 for isMine
  bool isMine;

  ChatMessage({this.message = "", this.isMine = true});
}
