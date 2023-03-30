import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rive_animation/entity/newsContentEndity.dart';
import 'package:rive_animation/model/news_model/newsContentModel.dart';

import '../../../entity/newsLIstEntity.dart';
import '../../../provider/bookmark_provider.dart';
import 'content_image.dart';
import 'content_pdf.dart';
import 'content_text.dart';

class ContentPage extends StatefulWidget {
  final String? link;
  const ContentPage({Key? key, required this.link, required this.data})
      : super(key: key);

  final Data data;
  @override
  _ContentPageState createState() => _ContentPageState();
}

// 这里做的缓存主要是切换到后台后也不会被销毁
class _ContentPageState extends State<ContentPage>
    with AutomaticKeepAliveClientMixin {
  final NewsContentModel _newsContentModel = NewsContentModel();
  bool isFollow = false;
  bool isChecked = false;
  final Color _color = const Color.fromARGB(120, 158, 158, 158);
  final Random _random = Random();

  final String schoolUrl =
      'https://xwzx.cumt.edu.cn/_upload/article/images/f4/b1/ccbc653c4480a6dd04fa34e18894/13af0f94-65e1-49f1-9f2c-880e3e51f833.png';
  final String schoolBeautyUrl =
      'https://www.cumt.edu.cn/_upload/article/images/5a/35/b01131c54f4e8b3c5c828d54fd33/b8d76b2f-ab62-4b18-997f-fdad59936515.png';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: isGetData(link: widget.link!),
        builder: ((BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: const BackButton(
                  color: Colors.black54,
                ),
                actions: [
                  InkWell(
                    splashColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                          color: _color,
                          borderRadius: BorderRadius.circular(10)),
                      width: 45,
                      margin: const EdgeInsets.all(7),
                      child: const Center(
                          child: Icon(
                        Icons.share,
                        color: Colors.black,
                      )),
                    ),
                    onTap: () {
                      //  复制链接到剪切板算了
                    },
                  ),
                  Consumer(builder: ((context, value, child) {
                    return InkWell(
                      splashColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(10)),
                        width: 45,
                        margin: const EdgeInsets.all(7),
                        child: Center(
                            child: Icon(
                          context.watch<BookmarkProvider>().isBookMarkerMap[widget.data.title!]!
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Colors.black,
                        )),
                      ),
                      onTap: () {
                        // 这个用来标记用的呗，有点想添加到书架的意思
                        context.read<BookmarkProvider>().toBookmark(widget.data.title!);
                        context
                            .read<BookmarkProvider>()
                            // 这里真的要给我整破防了 share_prefs里面没有setObject的方法，这里存不了对象，只能存个string了，那必然是大咩dusu
                            .addToBookmark(widget.data.title!);

                      },
                    );
                  })),
                  InkWell(
                    splashColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                          color: _color,
                          borderRadius: BorderRadius.circular(10)),
                      width: 45,
                      margin: const EdgeInsets.all(7),
                      child: const Center(
                          child: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      )),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      // height: MediaQuery.of(context).size.height * 1.48,
                      child: Column(
                        children: [
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: const Color.fromARGB(138, 204, 204, 204),
                          //       borderRadius: BorderRadius.circular(20),
                          //       image: DecorationImage(
                          //           image: NetworkImage(schoolBeautyUrl),
                          //           fit: BoxFit.cover)),
                          //   width: 400,
                          //   height: 250,
                          //   margin: const EdgeInsets.only(top: 20),
                          // ),
                          const SizedBox(height: 20),
                          Text(
                            widget.data.title!,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.remove_red_eye,
                                size: 18,
                              ),
                              Text('${_random.nextInt(1000)}'),
                              const Icon(
                                Icons.thumb_up,
                                size: 18,
                              ),
                              Text('${_random.nextInt(100)}'),
                              const Icon(
                                Icons.comment,
                                size: 18,
                              ),
                              Text('${_random.nextInt(100)}'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: width * .9,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          138, 204, 204, 204),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(schoolUrl),
                                          fit: BoxFit.cover)),
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// 数据 记得改
                                    const Text('中国矿业大学新闻网'),
                                    const SizedBox(height: 10),
                                    // Text('${widget.listData.publishedAt!.year}-${widget.listData.publishedAt!.month}-${widget.listData.publishedAt!.day}'),
                                    Text(DateFormat('yyyy-MM-dd').format(
                                      //使用DateTime.parse()方法将字符串转换为DateTime对象
                                        DateTime.parse(widget.data.date!))),
                                  ],
                                ),
                                const Spacer(),

                                /// 这里是模拟订阅，但是抗带新闻一般发布人是谁我都不知道，就懒得mock了
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all(
                                            Colors.black)),
                                    onPressed: () {
                                      setState(() {
                                        isChecked = !isChecked;
                                        isFollow = !isFollow;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(isChecked ? Icons.check : Icons.add),
                                        const SizedBox(width: 5),
                                        Text(isFollow ? '已关注' : '关注')
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          /// 要用flexible包裹一下 限制listView的高度

                        ],
                      ),
                    ),
                  ),

                  ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Widget item = Container();
                        Contents content =
                        snapshot.data!.contents![index];
                        switch (content.type) {
                          case "text":
                            item = ContentText(text: content.content!);
                            break;
                          case "pdf":
                            item = ContentPDF(url: content.content!);
                            break;
                          case "image":
                            item = ContentImage(url: content.content!);
                            break;
                        }
                        return Padding(
                          padding:
                          const EdgeInsets.fromLTRB(18, 10, 10, 10),
                          child: item,
                        );
                      },
                      itemCount: snapshot.data!.contents!.length)
                ]
              ),
            );
          } else {
            //这里写默认样式
            return const Scaffold(
              body: Center(
                child: Text('加载中...'),
              ),
            );
          }
        }));
  }

  /// 这个地方用定时器来做循环网络请求，直到请求到数据
  Future<NewsContentEntity?> isGetData(
      {required String link, int maxRetries = 3}) async {
    NewsContentEntity? data = await _newsContentModel.getData(link: link);
    if (data == null && maxRetries-- > 0) {
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
      return await isGetData(link: widget.link!);
    } else {
      return data;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
