import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scheduler_chatbot/model/message.dart';
import 'package:scheduler_chatbot/model/request.dart';
import 'package:scheduler_chatbot/model/response.dart' as r;
import 'package:scheduler_chatbot/service/service.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  List<Message> messages = [];
  TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Service service = Service(Dio(BaseOptions(baseUrl: 'http://127.0.0.1:5000')));

  bool messageLoading = false;

  @override
  void initState() {
    super.initState();
    getWelcomeMessage();
  }

  Future<void> getWelcomeMessage() async {
    setState(() {
      messageLoading = true;
    });
    r.Response? res = await service.getWelcomeMessage();
    setState(() {
      messageLoading = false;
      messages.add(Message(text: res!.response!, isSentByMe: false));
    });
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      messageLoading = true;
      messages.add(Message(text: '', isSentByMe: false));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 150,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    r.Response? res = await service.sendMessage(Request(prompt: message));
    setState(() {
      messages.last.text = res!.response!;
      messageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Scheduler Assistant',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Messages ListView
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Padding(
                  padding: index == messages.length - 1
                      ? const EdgeInsets.only(bottom: 20.0)
                      : EdgeInsets.zero,
                  child: ListTile(
                    title: Align(
                      alignment: message.isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: message.isSentByMe
                              ? Colors.blue[100]
                              : Colors.grey[200],
                        ),
                        child: messageLoading && index == messages.length - 1
                            ? const CircularProgressIndicator()
                            : Text(message.text),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Text input area
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Send a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      // Add message to the list and clear input
                      Message message = Message(
                        text: messageController.text,
                        isSentByMe: true,
                      );
                      setState(() {
                        messages.add(message);
                        messageController.clear();
                      });
                      sendMessage(message.text);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
