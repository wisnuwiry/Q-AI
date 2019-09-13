import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qai/shared/behavior.dart';
import '../services/services.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  @override
  void initState() {
    super.initState();
    auth.getUser.then(
      (user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/topics');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF44A8B2),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/bg.png'), fit: BoxFit.cover)
        ),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            padding: EdgeInsets.all(30),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 250,
                  ),
                  Image.asset(
                    'assets/text.png',
                    width: 250,
                  ),
                  SizedBox(height: 50),
                  LoginButton(
                    color: Theme.of(context).backgroundColor,
                    text: 'LOGIN WITH GOOGLE',
                    icon: FontAwesomeIcons.google,
                    loginMethod: auth.googleSignIn,
                  ),
                  LoginButton(
                    color: Color(0xFF42a5f5),
                      text: 'Continue as Guest', loginMethod: auth.anonLogin)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.text, this.icon, this.color, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlatButton.icon(
          padding: EdgeInsets.all(30),
          icon: Icon(icon, color: Theme.of(context).iconTheme.color),
          color: color,
          onPressed: () async {
            var user = await loginMethod();
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/topics');
            }
          },
          label: Expanded(
            child: Text('$text', textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
