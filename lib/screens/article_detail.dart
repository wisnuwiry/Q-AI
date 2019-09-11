import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    getContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Card(
          child: ListTile(
            title: Text(widget.article.data['title']),
            subtitle: FutureBuilder(
              future: getContent(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loader(
                    size: 60,
                  );
                } else {
                  return Card(
                    child: Text(snapshot.data['content'].toString())
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
