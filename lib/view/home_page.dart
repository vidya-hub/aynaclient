// ignore_for_file: use_build_context_synchronously
import 'package:aynaclient/bloc/socket_cubit/socket_cubit.dart';
import 'package:aynaclient/bloc/socket_cubit/socket_state.dart';
import 'package:aynaclient/service/hive_service.dart';
import 'package:aynaclient/view/login_page.dart';
import 'package:aynaclient/view/utils/char_bubble.dart';
import 'package:aynaclient/view/utils/extensions/context_extensions.dart';
import 'package:aynaclient/view/utils/extensions/spacer_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<SocketCubit>().connect();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> logout() async {
    await HiveService.clearDB();
    await context.bloc<SocketCubit>().disconnect();
    context.pushRemoveUntil(to: const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${HiveService.userName}!"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              logout();
            },
            icon: const Icon(Icons.logout),
          ),
          10.hSpace,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: BlocBuilder<SocketCubit, SocketState>(
                builder: (context, state) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return state.messages.isEmpty
                      ? const Center(
                          child: Text("Messages Are Empty"),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            return ChatBubble(
                              message: state.messages[index].message,
                              isMe: state.messages[index].isMine,
                            );
                          },
                        );
                },
              ),
            ),
            20.vSpace,
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context.bloc<SocketCubit>().send(value);
                        _messageController.clear();
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter a message',
                    ),
                  ),
                ),
                20.hSpace,
                ElevatedButton(
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      context.bloc<SocketCubit>().send(message);
                      _messageController.clear();
                    }
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
