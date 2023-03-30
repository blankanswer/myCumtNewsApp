import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:rive_animation/provider/bookmark_provider.dart';
import 'package:rive_animation/provider/notification_provider.dart';
import 'package:rive_animation/provider/theme_provider.dart';
import 'package:rive_animation/screens/onboding/onboding_screen.dart';
import 'package:rive_animation/utils/login_util/prefs.dart';


void main() async {
  //使用平台通道，显式调用一下 WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  // 获取初始化数据
  await GetStorage.init();
  await Prefs.init();
  runApp( const MyApp());
}


final box = GetStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // changeNotifierProvider用于管理状态和监听对象的变化，变化就会通知下级widget更新
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => BookmarkProvider())
      ],
      child: Consumer(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'The Flutter Way',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFEEF1F8),
              primarySwatch: Colors.blue,
              fontFamily: "Intel",
              //输入框主题
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                errorStyle: TextStyle(height: 0),
                border: defaultInputBorder,
                enabledBorder: defaultInputBorder,
                focusedBorder: defaultInputBorder,
                errorBorder: defaultInputBorder,
              ),
            ),
            home: const OnbodingScreen(),
          );
        }
      ),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
