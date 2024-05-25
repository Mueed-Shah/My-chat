import 'package:flutter/material.dart';
import 'package:whats_app/screens/user_chat.dart';
import 'package:whats_app/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final userData = ChatService();
  @override
  Widget build(BuildContext context) {
    return _buildUserList();
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: userData.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error please try later'),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text('Error please try later'),
          );
        }

        List<Map> dataList = snapshot.data!;

        return ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            if (snapshot.data![index]['email'] !=
                FirebaseAuth.instance.currentUser!.email) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(snapshot.data![index]['image_url']),
                ),
                title: Text(snapshot.data![index]['user_name']),
                subtitle: Text('Age: ${snapshot.data![index]['email']}'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserChat(
                      userEmail: snapshot.data![index]['user_name'],
                      // imageUrl: snapshot.data![index]['image_url'],
                      receiverID: snapshot.data![index]['uid'],
                    ),
                  ));
                },
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}
