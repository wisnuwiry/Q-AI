import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qai/shared/shared.dart';

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _article = [];
  bool _loadingArticle = true;
  int _perPage = 10;

  getArticle() async {
    Query q = _firestore.collection('article').limit(_perPage);
    setState(() {
      _loadingArticle = true;
    });
    QuerySnapshot querySnapshot = await q.getDocuments();
    _article = querySnapshot.documents;
    setState(() {
      _loadingArticle = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Article'),),
      body: _loadingArticle == true
          ? Container(
              child: Center(
                child: Loader(),
              ),
            )
          : Container(
              child: _article.length == 0
                  ? Center(
                      child: Text('No Article'),
                    )
                  : ListView.builder(
                      itemCount: _article.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          contentPadding: EdgeInsets.all(20),
                          title: Text(_article[index]['title']),
                        );
                      },
                    ),
            ),
    );
  }
}
