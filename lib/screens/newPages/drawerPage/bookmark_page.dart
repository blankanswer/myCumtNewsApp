
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive_animation/model/news_model/newsTypeModel.dart';
import 'package:rive_animation/screens/newPages/contentPages/content_page.dart';

import '../../../main.dart';
import '../../../model/news_model/newsContentModel.dart';
import '../../../model/news_model/newsListModel.dart';
import '../../../provider/bookmark_provider.dart';

class BookmarkPage extends StatefulWidget {
   const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final String myText = '我的标记';

  final NewsListModel _listModel = NewsListModel();
  final NewsTypeModel _typeModel  = NewsTypeModel() ;
  final String schoolUrl =
      'https://xwzx.cumt.edu.cn/_upload/article/images/f4/b1/ccbc653c4480a6dd04fa34e18894/13af0f94-65e1-49f1-9f2c-880e3e51f833.png';
  final String schoolBeautyUrl =
      'https://www.cumt.edu.cn/_upload/article/images/5a/35/b01131c54f4e8b3c5c828d54fd33/b8d76b2f-ab62-4b18-997f-fdad59936515.png';
  // final NewsContentModel _newsContentModel = NewsContentModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      /// 其实这些地方如果用了状态管理就好做了， 但是provider我觉得真心不如vue3的pinia好用，懒得做了
      future: _typeModel.getData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        return Scaffold(
          appBar: AppBar(
            title:  Text(myText),
            centerTitle: true,
          ),
          body: Consumer(builder: ((context, value, child) {
            return box.hasData(myText)
                ? ListView.builder(
                itemCount: box.read(myText).length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CachedNetworkImage(imageUrl: schoolBeautyUrl,),
                      // leading: CachedNetworkImage(imageUrl: context.watch<BookmarkProvider>().bookMark[index].urlToImage.toString()),
                      title: Text(
                        box.read(myText)[index],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context, MaterialPageRoute(builder: (context) => ContentPage(data: context.watch<BookmarkProvider>().bookMark[index], link: _listModel.data!.data![index].link,)));
                      },
                    ),
                  );
                })
                : const Center(
              child: Text(
                '空空如也，快去给喜欢的新闻标记吧~',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            );
          })),
        );
      },

    );
  }
}
