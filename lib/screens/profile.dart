import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import '../shared/shared.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService auth = AuthService();

void signOut(BuildContext context) async{
  await auth.signOut();

  Navigator.of(context)
      .pushNamedAndRemoveUntil('/', (route) => false);
}
  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            'Profile',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: ()=> Navigator.pushNamed(context, '/about'),
              child: Icon(Icons.error_outline),
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 30.0)),
                if (user.photoUrl != null)
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: FadeInImage(
                        image: NetworkImage(user.photoUrl),
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                        placeholder: AssetImage('assets/user.png'),
                      ))
                else
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child:Image.asset('assets/user.png', fit: BoxFit.cover,
                        width: 200,
                        height: 200,),
                  ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Text(user.displayName ?? 'Guest',
                    style: Theme.of(context).textTheme.headline),
                Padding(padding: EdgeInsets.only(top: 40.0)),
                if (report != null)
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 3,
                              color: Colors.black12,
                              offset: Offset(1, 5))
                        ]),
                    child: Column(
                      children: <Widget>[
                        Text('${report.total ?? 0}',
                            style: TextStyle(
                              fontSize: 140,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('Quizzes Completed',
                            style: Theme.of(context).textTheme.subhead),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 100),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: CupertinoButton(
                    child: Text('Log Out', style: TextStyle(color: Theme.of(context).textTheme.title.color),),
                    color: Theme.of(context).cardColor,
                    onPressed: () => signOut(context),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return LoadingScreen();
    }
  }
}
