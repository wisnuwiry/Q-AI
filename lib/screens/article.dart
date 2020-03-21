import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../shared/loader.dart';
import '../shared/shared.dart';
import 'article_detail.dart';

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
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () => navigateToDetail(snapshot.data[index]),
                          child: Container(
                            height: 200.0,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10),
                                color: Theme.of(context).cardColor,
                                child: Row(
                                  children: <Widget>[
                                    cover(snapshot.data[index]['cover']),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                    ),

                                    Container(
                                      height: 164.0,
                                      width: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50) -
                                          MediaQuery.of(context).size.width /
                                              3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index]['title']
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .title
                                                  .color,
                                            ),
                                            softWrap: true,
                                            maxLines: 2,
                                          ),
                                          Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15,
                                                      horizontal: 20),
                                              child: Text('Baca Selengkapnya'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
              }),
        ));
  }

  Widget cover(String img) {
    if (img != null && img != '') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: FadeInImage.assetNetwork(
          width: MediaQuery.of(context).size.width / 3,
          height: 164.0,
          fit: BoxFit.cover,
          image: img,
          placeholder: 'assets/article.png',
        ),
      );
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            'assets/article.png',
            width: MediaQuery.of(context).size.width / 3,
            height: 164.0,
            fit: BoxFit.cover,
          ));
    }
  }
}
