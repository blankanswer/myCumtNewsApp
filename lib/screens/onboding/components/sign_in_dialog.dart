import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sign_in_form.dart';



void showCustomDialog(BuildContext context, {required ValueChanged onValue}) {

  final Uri flyingStudioUri = Uri.parse('https://atcumt.com');
  final Uri flyingStudioFeiShuUri = Uri.parse('https://flyingstudio.feishu.cn/wiki/wikcnx2KKhcZ7Eza3gJq1x0Y4Yg');

  // ignore: no_leading_underscores_for_local_identifiers

  showGeneralDialog(
    context: context,
    barrierLabel: "LoginBarrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    //切换动画持续时间
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Container(
        // height: 620,
        constraints: const BoxConstraints(minHeight: 600,maxHeight: 620),
        margin: const EdgeInsets.only(left: 16,right: 16,top: 200,bottom: 16),
        padding: const EdgeInsets.only(top: 12,bottom: 12, left: 16,right: 16),
        decoration: BoxDecoration(
          //透明登录dialog
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(50),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 30),
              blurRadius: 60,
            ),
            const BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 30),
              blurRadius: 60,
            ),
          ],
        ),
        //dialog里面也可以用脚手架组件来构建页面
        child: Scaffold(
          backgroundColor: Colors.transparent,
          //开始叠甲
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "校园网自动登录",
                      style: TextStyle(
                        fontSize: 34,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 16),
                  //   child: Text(
                  //     "Access to 240+ hours of content. Learn design and code, by building real apps with Flutter and Swift.",
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  const SizedBox(height: 16,),
                  const SignInForm(),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "联系我们",
                          style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 24),
                  //   child: Text(
                  //     "Sign up with Email, Apple or Google",
                  //     style: TextStyle(color: Colors.black54),
                  //   ),
                  // ),
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      infoIconButton(myUri: flyingStudioFeiShuUri ,imageUrl: 'assets/icons/feishu.png',),
                      infoIconButton(myUri: flyingStudioUri ,imageUrl: 'assets/icons/flyingStudio.png',),
                      const infoIconButton(imageUrl: 'assets/icons/qq.png',flag: true,),

                    ],
                  ),
                  // SafeArea(
                  //   child: const Positioned(
                  //     left: 0,
                  //     right: 0,
                  //     bottom: -48,
                  //     child: CircleAvatar(
                  //       radius: 16,
                  //       backgroundColor: Colors.white,
                  //       child: Icon(
                  //         Icons.close,
                  //         size: 20,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              // const Positioned(
              //   left: 0,
              //   right: 0,
              //   bottom: -48,
              //   child: CircleAvatar(
              //     radius: 16,
              //     backgroundColor: Colors.white,
              //     child: Icon(
              //       Icons.close,
              //       size: 20,
              //       color: Colors.black,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: anim, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
  ).then(onValue);
}

class infoIconButton extends StatelessWidget {
  const infoIconButton({
    super.key,
    required this.imageUrl, this.myUri, this.flag,
  });

  final bool? flag;
  final Uri? myUri;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
          boxShadow: [ //阴影
            BoxShadow(
                color:Colors.black26,
                offset: Offset(0,0),
                blurRadius: 12.0
            )
          ]
      ),
      child: IconButton(
        splashRadius: 12,
        onPressed: () {
          if(myUri != null) {
            launchUrl(myUri!);
          }
          if(flag == true) {
            Clipboard.setData(const ClipboardData(text: '839372371'));
            showSnackBar(context, '已复制qq号到剪切板');
          }
        },
        padding: EdgeInsets.zero,
        icon:
        Image.asset(
          imageUrl,
          height: 64,
          width: 64,
        ),
      ),
    );
  }
}

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
      ),
    );
  }

