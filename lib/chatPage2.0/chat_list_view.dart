import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import '../provider/theme_provider.dart';
import 'message.dart';
import 'my_info_card.dart';
import 'package:flutter/src/painting/gradient.dart' as gradient;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = <Message>[
    Message(role: 'assistant', content: '好久不见，是我，你的AI小助手，有什么可以帮助你的吗？')
  ];

  final _textController = TextEditingController();

  // late List<Map<String, String>> _list;

  void _addMessage(String message) async {
    setState(() {
      _messages.insert(0, Message(role: 'user', content: message));
    });
    _textController.clear();

    // _list = _messages.map((e) => {'role':e.role, 'content':e.content}).toList();
    // reverse(_list);

    final dio = Dio();
    dio.options.headers['Authorization'] =
        
        'Bearer sk-xxxxxxx';
    dio.options.headers['Content-Type'] = 'application/json; charset=utf-8';

    final response = await dio.post(
      'https://api.openai.com/v1/chat/completions',
      data: jsonEncode({
        'model': 'gpt-3.5-turbo',
        // 'messages': [
        //   {'role': 'user', 'content': message}
        // ],
        'messages': _messages
            .map((e) => {'role': e.role, 'content': e.content})
            .toList()
            .reversed
            .toList()
      }),
    );
    if (response.statusCode == 200) {
      final json = response.data;
      final String message = json['choices'][0]['message']['content'];
      setState(() {
        _messages.insert(0, Message(role: 'assistant', content: message));
      });
    } else {
      if (kDebugMode) {
        print('Error: ${response.statusMessage}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeProvider>().isDark
          ? ThemeData.dark()
          : ThemeData.light(),
      home: Scaffold(
        appBar: GFAppBar(
          // backgroundColor: Colors.black,
          leading: GFIconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            type: GFButtonType.transparent,
          ),
          title: const Text("BlankAnswer'chat"),
          actions: <Widget>[
            MyInfoCard(),
          ],
        ),
        //多层无限延申组件嵌套，用flexible来替代expanded
        body:
        Stack(
          children: [
            //用rive来做动画,这玩意儿都没有什么中文文档，读着好累
            const RiveAnimation.asset(
              "assets/RiveAssets/chatbot.riv",
              animations: ['Intro','Idle'],
            ),
            // Positioned.fill(
            //   child: BackdropFilter(
            //     filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            //     child: const SizedBox(),
            //   ),
            // ),
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: const gradient.LinearGradient(
                                  colors: [Colors.white, Colors.white70]),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2.0),
                                    blurRadius: 4.0)
                              ]),
                          child: GFListTile(
                            avatar: GFAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: message.role == 'assistant'
                                  ? const AssetImage('assets/icons/ic_launcher.png')
                                  : const AssetImage(
                                  'assets/icons/myHeadImage.jpg'),
                              shape: GFAvatarShape.standard,
                            ),

                            titleText: message.content.trim(),
                            subTitleText: 'tips:长按复制',

                            icon: SizedBox(
                              width: MediaQuery.of(context).size.width * .075,
                              child: IconButton(
                                  icon: const Icon(Icons.favorite),
                                  onPressed: () {},
                                  color: context.watch<ThemeProvider>().isDark
                                      ? Colors.white70
                                      : Colors.black38),
                            ),


                            //实现长按复制
                            onLongPress: () {
                              // Copy the text to clipboard
                              Clipboard.setData(
                                  ClipboardData(text: message.content.trim()));
                              // Show a snackbar to indicate the copy action
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("已复制到剪贴板"),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 5),
                SafeArea(
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: Theme.of(context).cardColor,
                    // ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: TextFormField(
                            onFieldSubmitted: _addMessage,
                            controller: _textController,
                            autofocus: true,
                            cursorColor: context.watch<ThemeProvider>().isDark
                                ? Colors.white70
                                : Colors.black38,
                            textInputAction: TextInputAction.newline,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: '    请向我提问 ~',
                              hintStyle: TextStyle(
                                  color: context.watch<ThemeProvider>().isDark
                                      ? Colors.white70
                                      : Colors.black38,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          // TextField(
                          //   controller: _textController,
                          //   decoration: const InputDecoration(
                          //     hintText: 'Enter a message',
                          //     contentPadding: EdgeInsets.all(16.0),
                          //   ),
                          //   onSubmitted: _addMessage,
                          // ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          color: context.watch<ThemeProvider>().isDark
                              ? Colors.white70
                              : Colors.black38,
                          //避免输入无效信息
                          onPressed: () => _textController.text.trim() != ''
                              ? _addMessage(_textController.text)
                              : {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]

        ),
      ),
    );
  }
}
