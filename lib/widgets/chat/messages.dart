import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_bubbles.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, fireSnapsort) {
        if (fireSnapsort.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            builder: (ctx, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDoc = snapshots.data.documents;
              return ListView.builder(
                reverse: true,
                itemCount: chatDoc.length,
                itemBuilder: (ctx, index) => MessageBubbles(
                    chatDoc[index]['text'],
                    chatDoc[index]['userId'] == fireSnapsort.data.uid,
                    chatDoc[index]['userName'],
                    chatDoc[index]['image_url'],
                    key: ValueKey(chatDoc[index].documentID),),
              );
            });
      });
  }
}
