import 'dart:math';

import 'package:ai_app/key.dart';
import 'package:ai_app/repo/open_api_repo_impl.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'env/env.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // OpenAI.apiKey ="";
  OpenAI.apiKey = OpenAiKey.value;

  runApp(const MyApp());
}

// lib/env/env.dart

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    OpenAiRepoImpl openAiRepoImpl = OpenAiRepoImpl();

    // openAiRepoImpl.completion(text: "what is flutter").then(
    //   (value) {
    //     print("is image or not");
    //     print(value);
    //   },
    // );
    super.didChangeDependencies();
  }

  bool animete = false;

  List<Message> messages = [];

  bool isResponseReceiving = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      left: false,
      top: false,
      right: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Oepn AI"),
        ),
        body: Stack(
          children: <Widget>[
            messages.isEmpty
                ? Center(
                    child: Text(
                    "Start chat with ai",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ))
                : ListView.builder(
                    itemCount: messages.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 130),
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return messages.isEmpty
                          ? Text(
                              "Start chat with ai",
                              style: Theme.of(context).textTheme.headlineLarge,
                            )
                          : isURl(messages[index].text)
                              ? BubbleNormalImage(
                                  isSender: messages[index].isMe,
                                  id: Random().nextInt(100000).toString(),
                                  image: Image.network(messages[index].text),
                                )
                              : BubbleSpecialTwo(
                                  text: messages[index].text,
                                  color: Colors.indigo.withOpacity(0.2),

                                  isSender: messages[index].isMe,
                                  // ),
                                );
                    },
                  ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isResponseReceiving
                        ? const Center(
                            child: Text(
                              "Getting response",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.indigo),
                            ),
                          )
                        : SizedBox(),
                    MessageBar(
                      onSend: (message) async {
                        setState(() {
                          messages.add(Message(text: message, isMe: true));
                          isResponseReceiving = true;
                        });

                        OpenAiRepoImpl openAiRepoImpl = OpenAiRepoImpl();

                        await openAiRepoImpl.completion(text: message).then(
                          (ai) {
                            setState(() {
                              messages.add(
                                Message(
                                    text: ai ?? "Some thing want wrong",
                                    isMe: false),
                              );
                              isResponseReceiving = false;
                            });
                          },
                        );
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

bool isURl(String url) {
  return RegExp(r'http(s)?://[\w.-]+(/\w+)*(\?\S+)?').hasMatch(url);
}

class Message {
  String text;
  bool isMe;
  Message({required this.text, required this.isMe});
}
