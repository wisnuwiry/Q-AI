import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qai/bloc/theme.dart';
import 'package:qai/shared/behavior.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import '../screens/screens.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopicsScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    ThemeChanger theme = Provider.of<ThemeChanger>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    return FutureBuilder(
      future: Global.topicsRef.getData(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          List<Topic> topics = snap.data;
          return Scaffold(
            body: ScrollConfiguration(
              behavior: MyBehavior(),
              child: NestedScrollView(
                headerSliverBuilder: (context, scrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 200.0,
                      floating: true,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('Welcome ${user.displayName}'),
                      ),
                      actions: <Widget>[
                        if (theme.getTheme == ThemeData.light())
                          IconButton(
                            icon: Icon(FontAwesomeIcons.moon,
                                color: Colors.white),
                            onPressed: () => theme.setTheme(ThemeData.dark()),
                          )
                        else
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.sun,
                              color: Colors.white,
                            ),
                            onPressed: () => theme.setTheme(ThemeData.light()),
                          )
                      ],
                    )
                  ];
                },
                body: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Quiz', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                      GridView.count(
                        primary: false,
                        shrinkWrap: true,
                        crossAxisSpacing: 10.0,
                        crossAxisCount: 2,
                        padding: const EdgeInsets.all(10),
                        physics: NeverScrollableScrollPhysics(),
                        children:
                            topics.map((topic) => TopicItem(topic: topic)).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: AppBottomNav(),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}

class TopicItem extends StatelessWidget {
  final Topic topic;
  const TopicItem({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: topic.img,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => TopicScreen(topic: topic),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (topic.img != 'default.png')
                  FadeInImage.assetNetwork(
                    image: topic.img,
                    placeholder: 'assets/covers/default.png',
                    fit: BoxFit.contain,
                  )
                else
                  Image.asset(
                    'assets/covers/default.png',
                    fit: BoxFit.contain,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          topic.title,
                          style: TextStyle(
                              height: 1.5, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                    ),
                    // Text(topic.description)
                  ],
                ),
                // )
                TopicProgress(topic: topic),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopicScreen extends StatelessWidget {
  final Topic topic;

  TopicScreen({this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(children: [
        Hero(
          tag: topic.img,
          child: ImgPlaceholder(
              img: topic.img, width: MediaQuery.of(context).size.width),
        ),
        Text(
          topic.title,
          style:
              TextStyle(height: 2, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        QuizList(topic: topic)
      ]),
    );
  }
}

class QuizList extends StatelessWidget {
  final Topic topic;
  QuizList({Key key, this.topic});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: topic.quizzes.map((quiz) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 4,
        margin: EdgeInsets.all(4),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => QuizScreen(quizId: quiz.id),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                quiz.title,
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(
                quiz.description,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.subhead,
              ),
              leading: QuizBadge(topic: topic, quizId: quiz.id),
            ),
          ),
        ),
      );
    }).toList());
  }
}

class ImgPlaceholder extends StatelessWidget {
  final String img;
  final double width;
  ImgPlaceholder({this.img, this.width});
  @override
  Widget build(BuildContext context) {
    if (img != 'default.png') {
      return FadeInImage.assetNetwork(
        image: img,
        placeholder: 'assets/covers/default.png',
        fit: BoxFit.contain,
        width: width,
      );
    } else {
      return Image.asset(
        'assets/covers/default.png',
        fit: BoxFit.contain,
        width: width,
      );
    }
  }
}
