import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app/screens/main_screen.dart';
class AppDrawer extends StatelessWidget {
  // final Future<DocumentSnapshot<Map<String, dynamic>>> currentUser;
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    final List<Widget> aboutBoxChildren = <Widget>[
      const SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text:
                "My first app that i am developing just to learn some new features of flutter"
                    " and practise previous ones, and create a better version of whats app that is written "
                    "in dart and can be used on android and ios platform "),
            TextSpan(
                style: textStyle.copyWith(color: theme.colorScheme.primary),
                text: 'https://flutter.dev'),
            TextSpan(style: textStyle, text: '.'),
          ],
        ),
      ),
    ];
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1485290334039-a3c69043e517?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTYyOTU3NDE0MQ&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=300'),
            ),
            accountEmail:const Text("mueed_shah@gmail.com"),
            accountName:const  Text(
              'Mueed',
              style: TextStyle(fontSize: 24.0),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.house),
            title: const Text(
              'Chat Screen',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {

              Navigator.of(context).
              pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen(),));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Log out',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();

            },
          ),
          AboutListTile(
            icon: const Icon(Icons.info),
            applicationIcon: const FlutterLogo(),
            applicationName: "Replica of What's App",
            applicationVersion: 'August 2024',
            applicationLegalese: '\u{a9} 2024 The Abdul Mueed',
            aboutBoxChildren: aboutBoxChildren,
          ),
        ],
      ),
    );
  }
}
