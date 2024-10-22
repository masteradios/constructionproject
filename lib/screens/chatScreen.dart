import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiten/models/user.dart';
import 'package:hiten/providers/userProvider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firebasefirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String message = '';
  final messagecontroller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messagecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ModelUser loggeduser = Provider.of<UserProvider>(context).getUser;
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebasefirestore
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MessageText(
                            snapshot.data!.docs[index]['sender'],
                            snapshot.data!.docs[index]['text'],
                            loggeduser!.email.toString(),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text('${snapshot.error}'),
                      ),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }
                return Center(
                  child: Text('No chats'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: messagecontroller,
                    onChanged: (value) {
                      setState(() {
                        message = value;
                      });
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Colors.green),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            width: 1,
                          )),
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: message.trim().isEmpty
                        ? null
                        : () {
                            messagecontroller.clear();
                            _firebasefirestore.collection('messages').add({
                              'text': message,
                              'sender': loggeduser.email,
                              'createdAt': Timestamp.now(),
                            });
                            setState(() {
                              message = '';
                            });
                          },
                    icon: Icon(Icons.telegram),
                    iconSize: 40.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageText extends StatelessWidget {
  MessageText(this.sender, this.text, this.currentUser);

  final String sender;
  final String text;
  final String currentUser;

  @override
  Widget build(BuildContext context) {
    List<String> parts = sender.split("@");
    String senderName = parts[0];
    final bool isCurrentUser = sender == currentUser;
    final BorderRadius borderRadius = isCurrentUser
        ? BorderRadius.only(
            topLeft: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            (senderName),
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Material(
            elevation: 15.0,
            borderRadius: borderRadius,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 20.0,
              ),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 15.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
