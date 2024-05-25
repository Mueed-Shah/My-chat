import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app/widgets/chat_bubble.dart';

final _authService = FirebaseAuth.instance;
class UserChat extends StatelessWidget {
  UserChat({super.key,required this.userEmail,
    required this.receiverID});
  final String userEmail;
  final String receiverID;
  // final imageUrl;

  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();

  // send message
  void sendMessage() async{
    //if there is something inside the text-field
    if(_messageController.text.isNotEmpty){
      // send the message
      await _chatService.sendMessage(receiverID, _messageController.text);

      //clear text controller
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,

      // leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      title: Text(userEmail),),
    body: Column(
      children: [
        Expanded(child: _buildMessageList()),

        // user Input
        _buildUserInput()
      ],
    ),
    );
  }

  // build message list
Widget _buildMessageList(){
    String senderID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(stream: _chatService.getMessages(receiverID, senderID),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError){
            return const Text('Error');
          }

          // loading
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        },
    );
}

// build Message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] ==
        _authService.currentUser!.uid;

    //align message to the right if sender is the current user ,otherwise left
    var alignment =
    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
        alignment: alignment,
        child: ChatBubble(isCurrentUser: isCurrentUser,message: data['message'],)
        );
  }

  //build message input
Widget _buildUserInput(){
    return Row(
      children: [
        //text_field should take up most of the space
        Expanded(

            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: TextFormField(

                        decoration:  const InputDecoration(

              hintText: 'Type a message...'
                        ),
                        controller: _messageController,
                        obscureText: false,

                      ),
            )),

        //send button
        Container(
margin: const EdgeInsets.all(10),
          decoration:const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,

          ),
          child: IconButton(

              // color: Colors.black,
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward,

              )),
        )
      ],
    );
}
  
}
