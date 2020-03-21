import 'package:flutter/material.dart';

import 'screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    TopicsScreen(),
    ArticleScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
      items: [
        BottomNavigationBarItem(
            icon: Image.asset('assets/home.png',width: 30, height: 30,),
            title: Text('Topics')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/task.png',width: 30, height: 30,),
            title: Text('Article')),
        BottomNavigationBarItem(
            icon: Image.asset('assets/profile.png',width: 30, height: 30,),
            title: Text('Profile')),
      ].toList(),
      onTap: (int idx) {
       onTabTapped(idx);
      }
    ),
    );
  }
}