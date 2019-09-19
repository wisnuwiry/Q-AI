import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:provider/provider.dart';
import 'package:qai/bloc/theme.dart';
import 'package:qai/screens/screens.dart';
import 'package:qai/shared/behavior.dart';
import 'package:qai/shared/shared.dart';

class ArticleDetailScreen extends StatefulWidget {
  final DocumentSnapshot article;

  ArticleDetailScreen({this.article});

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  Firestore _db = Firestore.instance;

  Future getContent() async {
    var document =
        await _db.document('content/${widget.article.data['content']}').get();
    return document;
  }

  Widget cover(String img) {
    if (img != null && img != '') {
      return FadeInImage.assetNetwork(
        width: MediaQuery.of(context).size.width,
        height: 250.0,
        fit: BoxFit.cover,
        image: img,
        placeholder: 'assets/article.png',
      );
    } else {
      return Image.asset(
        'assets/article.png',
        width: MediaQuery.of(context).size.width,
        height: 250.0,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  void initState() {
    getContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      body: FutureBuilder(
        future: getContent(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Container(
              child: Center(
                child: Loader(
                  size: 60,
                ),
              ),
            );
          } else {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: BackButton(),
                    expandedHeight: 250,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: cover(widget.article.data['cover']),
                    ),
                    actions: <Widget>[
                      if (theme.getThemeStatus == ThemeStatus.LIGHT)
                        IconButton(
                          icon: Icon(Icons.brightness_2, color: Colors.white),
                          onPressed: () => theme.setTheme(ThemeStatus.DARK),
                        )
                      else
                        IconButton(
                          icon: Icon(
                            Icons.brightness_7,
                            color: Colors.white,
                          ),
                          onPressed: () => theme.setTheme(ThemeStatus.LIGHT),
                        )
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.article.data['title'],
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: HtmlView(
                              data: snapshot.data['content'],
                              scrollable: false,
                              onLaunchFail: () {
                                return Text('Failed Load...');
                              },
                            ),
                          )
                        ],
                      )
                    ]),
                  )
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateArticle()));
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
