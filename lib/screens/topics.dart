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
            backgroundColor: Theme.of(context).cardColor,
            body: ScrollConfiguration(
                behavior: MyBehavior(),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Theme.of(context).appBarTheme.color,
                      expandedHeight: 200.0,
                      floating: true,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.asset('assets/bg.png', fit: BoxFit.cover,),
                        centerTitle: true,
                        title: Container(
                          // color: Colors.amber,
                          child: Center(
                            child: Image.asset('assets/text.png', fit: BoxFit.contain, width: MediaQuery.of(context).size.width/4,)),
                        ),
                      ),
                      actions: <Widget>[
                        if (theme.getThemeStatus == ThemeStatus.LIGHT)
                          IconButton(
                            icon: Icon(FontAwesomeIcons.moon,
                                color: Colors.white),
                            onPressed: () => theme.setTheme(ThemeStatus.DARK),
                          )
                        else
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.sun,
                              color: Colors.white,
                            ),
                            onPressed: () => theme.setTheme(ThemeStatus.LIGHT),
                          )
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          color: Theme.of(context).appBarTheme.color,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color: Theme.of(context).backgroundColor),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Text(
                                    'Topic',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Divider(),
                                ListView(
                                  primary: true,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: topics
                                      .map((topic) => TopicItem(topic: topic))
                                      .toList(),
                                ),
                                Padding(padding: EdgeInsets.only(bottom: 40),)
                              ],
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                )),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TopicScreen(topic: topic),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (topic.img != 'default.png')
                    FadeInImage.assetNetwork(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      image: topic.img,
                      placeholder: 'assets/covers/default.png',
                      fit: BoxFit.cover,
                    )
                  else
                    Image.asset(
                      'assets/covers/default.png',
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
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
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: BackButton(),
              expandedHeight: 250.0,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: topic.img,
                  child: ImgPlaceholder(
                    img: topic.img,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                title: Text('Welcome '),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        topic.title,
                        style: TextStyle(
                            height: 2,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      TopicProgress(
                        topic: topic,
                      ),
                      QuizList(topic: topic)
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        color: Theme.of(context).cardColor,
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
        fit: BoxFit.cover,
        width: width,
      );
    } else {
      return Image.asset(
        'assets/covers/default.png',
        fit: BoxFit.cover,
        width: width,
      );
    }
  }
}
