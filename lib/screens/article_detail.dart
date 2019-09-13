import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
        print(document.data['content']);
    return document;
  }

  Widget cover(String img) {
    if (img != null && img != '') {
      return FadeInImage.assetNetwork(
        width: MediaQuery.of(context).size.width,
        height: 250.0,
        fit: BoxFit.cover,
        image: img,
        placeholder: 'assets/covers/default.png',
      );
    } else {
      return Image.asset(
        'assets/covers/default.png',
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
                                  fontSize: 35.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(),
                          MarkdownBody(data: snapshot.data['content'],)
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
    );
  }
}
