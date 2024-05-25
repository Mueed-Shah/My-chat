import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({required this.message,required this.isCurrentUser,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const  EdgeInsets.only(left: 10,right: 10),
      margin:const EdgeInsets.only(left: 10,top: 7,right: 10),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.teal : Colors.black38,
        borderRadius: isCurrentUser ? const BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25)
        ): const BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25)
        ),
        // border: Border.all(color: Colors.grey),
      ),
      child: Text(message,style:const  TextStyle(fontSize: 18,color: Colors.white),),
    );
  }
}
