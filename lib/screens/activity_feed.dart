import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_gram/screens/first_page.dart';
import 'package:social_gram/widgets/custom_image.dart';
import 'package:social_gram/widgets/header.dart';
import 'package:social_gram/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    List<ActivityFeedItem> feedItems = [];
    snapshot.docs.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
      // print('Activity feed item: ${doc.data()}');
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: header(context, titleText: "Activity"),
      body: Container(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            return ListView(
              children: snapshot.data,
            );
          },
          future: getActivityFeed(),
        ),
      ),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // like , follow, comment
  final String mediaUrl;
  final String postId;
  final String userProfileImage;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem({
    this.username,
    this.userId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImage,
    this.commentData,
    this.timestamp,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      mediaUrl: doc['mediaUrl'],
      userProfileImage: doc['userProfileImage'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
    );
  }
  configureMediaPreview() {
    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => print('showing post'),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(mediaUrl),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text(" ");
    }

    if (type == 'like') {
      activityItemText = "liked your post";
    } else if (type == 'follow') {
      activityItemText = 'is following you';
    } else if (type == "comment") {
      activityItemText = 'replied : $commentData';
    } else {
      activityItemText = "error '$type' ";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview();
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => print("show user profile"),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' $activityItemText'),
                  ]),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImage),
          ),
          subtitle: Text(
            timeago.format(
              timestamp.toDate(),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
