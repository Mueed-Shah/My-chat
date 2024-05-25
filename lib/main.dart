import 'package:flutter/material.dart';
import 'package:whats_app/screens/auth_screen.dart';
import 'package:whats_app/screens/loading_screen.dart';
import 'package:whats_app/screens/main_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const WhatsAppApp());
}

class WhatsAppApp extends StatelessWidget {
  const WhatsAppApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor:const Color.fromARGB(255, 7, 94, 84))
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges()
          , builder: (ctx,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const LoadingScreen();
            }
            else if(snapshot.hasData){
              return const MainScreen();
            }
            return const AuthenticationScreen();
          })


      // const AuthenticationScreen()
      // const ChatScreen(),
    );
  }
}
