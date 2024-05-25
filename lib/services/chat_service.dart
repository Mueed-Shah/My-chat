import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app/models/message.dart';
class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream(){
    return _firestore.collection("users").snapshots().map((snap) {
       return snap.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();

    });
  }
  Future<void> sendMessage (String receiverID, message) async{
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email! ;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // construct chat room ID for the two users (sorted to insure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    // sort the ids (this ensure the chatroomID is the same for any 2 people)
    ids.sort();
    String chatRoomID = ids.join('_');

    // add new message to database
    await _firestore
    .collection('chat_rooms')
    .doc(chatRoomID)
    .collection('messages')
    .add(newMessage.toMap());
  }

  // get messages
Stream<QuerySnapshot> getMessages(String userID, otherUserID){
    // construct a chatroom ID for the two users
  List<String> ids = [userID, otherUserID];
  ids.sort();
  String chatRoomID = ids.join('_');

  return _firestore
      .collection('chat_rooms')
      .doc(chatRoomID)
      .collection('messages')
      .orderBy('timestamp',descending: false)
      .snapshots();
}
  
}