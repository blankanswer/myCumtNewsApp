 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive_animation/model/news_model/newsTypeModel.dart';

import '../../provider/theme_provider.dart';
import 'list_page.dart';
import 'drawerPage/my_drawer.dart';

class NewsNavPage extends StatefulWidget {
   const NewsNavPage({Key? key}) : super(key: key);

   @override
   State<NewsNavPage> createState() => _NewsNavPageState();
 }

 class _NewsNavPageState extends State<NewsNavPage> with SingleTickerProviderStateMixin {

  bool isSearch = false;
   late final NewsTypeModel _model = NewsTypeModel();
   late final TabController _controller = TabController(
       length: _model.data!.data!.length, vsync: this);

   @override
   Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;
     double height = MediaQuery.of(context).size.height;
     /// 直接在这做主题切换了
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       theme: context.watch<ThemeProvider>().isDark
           ? ThemeData.dark()
           : ThemeData.light(),
       home: FutureBuilder(
           // initialData: null,
           future: _model.getData(),
           builder: (BuildContext context, AsyncSnapshot snapshot) {
             if (snapshot.hasData) {
               return DefaultTabController(length: _model.data!.data!.length,
                   child: Scaffold(
                     resizeToAvoidBottomInset: false,
                     appBar: AppBar(
                       elevation: 0,
                       title: isSearch
                           ? SizedBox(
                         height: height * .04,
                         child:
                         TextFormField(
                           autofocus: true,
                           cursorColor: Colors.white30,
                           decoration: const InputDecoration(
                             hintText: '搜索发现~', hintStyle: TextStyle(
                             color: Colors.white30,
                             fontStyle: FontStyle.italic
                           ),
                             border: InputBorder.none
                           ),
                         ),
                       )
                           : const Center(child: Text('矿大新闻'),),
                       actions: [
                         IconButton(
                           onPressed: () {
                             setState(() {
                               isSearch = !isSearch;
                             });
                           },
                           icon: Icon(isSearch ? Icons.clear : Icons.search),
                           iconSize: 28,
                         ),
                         SizedBox(width: width*.05)
                       ],
                       bottom: TabBar(
                         isScrollable: true,
                         indicator: BoxDecoration(
                           borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(57, 255, 255, 255),
                         ),
                         // 我先不加controller 试一下

                         tabs: _model.data!.data!.map((e) => Tab(
                           text: e.name,
                         )).toList(),
                         labelStyle: const TextStyle(fontSize: 15),
                         indicatorWeight: 3,
                       ),
                     ),
                     drawer: const MyDrawer(),
                     body: TabBarView(
                         children: _model.data!.data!.map((e) => ListPage(type: e.type!)).toList()),
                   )
               );

             } else {
               return const Scaffold(
                 body: Center(
                   child: Text('加载中~'),
                 ),
               );
             }
           }
           ),
     );
   }

 }