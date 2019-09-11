import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qai/screens/article_detail.dart';
import 'package:qai/shared/loader.dart';
import 'package:qai/shared/shared.dart';

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  Firestore _db = Firestore.instance;

  Future getArticle() async {
    QuerySnapshot qn = await _db.collection('article').getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    getArticle();
  }

  navigateToDetail(DocumentSnapshot article) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Article'),
        ),
        body: Container(
          child: FutureBuilder(
              future: getArticle(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Loader(
                      size: 60,
                    ),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text(snapshot.data[index]['title'].toString()),
                          onTap: () => navigateToDetail(snapshot.data[index]),
                        );
                      });
                }
              }),
        ));
  }
}
