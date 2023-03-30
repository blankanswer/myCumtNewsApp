import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'package:rive_animation/model/news_model/newsListModel.dart';

import '../../entity/newsLIstEntity.dart';
import '../../provider/bookmark_provider.dart';
import 'contentPages/content_page.dart';

class ListPage extends StatefulWidget {
  final String type;

  const ListPage({Key? key, required this.type}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

// 这里做一下缓存
class _ListPageState extends State<ListPage>
    with AutomaticKeepAliveClientMixin {
  bool isFav = true;
  final Random random = Random();
  final String schoolBeautyUrl =
      'https://www.cumt.edu.cn/_upload/article/images/5a/35/b01131c54f4e8b3c5c828d54fd33/b8d76b2f-ab62-4b18-997f-fdad59936515.png';
  final NewsListModel _listModel = NewsListModel();

  final ScrollController _scrollController = ScrollController();
  final StreamController<List> streamController = StreamController<List>.broadcast();
  final List newsListData = [];


  final List<String> randomPhoto = [];
  late final jsonData;
  int curPage = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhotoUrls();
    _loadMoreData();
    // 监听滚动事件
    _scrollController.addListener(() {
      // 判断是否滚动到底部
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // FutureBuilder 里面做下拉刷新不太好做
        Future.delayed(const Duration(milliseconds: 1000),
            _loadMoreData
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // 这里也用到FutureBuilder
    return RefreshIndicator(
      onRefresh: () async {
        _loadMoreData();
      },
      child: StreamBuilder<List>(
          stream: streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // 这里直接用dynamic算了
              final thisData = snapshot.data;
              return LiquidPullToRefresh(
                // 这里真的太麻烦了，必须要传一个没有参数的函数，要么我就只能用状态管理来管理type，不然我的type就只能作为参数传进去呗
                onRefresh: _futureLoadMoreData,
                child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: thisData.length,
                    itemBuilder: (context, index) {
                      // 卡片样式
                      return Consumer<BookmarkProvider>(
                          // builder里面的value 就是这里的BookmarkProvider
                          builder: (context, value, child) {
                        return InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: height * .015,
                                left: width * .04,
                                right: width * .04,
                                // bottom: height * .015
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(45, 158, 158, 158),
                                  borderRadius: BorderRadius.circular(10)),
                              width: width * .34,
                              height: height * .245,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(bottom: height * .025),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10))),
                                      width: width * .38,
                                      height: height * .24,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: index < 30 ? getUrl(index): schoolBeautyUrl,
                                          )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: height * .02),
                                      child: SizedBox(
                                        width: width * .5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width * .03),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: width * .5,
                                                    child: Text(
                                                        /// 数据
                                                        thisData[index].title,
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          wordSpacing: 2,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                  ),
                                                  SizedBox(height: height * .015),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                        ),
                                                        width: width * .06,
                                                        height: height * .038,
                                                        child: ClipOval(
                                                            child:
                                                                CachedNetworkImage(
                                                          imageUrl:
                                                              'https://source.unsplash.com/random/800x600',
                                                          fit: BoxFit.cover,
                                                        )),
                                                      ),
                                                      SizedBox(
                                                          width: width * .02),
                                                      SizedBox(
                                                        width: width * .35,
                                                        child: const Text(
                                                          '中国矿业大学新闻网',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: width * .02),
                                                    IconButton(
                                                        //点赞按钮
                                                        onPressed: () {
                                                          setState(() {
                                                            isFav = !isFav;
                                                          });
                                                        },
                                                        icon: Icon(
                                                          isFav
                                                              ? Icons
                                                                  .thumb_up_outlined
                                                              : Icons.thumb_up,
                                                          size: 18,
                                                        )),
                                                    Text(
                                                      '${random.nextInt(10000)}',
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.comment),
                                                      iconSize: 18,
                                                    ),
                                                    Text(
                                                        '${random.nextInt(10000)}',
                                                        style: const TextStyle(
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(DateFormat('yyyy-MM-dd')
                                                        .format(
                                                            //使用DateTime.parse()方法将字符串转换为DateTime对象
                                                            DateTime.parse(
                                                                thisData[index].date
                                                            ))),
                                                    //这个就不要了吧，感觉好像没特定值
                                                    Text(DateFormat('HH:MM')
                                                        .format(
                                                      DateTime.now(),
                                                      // snapshot
                                                      //     .data!
                                                      //     .articles![index]
                                                      //     .publishedAt!
                                                    ))
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * 0.015,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          onTap: () {
                            context.read<BookmarkProvider>().addToBookMap(thisData[index].title);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContentPage(
                                          /// newsContentPage 数据
                                          link: thisData[index].link,
                                          // link: snapshot.data.data[index].link,
                                          data: thisData[index],
                                        )));
                          },
                        );
                      });
                    }),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(
                child: Center(
                  child: Icon(
                    Icons.restore_page_sharp,
                    size: 45,
                    color: Colors.black,
                  ),
                ),
              );
            }

            /// 默认样式
            else {
              return FirstShimmer(height, width);
            }
          }),
    );
  }

  Future<NewsListEntity?> isGetData(
      {required String type, required int page , int maxRetries = 10}) async {

    NewsListEntity? data = await _listModel.getData(type: widget.type, page: curPage);
    // curItemCount += _listModel.data!.data!.length;
    if (data == null && maxRetries-- > 0) {
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
      print('data == null ${curPage} ${data?.currentPage}');
      return await isGetData(type: widget.type, page :curPage);
    } else {
      curPage ++;
      print(' ${curPage} ${data?.currentPage}');
      return data;
    }
  }

  void getPhotoUrls() async {
    final dio = Dio();
    Response response = await dio.get(
        'https://api.unsplash.com/photos?client_id=Y1Ovs4fgls36zDm9PEG5Yo1VEF8euAW3EFl8qbnryRA&page=${random.nextInt(5)}&per_page=30');
    if (response.statusCode == 200) {
      jsonData = response.data;
      for (int i = 0; i < 30; i++) {
        randomPhoto.add(jsonData[i]['urls']['small']);
        setState(() {});
      }
    }
  }

  String getUrl(int index) {
    return randomPhoto.isEmpty ? schoolBeautyUrl : randomPhoto[index];
  }

  @override
  void dispose() {
    // 销毁时记得释放资源
    _scrollController.dispose();
    super.dispose();
  }

  // 加载更多数据的方法
  Future _loadMoreData() async{
    NewsListEntity? entity = await isGetData(type: widget.type, page: curPage);
    var tempList = entity!.data;
    newsListData.addAll(tempList!);
    streamController.add(newsListData);
    print(curPage);
    print(entity.currentPage);
    // setState(() {});
  }

  Future<void> _futureLoadMoreData() {
    return isGetData(type: widget.type, page: curPage);
  }
}

  ListView FirstShimmer(double height, double width) {
    const Color color = Color.fromARGB(45, 158, 158, 158);

    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.only(
                  top: height * .02, left: width * .04, right: width * .04),
              child: Container(
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(10)),
                  width: width * .34,
                  height: height * .24,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          width: width * .3,
                          height: height * .22,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(color: color),
                                width: width * .1,
                                height: height * .02,
                              ),
                              SizedBox(height: height * .01),
                              Container(
                                decoration: const BoxDecoration(color: color),
                                width: width * .5,
                                height: height * .02,
                              ),
                              SizedBox(height: height * .01),
                              Container(
                                decoration: const BoxDecoration(color: color),
                                width: width * .3,
                                height: height * .02,
                              ),
                              SizedBox(height: height * .02),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 13,
                                    backgroundColor: color,
                                  ),
                                  SizedBox(width: width * .03),
                                  Container(
                                    decoration:
                                        const BoxDecoration(color: color),
                                    width: width * .2,
                                    height: height * .02,
                                  )
                                ],
                              ),
                              SizedBox(height: height * .02),
                              Container(
                                decoration: const BoxDecoration(color: color),
                                width: width * .2,
                                height: height * .02,
                              ),
                            ],
                          ),
                        )
                      ])));
        });
  }

