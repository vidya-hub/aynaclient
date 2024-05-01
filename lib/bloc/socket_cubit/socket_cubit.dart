import 'package:aynaclient/bloc/socket_cubit/socket_state.dart';
import 'package:aynaclient/model/chat_message.dart';
import 'package:aynaclient/service/hive_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketCubit extends Cubit<SocketState> {
  WebSocketChannel? _socket;

  SocketCubit() : super(SocketState.initial());

  Future<void> connect() async {
    _socket = WebSocketChannel.connect(
      Uri.parse('wss://echo.websocket.org'),
    );
    List<ChatMessage> chatMessages = await HiveService.getChatMessages();
    emit(SocketState(messages: chatMessages));
    _socket!.stream.listen((message) {
      ChatMessage chatMessage = ChatMessage(
        isMine: false,
        message: message,
      );
      HiveService.saveChatMessage(chatMessage);
      emit(SocketState(messages: [...state.messages, chatMessage]));
    });
  }

  Future<void> send(String message) async {
    _socket!.sink.add(message);
    ChatMessage chatMessage = ChatMessage(
      isMine: true,
      message: message,
    );
    HiveService.saveChatMessage(chatMessage);
    emit(SocketState(messages: [...state.messages, chatMessage]));
  }

  Future<void> disconnect() async {
    _socket!.sink.close();
  }
}
