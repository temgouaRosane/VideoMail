import 'package:videomail/CustomUI/ButtonCard.dart';
import 'package:videomail/CustomUI/ContactCard.dart';
import 'package:videomail/Model/ChatModel.dart';
//import 'package:videomail/CreateGroup.dart';
import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  SelectContact({Key? key}) : super(key: key);

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  @override
  Widget build(BuildContext context) {
    List<ChatModel> contacts = [
      ChatModel(
          name: "Dev Stack",
          status: "A full stack developer",
          number: "670123489"),
      ChatModel(
          name: "Balram",
          status: "Flutter Developer...........",
          number: "670123489"),
      ChatModel(name: "Saket", status: "Web developer...", number: "670123489"),
      ChatModel(
          name: "Bhanu Dev", status: "App developer....", number: "670123489"),
      ChatModel(
          name: "Collins", status: "Raect developer..", number: "670123489"),
      ChatModel(name: "Kishor", status: "Full Stack Web", number: "670123489"),
      ChatModel(name: "Testing1", status: "Example work", number: "670123489"),
      ChatModel(
          name: "Testing2", status: "Sharing is caring", number: "670123489"),
      ChatModel(name: "Divyanshu", status: ".....", number: "670123489"),
      ChatModel(
          name: "Helper", status: "Love you Mom Dad", number: "670123489"),
      ChatModel(name: "Tester", status: "I find the bugs", number: "670123489"),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Contact",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "256 contacts",
                style: TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  size: 26,
                ),
                onPressed: () {}),
            PopupMenuButton<String>(
              padding: EdgeInsets.all(0),
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (BuildContext contesxt) {
                return [
                  PopupMenuItem(
                    child: Text("Invite a friend"),
                    value: "Invite a friend",
                  ),
                  PopupMenuItem(
                    child: Text("Contacts"),
                    value: "Contacts",
                  ),
                  PopupMenuItem(
                    child: Text("Refresh"),
                    value: "Refresh",
                  ),
                  PopupMenuItem(
                    child: Text("Help"),
                    value: "Help",
                  ),
                ];
              },
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: contacts.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                  onTap: () {
                    /*Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => CreateGroup()));*/
                  },
                  child: ButtonCard(
                    icon: Icons.group,
                    name: "New group",
                  ),
                );
              } else if (index == 1) {
                return ButtonCard(
                  icon: Icons.person_add,
                  name: "New contact",
                );
              }
              return ContactCard(
                contact: contacts[index - 2],
              );
            }));
  }
}
