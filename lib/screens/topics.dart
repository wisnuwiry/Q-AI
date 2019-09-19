import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qai/bloc/theme.dart';
import 'package:qai/shared/behavior.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import '../screens/screens.dart';

class TopicsScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    ThemeChanger theme = Provider.of<ThemeChanger>(context);

    return FutureBuilder(
      future: Global.topicsRef.getData(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          List<Topic> topics = snap.data;
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
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
                            icon: Icon(Icons.brightness_2,
                                color: Colors.white),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    TopicScreen(topic: topic),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).cardColor),
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(25.0)
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (topic.img != 'default.png') ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage.assetNetwork(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  image: topic.img,
                  placeholder: 'assets/topic.png',
                  fit: BoxFit.cover,
                ),
                ) else ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                  'assets/topic.png',
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                ),
              Divider(),
              Center(child: Text(topic.title,style: Theme.of(context).textTheme.title,))
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
      backgroundColor: Theme.of(context).backgroundColor,
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
                title: Text(topic.title),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      topic.description != null ? Text(topic.description, style: TextStyle(fontSize: 20),): Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TopicProgress(
                          topic: topic,
                        ),
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
        placeholder: 'assets/topic.png',
        fit: BoxFit.cover,
        width: width,
      );
    } else {
      return Image.asset(
        'assets/topic.png',
        fit: BoxFit.cover,
        width: width,
      );
    }
  }
}
