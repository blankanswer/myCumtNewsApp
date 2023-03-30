import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';


import '../../chatPage2.0/chat_list_view.dart';
import '../newPages/entry_point.dart';
import 'components/animated_btn.dart';
import 'components/sign_in_dialog.dart';

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          //用riv来做动画 实际上是叠上去
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            //出现下拉框 该动画页上移50
            top: isShowSignInDialog ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //动画时长
            duration: const Duration(milliseconds: 260),
            // 在安全区域写
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const Spacer(),
                    const SizedBox(
                      width: 200,
                      child: Text(
                        '矿小助',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Poppins",
                            height: 1.2
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 240,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '自动登录',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Intel",
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "你好，矿大人",
                          ),
                          Text("信手拈来的从容，都是厚积薄发的沉淀",),
                          Text("支持文昌南湖双校区校园网自动登录   支持多账号自动保存")
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(
                          const Duration(milliseconds: 400),
                              () {
                            setState(() {
                              isShowSignInDialog = true;
                            });
                            showCustomDialog(
                              context,
                              onValue: (_) {
                                setState(() {
                                  isShowSignInDialog = false;
                                });
                              },
                            );
                          },
                        );
                      },
                      text: '一键登录',
                    ),
                    const SizedBox(height: 20,),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(
                          const Duration(milliseconds: 400),
                              () {
                            setState(() {
                              isShowSignInDialog = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewsNavPage(),
                              ),
                            );
                          },
                        );
                      },
                      text: '矿大新闻',
                    ),const SizedBox(height: 20,),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(
                          const Duration(milliseconds: 400),
                              () {
                            setState(() {
                              isShowSignInDialog = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChatScreen(),
                              ),
                            );
                          },
                        );
                      },
                      text: '与我聊天',
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "忆昔四月春，与君初相识"
                          ),
                          Text('此地同景前，共赏樱满枝'),
                          // Text('今日重来访，不见知音人'),
                          // Text('纵使繁花盛，我心亦伤悲')

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
