import 'package:aynaclient/model/chat_message.dart';

class SocketState {
  List<ChatMessage> messages = [];

  SocketState({this.messages = const []});

  factory SocketState.initial() {
    return SocketState(messages: []);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocketState &&
          runtimeType == other.runtimeType &&
          messages == other.messages;

  @override
  int get hashCode => messages.hashCode;
}
