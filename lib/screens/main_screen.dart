import 'package:flutter/material.dart';
import 'package:whats_app/screens/chat_screen.dart';
import 'package:whats_app/screens/status_screen.dart';
import 'package:whats_app/widgets/drawer.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  Widget bodyContent =  ChatScreen();
  // Future<DocumentSnapshot<Map<String, dynamic>>> get currentUserData async{
  //   return await FirebaseFirestore.instance.collection('users').
  //   doc(_auth.currentUser!.uid).get();
  //
  // }
  @override
  build(BuildContext context) {


    void changeScreen(int index) {
      setState(() {
        selectedIndex = index;
        if (index == 0) {
          bodyContent = ChatScreen();
        }
        if (index == 1) {
          bodyContent = const StatusScreen();
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'My Chat',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.camera,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),

          ],
        ),
        drawer:const AppDrawer(),
        body: bodyContent,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_outlined,
                  color: Colors.black,
                ),
                label: 'Chats,',
                activeIcon: Icon(Icons.chat)),
            BottomNavigationBarItem(
                icon: Icon(Icons.update_outlined), label: 'Updates'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Communities'),
            BottomNavigationBarItem(
                icon: Icon(Icons.phone_outlined),
                activeIcon: Icon(Icons.phone),
                label: 'Calls'),
          ],
          selectedItemColor: Theme.of(context).colorScheme.primary,
          currentIndex: selectedIndex,
          onTap: changeScreen,
          unselectedItemColor: Colors.black,
          useLegacyColorScheme: true,
          showUnselectedLabels: true,
        ));
  }
}
