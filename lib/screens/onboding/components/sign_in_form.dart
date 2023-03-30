import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

import 'package:rive_animation/screens/newPages/entry_point.dart';

import '../../../utils/login_util/account.dart';
import '../../../utils/login_util/locations.dart';
import '../../../utils/login_util/login.dart';
import '../../../utils/login_util/methods.dart';





class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);



  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  // 各种动画控制器
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;
  late SMITrigger confetti;
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  CumtLoginAccount cumtLoginAccount = CumtLoginAccount();

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  void singIn(BuildContext context) {
    // confetti.fire();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (_formKey.currentState!.validate()) {
          success.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              confetti.fire();
              // Navigate & hide confetti
              Future.delayed(const Duration(seconds: 1), () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewsNavPage(),
                  ),
                );

              });
            },
          );
        } else {
          error.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              reset.fire();

            },
          );
        }
      },
    );
  }

  void singInSucess(BuildContext context) {
    // confetti.fire();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
      () {
        success.fire();
        Future.delayed(
          const Duration(seconds: 2),
          () {
            setState(() {
              isShowLoading = false;
            });
            confetti.fire();
            // Navigate & hide confetti
            Future.delayed(const Duration(seconds: 1), () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewsNavPage(),
                ),
              );
            });
          },
        );
      },
    );
  }

  void singInFail(BuildContext context) {
    // confetti.fire();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 1),
      () {
        error.fire();
        Future.delayed(
          const Duration(seconds: 2),
          () {
            setState(() {
              isShowLoading = false;
            });
            reset.fire();
            // Navigator.pop(context);

          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    /// 监听当前对象监听应用程序生命周期状态的变化，例如应用程序从后台切换到前台或从前台切换到后台
    WidgetsBinding.instance.addObserver(this);

    _usernameController.text = cumtLoginAccount.username!;
    _passwordController.text = cumtLoginAccount.password!;

    //WidgetsBinding.instance.addPostFrameCallback()方法，在widget树构建完成后再执行需要的代码来安全地访问BuildContext，不然直接报错了
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _handleLogin(context);
    });
  }

  //这就是一个监听方法，当应用程序从后台切换到前台（即 state == AppLifecycleState.resumed）时，会调用 _handleLogin(context) 方法来自动登录校园网
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 在resumed的时候自动登录校园网
    if (state == AppLifecycleState.resumed) {
      _handleLogin(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   "Email",
              //   style: TextStyle(
              //     color: Colors.black54,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: buildTextField("账号", _usernameController,
                    showPopButton: true,),

              ),

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: buildTextField("密码", _passwordController,
                    obscureText: true),

              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    logoutBuildElevatedButton(context),
                    selectBuildElevatedButton(context),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: loginBuildElevatedButton(context),
              ),
            ],
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  'assets/RiveAssets/check.riv',
                  fit: BoxFit.cover,
                  onInit: _onCheckRiveInit,
                ),
              )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: _onConfettiRiveInit,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  ElevatedButton selectBuildElevatedButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _showLocationMethodPicker();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        // minimumSize: const Size(double.infinity, 56),
        minimumSize: const Size(125, 56),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      label: Text(
          '${cumtLoginAccount.cumtLoginLocation?.name} ${cumtLoginAccount.cumtLoginMethod?.name}',
      style: const TextStyle(color: Colors.blueAccent)),
      icon: const Icon(
        CupertinoIcons.arrow_up_arrow_down,
        color: Colors.blueAccent,
      ),
    );
  }

  ElevatedButton loginBuildElevatedButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _handleLogin(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        // minimumSize: const Size(double.infinity, 56),
        minimumSize: const Size(double.infinity, 56),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      label: const Text('登 录'),
      icon: const Icon(
        CupertinoIcons.arrow_up_right,
        color: Colors.white,
      ),
    );
  }

  ElevatedButton logoutBuildElevatedButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        _handleLogout(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        // minimumSize: const Size(double.infinity, 56),
        minimumSize: const Size(125, 56),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      icon: const Icon(
        CupertinoIcons.delete,
        color: Colors.blueAccent,
      ),
      label: const Text(
        '注销',
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }

  Widget buildTextField(
      String labelText, TextEditingController textEditingController,
      {obscureText = false, showPopButton = false}) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: textEditingController,
            obscureText: obscureText,
            
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
              icon: obscureText == false ? SvgPicture.asset("assets/icons/email.svg") : SvgPicture.asset("assets/icons/password.svg"),
            ),
          ),
          showPopButton
              ? PopupMenuButton<CumtLoginAccount>(
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  onOpened: () {
                    FocusScope.of(context).unfocus();
                  },
                  onSelected: (account) {
                    setState(() {
                      cumtLoginAccount = account.clone();
                      _usernameController.text = cumtLoginAccount.username!;
                      _passwordController.text = cumtLoginAccount.password!;
                    });
                  },
                  itemBuilder: (context) {
                    return CumtLoginAccount.list.map((account) {
                      return PopupMenuItem<CumtLoginAccount>(
                        value: account,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${account.username}"
                                " ${account.cumtLoginLocation?.name} ${account.cumtLoginMethod?.name}",
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  CumtLoginAccount.removeList(account.clone());
                                  // showSnackBar(context, "删除成功");
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close))
                          ],
                        ),
                      );
                    }).toList();
                  })
              : Container(),
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
      ),
    );

  }

  void _handleLogin(BuildContext context) {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      // showSnackBar(context, '账号或密码不能为空');
      singInFail(context);
      return;
    }
    cumtLoginAccount.username = _usernameController.text.trim();
    cumtLoginAccount.password = _passwordController.text.trim();

    CumtLogin.login(account: cumtLoginAccount).then((value) {
      setState(() {
        showSnackBar(context, value);
        if (value == '登录成功！' || value == '您已登录校园网') {
          singInSucess(context);
        } else {
          singInFail(context);
        }
      });
    });
  }

  void _handleLogout(BuildContext context) {
    CumtLogin.logout(account: cumtLoginAccount).then((value) {
      showSnackBar(context, value);
      if (value != '网络错误(X_X)') {
        singInSucess(context);
      } else {
        singInFail(context);
      }
    });
  }

  void _showLocationMethodPicker() {
    Picker(
        adapter: PickerDataAdapter<dynamic>(pickerData: [
          CumtLoginLocationExtension.nameList,
          CumtLoginMethodExtension.nameList,
        ], isArray: true),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          setState(() {
            cumtLoginAccount
                .setCumtLoginLocationByName(picker.getSelectedValues()[0]);
            cumtLoginAccount
                .setCumtLoginMethodByName(picker.getSelectedValues()[1]);
          });
        }).showModal(context);
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
