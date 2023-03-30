
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive_animation/screens/newPages/drawerPage/settings.dart';

import '../../../provider/notification_provider.dart';
import 'bookmark_page.dart';

/// 侧边栏
class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _value = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Drawer(
      child: Column(
        children: [
          //图片改一下
          Image.asset('assets/icons/flyingStudio.png',height: 188,),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('今日新闻'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_rounded),
            title: const Text('通知设置'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('通知设置变更'),
                    content: SizedBox(
                        height: height * .15,
                        width: width * .07,
                        /// 这里还要监听
                        child: Consumer<NotificationProvider>(
                          builder: ((context, value, child) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                        value: true ,
                                        groupValue: _value,
                                        onChanged: (v) {
                                          setState(() {
                                            changeRadioValue(v);
                                          });
                                        }),
                                    SizedBox(width: width * .01),
                                    const Text('开启通知')
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                        value: false,
                                        groupValue: _value,
                                        onChanged: (v) {
                                          setState(() {
                                            changeRadioValue(v);
                                          });
                                        }),
                                    SizedBox(width: width * .01),
                                    const Text('取消通知')
                                  ],
                                ),
                              ],
                            );
                          }),
                        )
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('返回'))
                    ],
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('我的标记'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  BookmarkPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('主题设置'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          Container(
            decoration:
            const BoxDecoration(color: Color.fromARGB(100, 158, 158, 158)),
            width: width * .7,
            height: height * .001,
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('消息'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          Container(
            decoration:
            const BoxDecoration(color: Color.fromARGB(100, 158, 158, 158)),
            width: width * .7,
            height: height * .001,
          ),
          Padding(
            padding: EdgeInsets.only(top: height * .25),
            child: const Text('当前版本 1.0.0'),
          )
        ],
      ),
    );
  }

  void changeRadioValue (var v) {
    context.read<NotificationProvider>().enabled();
    v = context
        .read<NotificationProvider>()
        .disabled;
    _value = !v;
    // print(v);
  }
}
