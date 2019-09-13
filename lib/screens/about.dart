import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: Text('about')),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height - 80),
          // color: Colors.amber,
          padding: EdgeInsets.only(top: 30.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 20),),
              Image.asset('assets/logo.png', width: 180),
              Padding(padding: EdgeInsets.only(top: 20),),
              Text('Q-AI', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
              Spacer(),
              Align(alignment: Alignment.bottomCenter,child: Text('1.0.0'),)
            ],
          ),
        ),
      ),
    );
  }
}
