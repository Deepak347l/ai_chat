import '../../model/chat/chats.dart';

class FakeUsers {
  static final List<ChatUserModel> girls = [
    ChatUserModel(name: "Riya", gender: "female", avatar: "👩"),
    ChatUserModel(name: "Aisha", gender: "female", avatar: "👩"),
    ChatUserModel(name: "Neha", gender: "female", avatar: "👩"),
    ChatUserModel(name: "Sara", gender: "female", avatar: "👩"),
  ];

  static final List<ChatUserModel> boys = [
    ChatUserModel(name: "Rahul", gender: "male", avatar: "👨"),
    ChatUserModel(name: "Kabir", gender: "male", avatar: "👨"),
    ChatUserModel(name: "Aman", gender: "male", avatar: "👨"),
    ChatUserModel(name: "Rohit", gender: "male", avatar: "👨"),
  ];
}